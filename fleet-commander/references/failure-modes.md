# Failure Modes Reference

Based on research of 1,642+ production multi-agent execution traces and real-world fleet operations.

---

## Failure Category 1: System Design Issues

### F1.1 — Agent Unresponsive (No Heartbeat)

**Symptoms**: No heartbeat for >3 minutes. SSH connection timeout.

**Root causes**:
- Machine powered off or crashed
- Network cable unplugged / WiFi dropped
- SSH daemon not running
- Agent process crashed silently

**Detection**: Heartbeat monitor flags SUSPECT at 3 min, OFFLINE at 5 min.

**Recovery**:
1. Ping machine. If unreachable, it's a hardware/network issue — escalate.
2. If pingable but SSH fails, the SSH daemon may need restart — escalate.
3. If SSH works but agent process is dead, restart agent remotely:
   ```bash
   dispatch.sh bmo "cd ~/bmo-data && ./start-agent.sh"
   ```
4. Redistribute all tasks from that agent to others.
5. Queue non-urgent tasks for when agent comes back.

**Prevention**: Health check cron every 5 min. Auto-restart agent process via systemd/launchd.

---

### F1.2 — Cost Explosion

**Symptoms**: Token usage 5-10x estimated. Budget depleted mid-task.

**Root causes**:
- Verbose agent producing excessive output
- Retry loops burning tokens without progress
- Scatter-Gather or Tournament pattern used for low-value task
- Model hallucinating long responses
- Missing max_tokens constraint

**Detection**: Budget manager tracks spend per task. Alert at 80% of budget.

**Recovery**:
1. Immediately cap remaining tasks at minimum viable tokens.
2. Switch to cheapest available model (local Ollama).
3. Cancel non-critical subtasks.
4. Review which subtask over-consumed and why.

**Prevention**:
- Always set `max_tokens` per subtask
- Use Specialist pattern by default (1 agent = 1x cost)
- Budget checkpoints at 25%, 50%, 75%
- Never use Tournament for tasks worth less than $10 in output value

---

### F1.3 — Cascading Failure

**Symptoms**: Multiple agents failing simultaneously. Error rate >50%.

**Root causes**:
- Shared dependency down (Ollama server, network, shared memory store)
- Bad input propagating through pipeline
- One agent's failure triggering retries that overload others
- Power outage affecting multiple machines

**Detection**: When >50% of active tasks fail within a 5-minute window.

**Recovery**:
1. **HALT**: Stop all non-critical task dispatching immediately.
2. **Diagnose**: Check shared dependencies (Ollama, network, SSH).
3. **Isolate**: Identify the root cause machine/service.
4. **Fix**: Restore the shared dependency.
5. **Resume**: Replay failed tasks from last checkpoint.
6. **Escalate**: Always notify human of cascading failures.

**Prevention**:
- Anti-affinity: Don't put all critical tasks on one machine
- Circuit breakers on every agent
- Independent Ollama instances per machine (already the case)
- Graceful degradation: if Ollama down on BMO, route to OCI's Ollama

---

## Failure Category 2: Inter-Agent Misalignment

### F2.1 — Goal Drift

**Symptoms**: Agent output diverges from original task goal. Content about solar panels when the task was electric cars.

**Root causes**:
- Long context window filled with irrelevant intermediate messages
- Agent optimizing for subtask metric that conflicts with parent goal
- Prompt not anchoring the goal strongly enough
- Model context window exceeded, early instructions forgotten

**Detection**: Quality gate checks output relevance to original goal, not just subtask spec.

**Recovery**:
1. Reset agent context completely.
2. Re-inject original goal at top of prompt.
3. Reduce context to only essential information.
4. Reassign to a different agent if this one keeps drifting.

**Prevention**:
- Include original goal in every subtask prompt, not just the first one
- Keep agent context under 50% of model's window
- Periodic "goal check" — every 5 messages, re-state the objective
- Quality gates check goal alignment, not just output quality

---

### F2.2 — Contradictory Outputs

**Symptoms**: Agent A says "increase posting frequency" while Agent B says "decrease posting frequency" in the same task.

**Root causes**:
- Agents analyzing different data subsets
- Different interpretation of ambiguous instructions
- One agent has stale information
- Genuine uncertainty — the data supports both conclusions

**Detection**: Shared memory conflict detection when two agents write contradictory facts.

**Recovery**:
1. **Confidence comparison**: Higher confidence wins if delta > 0.2
2. **Recency**: More recent data source wins
3. **Source verification**: Check which agent's data source is more authoritative
4. **Consensus**: If still unresolved, run a Consensus pattern vote
5. **Human escalation**: If consequential decision, always escalate

**Prevention**:
- Ensure all agents work from the same data snapshot
- Define clear ownership — one agent is authoritative per domain
- Run Consensus pattern for important decisions proactively

---

### F2.3 — Conversational Inefficiency

**Symptoms**: Agents exchanging messages without making progress. Token spend increasing with no output.

**Root causes**:
- Unclear task specification leads to clarification loops
- Agents "being polite" — acknowledging without acting
- Circular reasoning between agents
- No termination condition defined

**Detection**: Monitor message count per task. If >10 messages with no task_update showing progress, flag.

**Recovery**:
1. Recall all agents on the task.
2. Rewrite task with explicit, unambiguous instructions.
3. Re-dispatch to single agent (Specialist pattern).
4. Add strict message limit: max 5 exchanges before output required.

**Prevention**:
- Every task has a max_messages limit
- Agents must produce output, not just discuss
- Fleet Commander pattern: agents report to commander, not to each other
- No free-form agent-to-agent chat — structured messages only

---

## Failure Category 3: Task Verification

### F3.1 — Silent Bad Output

**Symptoms**: Agent reports task_complete with good self-score, but output is actually poor.

**Root causes**:
- Self-assessment bias (agents overrate own work)
- Quality criteria not well-defined
- Output looks plausible but contains factual errors
- Agent optimized for form (well-structured) over substance (accurate)

**Detection**: Independent QA scoring by a different agent. Human spot-checks.

**Recovery**:
1. Flag output as unverified.
2. Route to QA agent for independent scoring.
3. If QA fails, reassign original task to different agent.
4. Update reliability score for the original agent.

**Prevention**:
- Never trust self-scores alone
- Cross-agent QA on all client-facing outputs
- Random human audit of 10% of outputs
- Track self-score vs QA-score correlation per agent — penalize consistent overraters

---

### F3.2 — Checkpoint Corruption

**Symptoms**: Task fails, but cannot resume from checkpoint. Previous work lost.

**Root causes**:
- Checkpoint file written to /tmp and machine rebooted
- Disk full, checkpoint write failed silently
- Race condition: two agents writing to same checkpoint
- SSH connection dropped mid-checkpoint-write

**Detection**: Verify checkpoint integrity on read. Check file size > 0, valid JSON.

**Recovery**:
1. Check all checkpoint versions (keep last 3).
2. If all corrupted, restart task from beginning.
3. Log as data loss incident for post-mortem.

**Prevention**:
- Write checkpoints to persistent storage, never /tmp
- Atomic writes: write to temp file, then rename
- Keep 3 checkpoint versions (current, previous, oldest)
- Verify checkpoint integrity immediately after write

---

### F3.3 — Idempotency Violation

**Symptoms**: Task executed twice, producing duplicate outputs or double side effects.

**Root causes**:
- Network timeout caused retry, but first attempt succeeded
- Agent crash after completing task but before sending task_complete
- Commander's ack lost, agent re-sends completion

**Detection**: Duplicate task_id detection. Output deduplication.

**Recovery**:
1. Deduplicate by task_id — only process first completion.
2. If side effects occurred (file writes, API calls), manually verify state.
3. Roll back duplicate effects if possible.

**Prevention**:
- Every task has a unique task_id
- Agents check "did I already complete this?" before executing
- All state changes are idempotent where possible
- At-least-once delivery, exactly-once processing

---

## Failure Category 4: Infrastructure

### F4.1 — Network Partition

**Symptoms**: Some machines reachable, others not. Fleet split into islands.

**Root causes**:
- WiFi router issues
- Machine on different subnet
- Firewall rule change
- ISP outage affecting some but not all connections

**Detection**: Heartbeat failures from subset of machines while others remain healthy.

**Recovery**:
1. Identify which machines are in each partition.
2. Each partition operates independently on its queued tasks.
3. Queue cross-partition tasks for later.
4. When partition heals, sync shared memory and reconcile.

**Prevention**:
- All machines on same LAN switch (not WiFi)
- Static IPs for all fleet machines
- Heartbeat from commander to agents AND agents to commander (bidirectional)

---

### F4.2 — Resource Exhaustion

**Symptoms**: Tasks timing out. High latency. OOM kills.

**Root causes**:
- Too many concurrent tasks on one machine
- Ollama model loaded multiple times
- Disk full from logs/outputs
- Memory leak in long-running agent process

**Detection**: System metrics in heartbeat (cpu_percent, memory_percent). Alert at 80%.

**Recovery**:
1. Stop accepting new tasks on affected machine (`draining` status).
2. Kill non-essential processes.
3. Clean up old logs/outputs.
4. Restart agent process to clear memory leaks.
5. Redistribute queued tasks to healthier machines.

**Prevention**:
- Enforce max_concurrent per agent
- Log rotation (keep 7 days)
- Output cleanup (archive after delivery)
- ONE Ollama model loaded at a time (8GB RAM constraint)
- Monitor disk usage in heartbeat

---

## Recovery Decision Tree

```
Task Failed?
├── Retryable?
│   ├── YES → Retries remaining?
│   │   ├── YES → Retry on same agent (if transient) or different agent
│   │   └── NO → Escalate to human
│   └── NO → Escalate to human
│
├── Agent issue?
│   ├── Agent offline → Reassign to backup agent
│   ├── Agent overloaded → Queue and wait, or route elsewhere
│   └── Agent low quality → Reassign to better agent, downgrade original's score
│
├── Infrastructure issue?
│   ├── Network → Queue task, retry when connection restored
│   ├── Disk full → Clean up, retry
│   └── OOM → Reduce concurrency, retry
│
└── Unknown?
    → Log everything, escalate to human, pause non-critical work
```

---

## Post-Mortem Template

After any significant failure, record:

```markdown
## Failure Post-Mortem: {task_id}

**Date**: YYYY-MM-DD
**Severity**: Low / Medium / High / Critical
**Duration**: How long until resolved

### What happened
One sentence summary.

### Timeline
- HH:MM — First symptom observed
- HH:MM — Detection (automatic or manual)
- HH:MM — Response started
- HH:MM — Root cause identified
- HH:MM — Fix applied
- HH:MM — Confirmed resolved

### Root cause
What actually broke and why.

### Impact
- Tasks affected: N
- Work lost: description
- Cost wasted: N tokens

### What we changed
- Immediate fix applied
- Systemic prevention added

### Lessons
What Fleet Commander should do differently next time.
```
