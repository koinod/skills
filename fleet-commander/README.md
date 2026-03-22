# Fleet Commander Lite

Lightweight multi-agent coordination for AI agent fleets. Register agents, route tasks to the best-fit agent, chain agents in pipelines, and monitor health — all over SSH.

## What's Included

- **Agent Registry** — Register agents with capabilities, specialties, and endpoints
- **Specialist Pattern** — Route tasks to the single best agent for the job
- **Pipeline Pattern** — Chain agents sequentially (A → B → C) with quality gates
- **SSH Dispatch** — Execute tasks on remote machines over SSH
- **Status Dashboard** — See which agents are online, their capabilities, and last heartbeat
- **Health Checks** — Ping and process monitoring for all registered agents

## Quick Start

1. Create an agent card JSON file for each agent in your fleet
2. Register agents: `fleet-commander register agent-card.json`
3. Check status: `fleet-commander status`
4. Run tasks: `fleet-commander run "your task" --capability research`
5. Chain agents: `fleet-commander pipeline "goal" --stages "step1:agent-a → step2:agent-b"`

## Full Version

This is the free starter kit. The full Fleet Commander skill adds:

- 4 more coordination patterns (Scatter-Gather, Swarm, Tournament, Consensus)
- Weighted routing algorithm scoring capability, reliability, load, cost, and latency
- Shared memory system with conflict detection across agents
- Circuit breaker failure recovery (CLOSED → OPEN → HALF_OPEN)
- Cost optimization with model tier hierarchy
- 3-level escalation matrix
- Performance scoring feedback loop that improves routing over time
- Full communication protocol with 11 message types
- Scaling analysis from 3 to 50+ agents
- Post-mortem templates and 10 documented failure modes with recovery strategies

Get the full version at **https://koino.capital/kits**
