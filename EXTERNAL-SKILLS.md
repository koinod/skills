# External skill registries

The 8 `awesome-*` repos that used to live on the koinod profile were unmodified forks of upstream curated lists. We removed the forks (no edits, no value-add) and consolidated the actual *content* references into this single file.

If you're looking for a skill that doesn't exist in this repo, scan these upstream curated lists before building one from scratch.

## Tier-1 (read first)

| Registry | Maintained by | What's in it |
|---|---|---|
| [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills) | VoltAgent | 1000+ agent skills catalog spanning frameworks, providers, and use cases. The deepest single index. |
| [hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) | community | Skills, hooks, slash-commands, agents, and configuration for Claude Code specifically. |
| [ComposioHQ/awesome-claude-skills](https://github.com/ComposioHQ/awesome-claude-skills) | Composio | Curated Claude Skills with Composio-flavored integrations (tools, auth, runtime). |

## Tier-2 (worth skimming)

| Registry | Maintained by | What's in it |
|---|---|---|
| [rahulvrane/awesome-claude-agents](https://github.com/rahulvrane/awesome-claude-agents) | community | Claude Code subagents — focused on agent definitions rather than skills. |
| [heilcheng/awesome-agent-skills](https://github.com/heilcheng/awesome-agent-skills) | community | General agent skills curation, less Claude-specific. |
| [travisvn/awesome-claude-skills](https://github.com/travisvn/awesome-claude-skills) | community | Lighter-weight curated list — good for quick browsing. |
| [gmh5225/awesome-skills](https://github.com/gmh5225/awesome-skills) | community | Cross-platform agent skills list. |
| [webfuse-com/awesome-claude](https://github.com/webfuse-com/awesome-claude) | webfuse | General Claude resources — papers, tools, libraries. Less skill-specific. |

## Anthropic primitives

| Source | What |
|---|---|
| [anthropics/skills](https://github.com/anthropics/skills) | Official Anthropic-maintained Agent Skills open standard + reference skills. The spec this repo conforms to. |
| [Claude Code skill docs](https://docs.claude.com/en/docs/claude-code/sub-agents) | Official documentation for skill structure, frontmatter, and discoverability. |

## When you find a skill upstream that you want here

Don't fork the whole upstream repo. Either:

1. **Lift the one skill** — copy the SKILL.md (+ assets) into a new dir under this repo, add it to `INDEX.md`, credit the upstream in the SKILL.md body with a one-line link.
2. **Or just leave it upstream** — if the skill doesn't need agency-specific modifications, point to the upstream directly. Don't duplicate for the sake of duplication.

## Why this isn't itself a fork-tree

The 8 upstream `awesome-*` lists overlap heavily and re-link each other's content. Maintaining 8 forks gave us 8× the maintenance burden for ~1× the discovery value. A single pointer file is cheaper and stays current (the upstreams keep being maintained; our forks would have stagnated).
