# Clawd Provisioner Skill

Automated deployment of Clawd bots on Mac minis, Linux servers, or cloud instances. End-to-end setup: OS prep, dependencies, OpenClaw installation, configuration, validation, and monitoring.

## Use Cases
- Deploy dedicated Clawd bots for client projects
- Scale agent workforce across multiple machines
- Standardize environments for reliability
- Rapid onboarding of new hardware

## Triggers
- "Set up a Clawd bot on Mac mini"
- "Provision a new agent node"
- "Deploy Clawd from scratch"
- "Bootstrap a Clawd instance"

## What It Does
1. System preparation (updates, security, developer tools)
2. Install Node.js, Git, and other dependencies
3. Clone and configure OpenClaw
4. Set up environment variables and secrets
5. Configure persistence and auto-start
6. Enable remote access and monitoring (optional)
7. Run validation tests
8. Produce deployment report

## Output
- Running Clawd bot ready for task assignments
- Deployment log and credentials summary
- Health check status
- Next steps for integration

## Notes
- Works on macOS, Ubuntu, Debian, Raspberry Pi OS
- Requires sudo privileges for system-level changes
- Can run in fully automated mode or with user confirmation prompts
- Produces a manifest of installed components and versions
