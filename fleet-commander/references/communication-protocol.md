# Communication Protocol Reference

## Protocol: koino-fleet/1.0

Inspired by Google's A2A protocol (Agent2Agent), adapted for SSH-based fleet coordination across a local network.

---

## Message Envelope

Every message between agents uses this format:

```json
{
  "protocol": "koino-fleet/1.0",
  "message_id": "msg-{YYYYMMDD}-{random_hex_8}",
  "from": "{agent_id}",
  "to": "{agent_id | broadcast}",
  "type": "{message_type}",
  "timestamp": "{ISO-8601}",
  "priority": "{low | normal | high | critical}",
  "reply_to": "{message_id | null}",
  "ttl_seconds": 300,
  "payload": { }
}
```

### Field Rules

| Field | Required | Notes |
|-------|----------|-------|
| protocol | YES | Always `koino-fleet/1.0` |
| message_id | YES | Unique. Format: `msg-YYYYMMDD-{8 hex chars}` |
| from | YES | Must match a registered agent_id |
| to | YES | Specific agent_id or `broadcast` for all agents |
| type | YES | One of the defined message types below |
| timestamp | YES | ISO-8601 with timezone |
| priority | YES | Determines processing order |
| reply_to | NO | Links response to original message |
| ttl_seconds | YES | Message expires after this. Default 300 (5 min) |
| payload | YES | Type-specific content. Can be empty `{}` |

---

## Message Types

### heartbeat

Agent announces it's alive and reports current load.

```json
{
  "type": "heartbeat",
  "payload": {
    "status": "online",
    "load": {
      "active_tasks": 2,
      "max_tasks": 5,
      "cpu_percent": 45,
      "memory_percent": 62
    },
    "capabilities_changed": false
  }
}
```

Frequency: Every 60 seconds. Commander responds with `heartbeat_ack`.

### register

Agent announces itself to the fleet.

```json
{
  "type": "register",
  "payload": {
    "agent_card": {
      "agent_id": "bmo-content-engine",
      "machine": "bmo",
      "capabilities": ["content-generation", "qa-scoring"],
      "model": "qwen2.5:3b",
      "max_concurrent": 2,
      "cost_per_task": "local-free",
      "endpoint": "ssh://operator@192.168.1.98",
      "specialties": {
        "content-generation": 0.92,
        "qa-scoring": 0.89
      }
    }
  }
}
```

Commander responds with `ack` containing assigned config.

### task_assign

Commander assigns work to an agent.

```json
{
  "type": "task_assign",
  "payload": {
    "task_id": "task-20260321-001",
    "subtask_id": "subtask-003",
    "goal": "Write 3 Instagram hooks using anti-guru voice",
    "context": {
      "brand_rules": "reference://shared-memory/facts/bryson-brand-rules",
      "recent_hooks": ["...", "..."]
    },
    "constraints": {
      "max_tokens": 50000,
      "quality_threshold": 0.85,
      "deadline": "2026-03-21T12:00:00Z"
    },
    "output_schema": {
      "type": "array",
      "items": { "hook": "string", "style": "string", "confidence": "number" }
    },
    "checkpoint_interval_seconds": 30
  }
}
```

### task_update

Agent reports progress on assigned task.

```json
{
  "type": "task_update",
  "payload": {
    "task_id": "task-20260321-001",
    "subtask_id": "subtask-003",
    "progress_percent": 60,
    "status": "in_progress",
    "tokens_used": 12000,
    "estimated_completion": "2026-03-21T10:15:00Z",
    "partial_output": null
  }
}
```

### task_complete

Agent delivers finished work.

```json
{
  "type": "task_complete",
  "payload": {
    "task_id": "task-20260321-001",
    "subtask_id": "subtask-003",
    "status": "complete",
    "output": {
      "hooks": [
        { "hook": "Your sales coach is lying to you.", "style": "provocative", "confidence": 0.91 },
        { "hook": "I made $250k/mo by ignoring every guru.", "style": "proof", "confidence": 0.88 },
        { "hook": "Stop posting motivational quotes.", "style": "contrarian", "confidence": 0.85 }
      ]
    },
    "quality_self_score": 0.88,
    "tokens_used": 28400,
    "duration_ms": 14200
  }
}
```

### task_failed

Agent reports a failure.

```json
{
  "type": "task_failed",
  "payload": {
    "task_id": "task-20260321-001",
    "subtask_id": "subtask-003",
    "error_type": "model_error",
    "error_message": "Ollama connection refused on port 11434",
    "tokens_used": 2000,
    "retryable": true,
    "suggested_action": "restart_ollama"
  }
}
```

### escalate

Agent requests human intervention.

```json
{
  "type": "escalate",
  "payload": {
    "level": 3,
    "reason": "Output could have reputational impact — Bryson content references competitor by name",
    "task_id": "task-20260321-001",
    "context": "Post draft names XYZ Academy directly in negative comparison",
    "options": [
      "approve_as_is",
      "remove_competitor_name",
      "rewrite_without_comparison"
    ],
    "deadline": "2026-03-21T14:00:00Z"
  }
}
```

### directive

Commander changes agent behavior mid-execution.

```json
{
  "type": "directive",
  "payload": {
    "action": "adjust_priority",
    "details": {
      "task_id": "task-20260321-001",
      "new_priority": "critical"
    }
  }
}
```

### recall

Commander stops an agent's current task.

```json
{
  "type": "recall",
  "payload": {
    "task_id": "task-20260321-001",
    "reason": "Task superseded by new requirements",
    "save_progress": true
  }
}
```

---

## Transport Layer

### Current: SSH + JSON Files

For the current 4-machine fleet, messages are transported via SSH:

```bash
# Send message to agent
echo '{"protocol":"koino-fleet/1.0",...}' | \
  ssh operator@192.168.1.98 "cat >> ~/.fleet/inbox/incoming.jsonl"

# Read responses
ssh operator@192.168.1.98 "cat ~/.fleet/outbox/responses.jsonl"
```

Message queues on each machine:
```
~/.fleet/
├── inbox/
│   └── incoming.jsonl     # Messages TO this agent
├── outbox/
│   └── responses.jsonl    # Messages FROM this agent
├── agents/
│   └── <agent_id>.json    # Agent cards
└── logs/
    └── messages.log       # Message audit trail
```

### Future: HTTP API

When scaling beyond SSH, agents expose a local HTTP endpoint:

```
POST /fleet/message    — receive a message
GET  /fleet/status     — return agent status
GET  /fleet/card       — return agent card
POST /fleet/task       — accept a task assignment
```

---

## Status Codes

| Code | Meaning |
|------|---------|
| `online` | Agent is healthy and accepting tasks |
| `busy` | Agent is at max capacity, queue new tasks |
| `suspect` | No heartbeat received recently, may be failing |
| `offline` | Confirmed unreachable |
| `degraded` | Online but performing below normal (e.g., high load) |
| `maintenance` | Agent is being updated, don't send tasks |
| `draining` | Agent is finishing current tasks, won't accept new ones |

## Priority Levels

| Priority | Processing | Use Case |
|----------|-----------|----------|
| `critical` | Immediate, preempt other work | Fleet emergency, cascading failure |
| `high` | Next in queue | Revenue-generating tasks, deadlines |
| `normal` | Standard FIFO | Routine content, research |
| `low` | Background, when idle | Maintenance, optimization, learning |

---

## Error Handling

### Duplicate Messages

Messages are deduplicated by `message_id`. If an agent receives a message it's already processed, it returns `ack` without re-executing.

### Expired Messages

If a message's TTL has passed when received, the agent discards it and logs a warning. The sender is notified via `message_expired` response.

### Malformed Messages

Missing required fields or invalid types result in a `message_rejected` response with details about what's wrong. The message is logged but not processed.

### Ordering

Messages are processed in priority order, then by timestamp within the same priority level. No strict ordering guarantees across agents — the system is eventually consistent.
