# Autonomous Operator — Quick Start

## What Is This?

A sovereign business infrastructure that runs your agency without gatekeepers:
- **Email independence** — auto-detects gog, SMTP app password, or API
- **Local LLM** — unlimited tokens via Ollama (no API costs)
- **Self-monitoring** — dashboard with revenue pipeline status
- **Autonomous loops** — scheduled follow-ups, daily reports, competitor watch

## Installation

```bash
# From your OpenClaw workspace
cd autonomous-operator
npm install  # if dependencies are needed (currently pure Node)

# Initialize state
mkdir -p ~/.autonomous-operator

# Start the operator (runs in background)
node index.js &
# Or use pm2/systemd for persistence
```

## First Run

```bash
# Test email backend detection
node index.js email-test

# Check status dashboard
curl http://localhost:31415/status

# Stop the operator (if running in foreground, just Ctrl-C)
```

## Configuration

Set environment variables (optional):

```bash
export AUTONOMOUS_EMAIL_BACKENDS="gog,smtp,api,draft"
export AUTONOMOUS_LLM_MODEL="llama3.2"
export AUTONOMOUS_REPORT_TIME="09:00"
export AUTONOMOUS_SMTP_USER="iankmeeks@gmail.com"
export AUTONOMOUS_SMTP_PASS="your-app-password"
export SENDGRID_API_KEY="your-key"
```

## Features

### Email Sending (Unified)
```javascript
// In code
const op = require('./index');
await op.sendEmail('cody@example.com', 'Subject', 'Body');
// Automatically picks best backend, falls back to draft
```

### Local LLM Queries
```javascript
const answer = await op.queryLocalLLM('Summarize these leads: ...');
// Uses Ollama if installed, else cloud fallback
```

### Dashboard
- `http://localhost:31415/status` — JSON status report
- `http://localhost:31415/health` — simple health check

### Autonomous Loops
- Every 30 min: follow-up cycle (sends scheduled emails)
- Daily at 09:00: revenue report written to `~/.autonomous-operator/daily-report.json`
- Real-time updates to `research/next-moves.md` with status

## Troubleshooting

**Email not sending?**
- Run `node index.js email-test` to see available backends
- Ensure gog is authenticated (`gog auth list`) or set SMTP app password
- Check logs at `~/.autonomous-operator/autonomous.log`

**Local LLM not starting?**
- Install Ollama manually: https://ollama.ai/download
- Pull model: `ollama pull llama3.2`
- Ensure your Mac has at least 8GB free RAM

**Dashboard not accessible?**
- Check port 31415 is not blocked: `lsof -i :31415`
- Enable in config: `enableDashboard: true`

## What Gets Installed

- `~/.autonomous-operator/` — state, logs, reports
- No system modifications beyond Ollama (optional)

## Disabling

Simply stop the process. To remove completely:
```bash
rm -rf ~/.autonomous-operator
```

## Next Steps

1. Set up at least one email backend (gog OAuth or SMTP app password)
2. Install Ollama for local LLM (optional but recommended)
3. Start the operator: `node index.js &`
4. Check dashboard: `curl http://localhost:31415/status`
5. Let it run — it will update next-moves.md automatically

## Support

See `SKILL.md` for full capabilities reference.
