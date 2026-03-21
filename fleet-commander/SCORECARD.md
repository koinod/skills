# Fleet Commander Scorecard

> Track agent performance, fleet health, and coordination effectiveness.

---

## Agent Performance (Rolling 7-Day)

| Agent | Tasks Done | Tasks Failed | Reliability | Avg Quality | Avg Latency | Cost Efficiency | Composite |
|-------|-----------|-------------|-------------|-------------|-------------|-----------------|-----------|
| bmo-content-engine | -- | -- | --% | --/1.0 | --ms | -- | --/1.0 |
| bmo-analytics | -- | -- | --% | --/1.0 | --ms | -- | --/1.0 |
| oci-researcher | -- | -- | --% | --/1.0 | --ms | -- | --/1.0 |
| oci-cmo | -- | -- | --% | --/1.0 | --ms | -- | --/1.0 |
| omni-commander | -- | -- | --% | --/1.0 | --ms | -- | --/1.0 |
| sailorsbot1-repflow | -- | -- | --% | --/1.0 | --ms | -- | --/1.0 |

### Composite Score Formula

```
composite = reliability * 0.30 + avg_quality * 0.30 + latency_score * 0.20 + cost_efficiency * 0.20
```

Where:
- **reliability** = tasks_completed / (tasks_completed + tasks_failed)
- **avg_quality** = mean of QA scores on completed tasks
- **latency_score** = 1.0 - (agent_latency / max_acceptable_latency), clamped to [0, 1]
- **cost_efficiency** = estimated_tokens / actual_tokens (>1.0 means under budget)

---

## Fleet Health Metrics

| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| Fleet uptime (all machines) | >95% | --% | -- |
| Average task success rate | >90% | --% | -- |
| Average response time | <10s | --s | -- |
| Escalations per day | <3 | -- | -- |
| Cost per completed task | <10k tokens | -- | -- |
| Tasks completed per day | >20 | -- | -- |
| Cascading failures (7d) | 0 | -- | -- |

---

## Pattern Usage & Effectiveness

| Pattern | Times Used | Success Rate | Avg Cost (tokens) | Avg Duration | Best For |
|---------|-----------|-------------|-------------------|-------------|----------|
| Specialist | -- | --% | -- | -- | Single-agent tasks |
| Pipeline | -- | --% | -- | -- | Sequential processing |
| Scatter-Gather | -- | --% | -- | -- | Research, diverse input |
| Swarm | -- | --% | -- | -- | Batch processing |
| Tournament | -- | --% | -- | -- | High-quality outputs |
| Consensus | -- | --% | -- | -- | Decisions |

---

## Cost Tracking

### This Week

| Category | Tokens Used | Cost (USD) | Notes |
|----------|------------|-----------|-------|
| Local Ollama (qwen2.5:3b) | -- | $0.00 | Always free |
| OpenRouter free tier | -- | $0.00 | Rate limited |
| Claude Code | -- | -- | Included in $20/mo sub |
| **Total** | -- | -- | |

### Budget Rules

1. Local Ollama for: drafts, classification, extraction, QA scoring
2. Claude Code for: complex reasoning, code generation, final synthesis
3. Never use: paid API endpoints until agents generate profit
4. Token budget per task: set at submission, enforced at runtime

---

## Failure Log (Last 7 Days)

| Date | Task ID | Agent | Failure Type | Recovery | Time to Resolve |
|------|---------|-------|-------------|----------|-----------------|
| -- | -- | -- | -- | -- | -- |

### Failure Type Breakdown

| Type | Count (7d) | Trend |
|------|-----------|-------|
| Agent unresponsive | -- | -- |
| Task timeout | -- | -- |
| Low quality output | -- | -- |
| Cost overrun | -- | -- |
| Network partition | -- | -- |
| Cascading failure | -- | -- |

---

## Weekly Review Checklist

- [ ] All agents have heartbeat in last 5 minutes
- [ ] No unresolved escalations
- [ ] Cost within budget
- [ ] Agent scores updated
- [ ] Failed tasks post-mortem'd
- [ ] Shared memory pruned (expired entries removed)
- [ ] Routing weights adjusted based on performance
- [ ] Checkpoint storage cleaned (keep last 3 per task)

---

## Improvement Backlog

| Priority | Improvement | Impact | Effort |
|----------|------------|--------|--------|
| P0 | Populate agent cards in registry | Enables routing | 30 min |
| P0 | Set up heartbeat cron on BMO + OCI | Enables monitoring | 1 hr |
| P1 | Implement task JSON logging | Enables scoring | 2 hr |
| P1 | Auto-restart agent processes via launchd/systemd | Reduces downtime | 2 hr |
| P2 | HTTP API for agent communication | Replaces SSH messages | 1 day |
| P2 | SQLite shared memory store | Replaces file-based memory | 4 hr |
| P3 | Dashboard web UI | Visual monitoring | 2 days |
