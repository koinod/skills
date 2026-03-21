# Fleet Commander

**KOINO Capital's multi-agent orchestration engine.**

Fleet Commander coordinates AI agents across distributed machines, managing task decomposition, intelligent routing, shared memory, failure recovery, and cost optimization.

## Quick Start

```bash
# Check fleet health
./scripts/fleet-status.sh

# Dispatch a command to all machines
./scripts/dispatch.sh all "uptime"

# Dispatch to a specific machine
./scripts/dispatch.sh bmo "ls ~/bmo-data/logs/"
```

## Fleet Topology

| Machine | Role | Architecture | IP |
|---------|------|-------------|-----|
| Omni (Dell WSL2) | CEO / Commander | x86_64 | localhost |
| BMO (Mac Mini) | Bryson Brain / Specialist | ARM64 | 192.168.1.98 |
| OCI (Mac Mini) | Workhorse / C-Suite | x86_64 | 192.168.1.92 |
| SailorsBot1 (Mac Mini) | Client Ops / RepFlow | x86_64 | 192.168.1.99 |

## Coordination Patterns

1. **Scatter-Gather** — Same task to N agents, synthesize best results
2. **Pipeline** — Sequential processing chain, each agent adds value
3. **Swarm** — Chunk a large problem, distribute, merge
4. **Tournament** — Agents compete, best output wins
5. **Consensus** — Agents vote, weighted by reliability score
6. **Specialist** — Route directly to the one best agent

## Key Files

| File | Purpose |
|------|---------|
| `SKILL.md` | Complete orchestration system specification |
| `references/coordination-patterns.md` | Detailed pattern implementations |
| `references/communication-protocol.md` | Message format, handshake, status codes |
| `references/failure-modes.md` | What breaks and recovery playbook |
| `scripts/fleet-status.sh` | Fleet health dashboard |
| `scripts/dispatch.sh` | Remote command execution |
| `SCORECARD.md` | Agent performance tracking template |

## Design Principles

1. **Specialist by default** — Don't over-coordinate. If one agent can do it, skip the overhead.
2. **Budget-aware** — Every task has a token budget. Local models first, paid APIs only when necessary.
3. **Fail gracefully** — Circuit breakers, checkpoints, automatic reassignment. Never lose completed work.
4. **Learn continuously** — Shared memory captures what works. Routing improves over time.
5. **Human in the loop** — Escalate consequential decisions. Agents execute, humans approve.

## Dependencies

- `bash`, `ssh`, `sshpass`, `jq`, `curl`
- Network access to fleet machines (same LAN)
- OpenClaw >= 2026.2.0 (for cron integration)
