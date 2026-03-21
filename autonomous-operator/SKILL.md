# Autonomous Operator Skill

Provides autonomous business operation capabilities: multi-backend email, local LLM integration, self-monitoring, credential management, and revenue tracking. Enables the agent to run without manual gatekeepers.

## Capabilities

- **Multi-backend email** — automatically detects and uses available email methods (gog OAuth, SMTP app password, third-party APIs)
- **Local LLM** — integrates with Ollama for unlimited tokens, no API costs
- **Self-monitoring** — health checks, revenue pipeline tracker, alerting
- **Credential vault** — secure storage and rotation of service credentials
- **Autonomous loops** — periodic execution of high-value tasks (follow-ups, research, monitoring)

## Triggers

- "Set up autonomous email"
- "Enable local LLM"
- "Start self-monitoring"
- "Build sovereign business machine"
- "Remove gatekeepers"

## What It Does

### 1. Email Independence
Detects available email sending methods in order of preference:
1. gog CLI with OAuth (if configured)
2. SMTP with app password (if credentials available)
3. Third-party email API (SendGrid, Mailgun, etc.)
4. Fallback: draft emails for manual send

Provides unified interface: `send-email --to <email> --subject <subj> --body <body>`

Automatically retries with fallback if primary fails.

### 2. Local LLM Integration
Installs and manages Ollama on the local machine:
- Detects if Ollama is installed, installs if not (via brew or direct binary)
- Pulls Llama 3.2 (or other models) based on available RAM
- Configures OpenClaw to use local LLM for agent instructions
- Provides unlimited token generation for agent workflows

### 3. Self-Monitoring Dashboard
Generates daily status reports:
- Agent health (running, errors, restarts)
- Revenue pipeline (leads, emails sent, replies, calls booked, deals closed)
- Credential status (expiring soon, needs rotation)
- System resources (RAM, CPU, disk)
- Upcoming tasks and follow-ups

Dashboard can be viewed via: `openclaw status --full` or a simple web UI.

### 4. Autonomous Loops
Runs scheduled tasks without cron (internal scheduler):
- Every 2 hours: check inbox, send scheduled follow-ups, update lead status
- Daily: generate revenue report, update next-moves.md, log insights
- Weekly: competitor watch, pricing intel, template refresh
- On trigger: when new lead added, automatically enrich and add to sequence

### 5. Credential Vault
Securely stores:
- Email passwords/app passwords
- API keys (OpenRouter, etc.)
- Client credentials
- Rotation reminders

Uses macOS Keychain or encrypted file storage.

## Setup

```bash
# Initialize autonomous operator
openclaw sessions_spawn --runtime subagent --task "Initialize autonomous operator: install Ollama, configure email fallbacks, set up monitoring"

# Or use the CLI directly (once installed)
autonomous-operator init
autonomous-operator email-test
autonomous-operator dashboard
```

## Configuration

Environment variables:
- `AUTONOMOUS_EMAIL_BACKENDS` — comma-separated list of backends to try (default: gog,smtp,api,draft)
- `AUTONOMOUS_LLM_MODEL` — local model to use (default: llama3.2)
- `AUTONOMOUS_REPORT_TIME` — daily report time (default: 09:00)
- `AUTONOMOUS_FOLLOWUP_INTERVAL` — hours between follow-up cycles (default: 2)

## Benefits

- No dependency on any single credential provider
- Works offline (local LLM) for core agent instructions
- Automatic failover ensures continuity
- Self-monitoring means you know status at a glance
- Reduces manual repetitive work to zero

## Notes

This skill is designed for sovereignty. It assumes you want to own your infrastructure and not rely on third-party APIs that can go down or change terms. Local LLM gives you unlimited tokens and privacy.

Preferred hardware: Mac mini or Linux server with at least 16GB RAM for comfortable Llama 3.2 operation.
