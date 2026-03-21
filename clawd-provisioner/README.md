# Clawd Provisioner — Quick Start

## What This Does

Automated deployment of a fully functional Clawd bot on any Mac mini, Linux server, or cloud instance. Zero-touch setup: system updates, Node.js, OpenClaw, service configuration, validation.

## Usage

On the target machine (where you want the Clawd bot running):

```bash
# Clone this skill or copy provision.sh to the machine
sudo bash provision.sh
```

That's it. The script:
- Detects OS (macOS/Ubuntu/Debian/Raspberry Pi)
- Installs dependencies (Node.js, Git, jq, tmux)
- Creates a dedicated `clawd` user
- Clones OpenClaw to `/opt/clawd`
- Installs npm dependencies
- Sets up auto-start service (systemd or launchd)
- Runs validation tests
- Generates a JSON report at `/tmp/clawd-provision-report.json`

## After Provisioning

1. Edit the environment file: `/opt/clawd/.env`
2. Add your `MATON_API_KEY` (get it from Maton.ai)
3. Check status: `openclaw gateway status`
4. Test: `openclaw sessions_spawn --runtime subagent --task 'hello'`

## One-Line Remote Deployment

From your main OpenClaw instance, you can deploy to a remote machine via SSH:

```bash
ssh root@target-machine 'bash -s' < provision.sh
```

Or pull and run:

```bash
ssh root@target-machine 'git clone https://github.com/openclaw/openclaw.git /opt/clawd && bash /opt/clawd/skills/clawd-provisioner/provision.sh'
```

## Customization

- Set `NODE_ID` environment variable to name the node
- Set `OPENCLAW_DIR` to change installation path
- Use `--headless` flag to skip prompts (not yet implemented)
- Add extra environment variables in the .env file after creation

## Troubleshooting

- Logs: `/var/log/clawd-provision.log`
- Service status: `systemctl status clawd` (Linux) or `launchctl list | grep clawd` (macOS)
- Report file: `/tmp/clawd-provision-report.json`

## Re-running

The script is idempotent — safe to run multiple times. It will:
- Not reinstall Node if already present
- Not clone OpenClaw if already exists
- Recreate service files if missing
- Re-run validation

## Integration With Agent Swarm

Once provisioned, the new Clawd node appears in `openclaw nodes status`. You can then target it with:

```bash
openclaw sessions_spawn --node <node-id> --runtime subagent --task "your task here"
```

Or use it as a persistent worker in your agent swarm.
