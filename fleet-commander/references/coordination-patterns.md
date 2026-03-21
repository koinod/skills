# Coordination Patterns Reference

## Pattern Selection Matrix

| Pattern | Best When | Agents Needed | Overhead | Cost | Quality |
|---------|-----------|---------------|----------|------|---------|
| Specialist | Clear best-fit agent exists | 1 | None | Lowest | Agent-dependent |
| Pipeline | Sequential value-add needed | 2-5 | Low | Medium | High (compounding) |
| Scatter-Gather | Diverse perspectives needed | 2-5 | Medium | N * base | High (best-of) |
| Swarm | Large chunked problem | 2-N | Medium | Linear | Consistent |
| Tournament | Maximum quality critical | 3+ | High | N * base + judging | Highest |
| Consensus | Consequential decision | 3+ (odd) | High | N * base | Safest |

---

## Pattern 1: Scatter-Gather

### Architecture

```
Commander
  ├── dispatch(task) → Agent A ──→ result_a
  ├── dispatch(task) → Agent B ──→ result_b
  └── dispatch(task) → Agent C ──→ result_c
                                      ↓
                              synthesize(results)
                                      ↓
                                 final_output
```

### Implementation

```bash
# Scatter phase: dispatch same task to multiple agents
dispatch.sh bmo "research competitor X pricing"
dispatch.sh oci "research competitor X pricing"
# (run in parallel with & and wait)

# Gather phase: collect outputs, pick/merge best
# Synthesis can be done by any agent or by commander
```

### When It Fails

- **Redundant outputs**: All agents return essentially the same thing. Waste of tokens.
  - Fix: Give each agent a different angle ("research pricing", "research positioning", "research reviews")
- **Slow stragglers**: One agent takes 10x longer, blocking synthesis.
  - Fix: Timeout at 2x median. Use best N-1 results.
- **Contradictory facts**: Agent A says price is $99, Agent B says $149.
  - Fix: Flag conflict, verify from source, or use consensus.

### Overhead Analysis

- 3 agents: ~15% overhead (dispatch + synthesis time)
- 5 agents: ~25% overhead
- Beyond 5: diminishing returns, overhead exceeds diversity benefit

---

## Pattern 2: Pipeline

### Architecture

```
input → [Stage 1: Extract] → [Stage 2: Transform] → [Stage 3: Enrich] → [Stage 4: QA] → output
            Agent A              Agent B                Agent C            Agent D
```

### Stage Definition

Each stage specifies:
```json
{
  "stage_id": "extract",
  "capability_required": "transcript-processing",
  "input_schema": "raw_transcript",
  "output_schema": "structured_moments",
  "quality_gate": 0.80,
  "timeout_seconds": 120,
  "retry_count": 2
}
```

### Real-World Pipeline: Transcript to Post

```
Stage 1 — Moment Extraction (BMO)
  Input: Raw sales call recording transcript
  Output: Top 5 viral moments with timestamps, hooks, emotional peaks
  Quality gate: Must identify at least 3 moments with hook potential > 0.7

Stage 2 — Content Brief (OCI)
  Input: Extracted moments
  Output: Dual-page content brief (personal brand + biz value)
  Quality gate: Must follow brand guide rules, include CTA

Stage 3 — Post Writing (BMO)
  Input: Content brief
  Output: Final post copy (hook, body, CTA) for both pages
  Quality gate: QA score >= 0.85 on all 7 dimensions

Stage 4 — Formatting & Scheduling (Omni)
  Input: Final post copy
  Output: Formatted for delivery, scheduled in content calendar
  Quality gate: All links valid, media referenced exists
```

### When It Fails

- **Bottleneck stage**: One slow stage blocks everything downstream.
  - Fix: Parallelize stages that don't depend on each other. Add timeout + reassign.
- **Quality cascade**: Bad output at stage 1 poisons everything after.
  - Fix: Quality gate at every stage. Fail fast, don't waste downstream compute.
- **Context loss**: Later stages don't have enough context from earlier ones.
  - Fix: Pass full context chain, not just immediate output. Or use shared memory.

---

## Pattern 3: Swarm

### Architecture

```
         problem
            ↓
    ┌── chunk_fn() ──┐
    ↓       ↓        ↓
 chunk_1  chunk_2  chunk_3
    ↓       ↓        ↓
 agent_a  agent_b  agent_c
    ↓       ↓        ↓
 result_1 result_2 result_3
    ↓       ↓        ↓
    └── merge_fn() ──┘
            ↓
       final_result
```

### Chunking Strategies

| Problem Type | Chunk Strategy | Example |
|---|---|---|
| Batch processing | Split by count | 50 transcripts → 5 batches of 10 |
| Research | Split by topic | Market analysis → pricing, competitors, trends, tech |
| Content creation | Split by unit | 7 posts → 1 per agent |
| Data analysis | Split by time range | 12 months data → 4 quarters |
| Code tasks | Split by module | 8 API endpoints → 2 per agent |

### Merge Strategies

- **Concatenation**: Simple append (for independent chunks like batch processing)
- **Deduplication**: Remove overlapping findings (for research)
- **Ranking**: Score and order (for content generation)
- **Aggregation**: Statistical summary (for data analysis)
- **Integration**: Resolve dependencies (for code)

### When It Fails

- **Uneven chunks**: One chunk is 10x harder than others. One agent overloaded.
  - Fix: Dynamic rebalancing. Monitor progress, redistribute if one agent finishes early.
- **Merge conflicts**: Chunks produce contradictory or overlapping results.
  - Fix: Define chunk boundaries clearly. Use shared memory for cross-chunk coordination.
- **Order dependency**: Chunks aren't actually independent.
  - Fix: Switch to Pipeline pattern. Or identify and handle dependencies explicitly.

---

## Pattern 4: Tournament

### Architecture

```
Round 1 (Generation):
  Agent A → output_a
  Agent B → output_b
  Agent C → output_c

Round 2 (Head-to-Head):
  Judge: output_a vs output_b → winner: output_a
  output_c gets bye

Round 3 (Final):
  Judge: output_a vs output_c → WINNER: output_c

Optional Round 4 (Refinement):
  Best agent refines output_c with feedback from losing entries
```

### Judging Criteria

```json
{
  "criteria": [
    { "dimension": "accuracy", "weight": 0.25 },
    { "dimension": "clarity", "weight": 0.20 },
    { "dimension": "actionability", "weight": 0.20 },
    { "dimension": "brand_alignment", "weight": 0.20 },
    { "dimension": "originality", "weight": 0.15 }
  ],
  "judge": "fleet-commander",
  "min_score_to_advance": 0.70
}
```

### When to Use

- Client-facing deliverables
- First impression content (cold DMs, pitches)
- High-stakes decisions where "good enough" isn't enough
- When you suspect one agent is significantly better but aren't sure which

### When It Fails

- **Judge bias**: If judge agent has a systematic preference.
  - Fix: Blind judging (strip agent names). Or use multiple judges.
- **Cost explosion**: 4 agents + 3 judging rounds = 7 LLM calls for 1 output.
  - Fix: Only use for tasks where the output value justifies 7x cost.

---

## Pattern 5: Consensus

### Architecture

```
Question: "Should we change Bryson's posting frequency from 2x/day to 1x/day?"

Agent A (BMO): YES — engagement per post up 34% when less frequent
Agent B (OCI): NO — algorithm rewards frequency, total reach will drop
Agent C (Omni): YES — quality > quantity, current pace burning out content pipeline

Weighted Vote:
  YES: 0.87 * 0.3 + 0.82 * 0.3 = 0.507
  NO:  0.91 * 0.3 = 0.273

Result: YES wins (0.507 > 0.273), 65% weighted confidence
Threshold: 0.66 → NOT MET → ESCALATE TO HUMAN with all reasoning
```

### Voting Mechanics

- Each agent votes independently (no seeing others' votes)
- Vote weight = agent's reliability score for that task type
- Supermajority threshold configurable (default 66%)
- If threshold not met → escalate with all votes and reasoning attached
- Ties → always escalate

### When It Fails

- **Groupthink**: All agents trained on similar data produce same answer.
  - Fix: Ensure agents have different context/prompts. Or assign devil's advocate role.
- **Wrong consensus**: Majority can be wrong.
  - Fix: Always escalate consequential decisions. Consensus = recommendation, not final answer.

---

## Pattern 6: Specialist

### Architecture

```
task → lookup(capability) → best_agent → dispatch → result
```

### The default pattern. Zero coordination overhead.

Specialist routing is what Fleet Commander does 80% of the time. Most tasks have a clear best-fit agent. The other patterns are for the 20% of tasks that benefit from multi-agent approaches.

### Agent Specialties (Current Fleet)

| Agent | Top Specialties | Reliability |
|---|---|---|
| BMO Content Engine | content-generation (0.92), qa-scoring (0.89), transcript-processing (0.88) | 0.87 |
| BMO Analytics | performance-analysis (0.90), trend-detection (0.85) | 0.84 |
| OCI Researcher | market-research (0.88), competitor-analysis (0.86), data-synthesis (0.83) | 0.91 |
| OCI CMO | strategy (0.87), campaign-planning (0.84) | 0.89 |
| Omni Commander | orchestration (0.95), code (0.90), complex-reasoning (0.93) | 0.94 |
| SailorsBot1 RepFlow | crm-management (0.85), client-comms (0.82) | 0.80 |

### Fallback Chain

If the specialist is offline:
1. Check for second-best agent with >0.7 capability score
2. If found, route with `degraded=True` flag (output may be lower quality)
3. If not found, queue task and wait (up to deadline)
4. If deadline approaching, escalate to human

---

## Pattern Selection Algorithm

```
SELECT_PATTERN(task):
  # Rule 1: If one agent is clearly best (score > 0.85 and 0.15+ ahead of #2)
  if specialist_obvious(task):
    return SPECIALIST

  # Rule 2: If task is decomposable into independent chunks
  if task.chunked and chunks_independent(task):
    return SWARM

  # Rule 3: If task has sequential stages
  if task.stages and stages_dependent(task):
    return PIPELINE

  # Rule 4: If task needs diverse perspectives
  if task.needs_diversity:
    return SCATTER_GATHER

  # Rule 5: If task is consequential decision
  if task.consequential:
    return CONSENSUS

  # Rule 6: If maximum quality required and budget allows
  if task.quality_critical and budget_allows(task, tournament_cost):
    return TOURNAMENT

  # Default
  return SPECIALIST
```
