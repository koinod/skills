# Autonomous Operator — Quick Start for Production

## Start the Operator

```bash
# From workspace root
node skills/autonomous-operator/index.js start &
# Or use pm2/systemd for persistence
```

## Verify It's Running

```bash
curl http://localhost:31415/status
# Returns JSON with revenue pipeline, email backend, LLM status
```

## Configure Email (Pick ONE)

### Option A: SMTP App Password (recommended for Gmail)
```bash
export AUTONOMOUS_SMTP_USER="iankmeeks@gmail.com"
export AUTONOMOUS_SMTP_PASS="your-app-password"
# Generate app password: Google Account → Security → App passwords
```

### Option B: gog OAuth (if you have client_secret.json)
```bash
gog auth credentials /path/to/client_secret.json
gog auth add iankmeeks@gmail.com --services gmail
# The operator will detect and use gog automatically
```

### Option C: Third-party API (SendGrid, Mailgun)
```bash
export SENDGRID_API_KEY="your-key"
# or MAILGUN_API_KEY, etc.
```

## Test Email

```bash
node skills/autonomous-operator/index.js email-test
```

## What It Does Automatically

- Every 30 minutes: runs follow-up sequences (if leads configured)
- Daily at 09:00: writes revenue report to `~/.autonomous-operator/daily-report.json`
- Real-time: updates `research/next-moves.md` with status and revenue stats
- Monitors: email backend health, LLM availability, system resources

## Stop / Restart

```bash
# Find process
ps aux | grep autonomous-operator

# Kill
kill <pid>

# Restart
node skills/autonomous-operator/index.js start &
```

## Logs

`~/.autonomous-operator/autonomous.log`

## Dashboard

`http://localhost:31415/status` (JSON)
`http://localhost:31415/health` (plain OK)

## Notes

- The operator runs independently; you can close the terminal after starting (use `nohup` or `screen`/`tmux` if needed)
- It will survive reboots if set up via systemd/launchd (manual setup required)
- Revenue pipeline numbers are updated automatically when emails are sent via this system
- For manual emails (outside this system), you can manually increment counters by editing `~/.autonomous-operator/state.json` (not recommended)

## Integration with Quartermaster

Once both are running:
- Quartermaster deploys agents
- Autonomous Operator handles email & monitoring
- They work independently but complement each other

---

**You are now running your business without gatekeepers.** 🎉
