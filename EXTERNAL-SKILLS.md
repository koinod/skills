# External skill registries + standout single skills

This file replaces the 8 unmodified `awesome-*` forks that used to live on the koinod profile. After reading all 8 we found that:
- They overlap heavily (~85% between the largest two).
- Only 4 of the 8 upstreams are actually distinct.
- The single-skill gold is concentrated in ~10 specific entries across the lot.

So instead of mirroring 8 catalogs we maintain this file: the 4 distinct registries + the standout individual skills worth knowing about + the curation patterns worth borrowing.

---

## The 4 distinct registries (by maintainer)

Grouped by who maintains, not by topic — provenance signals trust.

| Maintainer | Registry | Why it's the canonical |
|---|---|---|
| **VoltAgent** | [VoltAgent/awesome-agent-skills](https://github.com/VoltAgent/awesome-agent-skills) | Deepest single index. 1000+ skills, grouped by who maintains them (Anthropic, Stripe, Supabase, Cloudflare, Vercel, Trail of Bits, Sentry, Microsoft, etc.). Start here. |
| **hesreallyhim** | [hesreallyhim/awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) | Claude-Code-specific (skills, hooks, slash-commands, agents, configs). Has a `## Recently Added` block that solves the "is this list stale?" problem better than any badge. |
| **obra (Jesse Vincent)** | [obra/superpowers](https://github.com/obra/superpowers) | 20+ battle-tested SDLC skills (TDD, root-cause-tracing, brainstorming, using-git-worktrees, defense-in-depth). The reference library for engineering hygiene. |
| **Trail of Bits** | [trailofbits/skills](https://github.com/trailofbits/skills) | 21+ pro-grade security skills (CodeQL/Semgrep, differential-review, fix-review, semgrep-rule-creator, audit-context-building). Production patterns from an actual auditing firm. |

The other 4 forks (`gmh5225/awesome-skills`, `heilcheng/awesome-agent-skills`, `webfuse-com/awesome-claude`, `rahulvrane/awesome-claude-agents`) are derivative — heavy overlap with VoltAgent or out-of-scope (subagents ≠ skills). Skipped.

---

## Anthropic primitives

| Source | What |
|---|---|
| [anthropics/skills](https://github.com/anthropics/skills) | Official Anthropic-maintained Agent Skills open standard + reference skills. The spec this repo conforms to. |
| [Claude Code skill docs](https://docs.claude.com/en/docs/claude-code/sub-agents) | Official documentation for skill structure, frontmatter, and discoverability. |

---

## Standout individual skills (the gold)

These are non-obvious, not duplicated in `koinod/skills/INDEX.md`, and high-leverage. Lift the SKILL.md directly when you actually need one of these (don't pre-mirror everything).

| Skill | Repo | Why |
|---|---|---|
| `obra/superpowers` 20+ SDLC skills | [obra/superpowers](https://github.com/obra/superpowers) | Fills the Dev Tools gap in `koinod/skills` with real engineering hygiene. Lift `root-cause-tracing`, `using-git-worktrees`, `defense-in-depth` first. |
| `trailofbits/skills` 21+ security skills | [trailofbits/skills](https://github.com/trailofbits/skills) | `koinod/skills` has zero security skills today. Lift `semgrep-rule-creator`, `audit-context-building`, `differential-review` if you need them. |
| Anthropic Claude Code v2.1.120 leaked system prompt | [asgeirtj/system_prompts_leaks](https://github.com/asgeirtj/system_prompts_leaks) (`Anthropic/claude-code.md`) | 609 lines of ground-truth on how Claude Code actually decides. Read once, exploit forever. |
| Design-review workflow | [OneRedOak/claude-code-workflows](https://github.com/OneRedOak/claude-code-workflows) | UI/UX design-review loop with sub-agents + slash commands. Pairs with `redesign-skill`/`impeccable`/`taste-skill`. |
| Subagent-driven development pattern | [NeoLabHQ/context-engineering-kit](https://github.com/NeoLabHQ/context-engineering-kit) | Dispatch-then-review checkpoints between iterations. Maps directly to OMNI loop architecture + the Dispatch role. |
| Visual QA via screenshots in generation pipelines | [htdt/godogen](https://github.com/htdt/godogen) | Pattern: generate → render → screenshot → LLM-QA. Lift the pattern, not the godot specifics. |
| CLAUDE.md / AGENTS.md / SKILL.md linter | [avifenesh/agentsys](https://github.com/avifenesh/agentsys) + [avifenesh/agnix](https://github.com/avifenesh/agnix) | The missing CI for this skill library. 76 skills with no linter = drift guaranteed. Worth a GitHub Action. |
| "Everything Claude Code" reference pack | [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) | Highest-quality "everything" pack; each individual skill has standalone value. Read for craft, lift selectively. |

**Skipped (worth logging, not pursuing now):** `jakedahn/pomodoro` (skills that mutate themselves — interesting but niche), `KyleAMathews/hegelian-dialectic-skill` (two-subagent dialectic for hard decisions — clever but specialty), `ykdojo/claude-code-tips` (35+ tactical tricks — read once, not a skill to install).

---

## Skills already mirrored from upstream into this repo

Three full SKILL.md files were lifted from the ComposioHQ fork before deletion:

- **[twitter-algorithm-optimizer](./twitter-algorithm-optimizer)** — encodes Twitter's open-sourced algorithm (Real-graph, SimClusters, TwHIN, Tweepcred) into a rewrite-tweets-for-reach skill. Directly serves `@ianpifs` / `@iaankobe` content goals.
- **[lead-research-assistant](./lead-research-assistant)** — identifies + qualifies leads via product analysis + target-company search + outreach strategy (Composio-agnostic core).
- **[competitive-ads-extractor](./competitive-ads-extractor)** — pulls competitor ads from ad libraries and analyzes messaging. Pairs with `mkt-competitor-profiling` and `mkt-ad-creative`.

---

## Curation patterns worth borrowing

Three structural ideas from the upstream lists that this repo should adopt:

1. **Group by maintainer** (VoltAgent's pattern). Provenance signals trust at-a-glance. Used above in the "4 distinct registries" table.
2. **Recently Added block** (`hesreallyhim`'s pattern). 5 most-recent skills at the top of `INDEX.md`, dated and rotating. Solves the staleness question.
3. **Agent-runtime compatibility matrix** (`gmh5225`'s pattern, lines 64-79 of their README). Maps each runtime (Claude Code, Cursor, Codex, Gemini CLI, Copilot, Windsurf, etc.) to its project-path + global-path. Worth adding to `CONTRIBUTING.md` if KOINO skills ever target multi-runtime distribution.

---

## Lifting a skill from upstream — the rule

Don't fork the whole upstream repo. Either:

1. **Lift the one skill** — copy its `SKILL.md` (+ assets) into a new dir under this repo, add it to `INDEX.md`, credit the upstream in the SKILL.md body with a one-line link.
2. **Or just leave it upstream** — if the skill doesn't need agency-specific modifications, point to it directly. Don't duplicate for duplication's sake.
