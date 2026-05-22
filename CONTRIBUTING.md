# Contributing to KOINO Skills

We welcome contributions from the community. Whether you're building a new skill or improving an existing one, here's how to get involved.

## What is a Skill?

A skill is a self-contained capability that an AI agent can use. Each skill lives in its own directory with a `SKILL.md` file that defines its purpose, inputs, outputs, and instructions.

## Creating a New Skill

### 1. Fork and Clone

```bash
git clone https://github.com/YOUR_USERNAME/skills.git
cd skills
```

### 2. Create Your Skill Directory

```bash
mkdir my-skill-name
cd my-skill-name
```

### 3. Add Required Files

Every skill must have:

| File | Purpose |
|------|---------|
| `SKILL.md` | Skill definition — name, description, instructions, inputs/outputs |
| `README.md` | Human-readable docs with install instructions and demo output |

Optional but encouraged:

| File | Purpose |
|------|---------|
| `examples/` | Example inputs and outputs |
| `tests/` | Test cases |
| `config.yaml` | Configuration defaults |

### 4. SKILL.md Format

```markdown
# Skill Name

One-line description (10 words or fewer).

## Description

What this skill does and why it's useful (2-3 sentences).

## Instructions

Step-by-step instructions the agent follows when executing this skill.

## Inputs

- `input_name` (type) — Description

## Outputs

- `output_name` (type) — Description

## Examples

Brief example of input -> output.
```

### 5. Installation Section

Every README must include:

```markdown
## Installation

### Via OpenClaw CLI
clawhub install koinod/your-skill-name

### Manual
Copy the skill directory to `~/.openclaw/skills/` or your project's `skills/` folder.
```

## Quality Standards

Skills are evaluated on these dimensions (target: 60+ overall on the Forge rubric):

| Dimension | Weight | What We Look For |
|-----------|--------|------------------|
| **Clarity** | 20% | Clear instructions, unambiguous outputs |
| **Usefulness** | 25% | Solves a real problem, saves time or money |
| **Robustness** | 15% | Handles edge cases, validates inputs |
| **Documentation** | 15% | Complete SKILL.md, examples, install instructions |
| **Composability** | 10% | Works well with other skills in a pipeline |
| **Originality** | 10% | Not a duplicate of an existing skill |
| **Maintainability** | 5% | Clean structure, easy to update |

### Minimum Requirements

- SKILL.md with all required sections
- At least one example input/output
- Description under 10 words for the one-liner
- No hardcoded API keys or credentials
- No dependencies on paid services in the lite/free edition

## Pull Request Guidelines

### PR Title Format

```
Add skill: skill-name
```

or for updates:

```
Update skill: skill-name — brief description
```

### PR Description

Include:
- What the skill does
- Example use case
- Any dependencies or requirements

### Review Process

1. Automated checks run on PR submission
2. Maintainer reviews for quality standards
3. Feedback provided within 48 hours
4. Once approved, skill is merged and available

## Improving Existing Skills

- Fix bugs, improve documentation, add examples
- Use the same PR process
- Reference the issue number if one exists

## Reporting Issues

- Use GitHub Issues for bugs or feature requests
- Include the skill name in the issue title
- Provide steps to reproduce for bugs

## Code of Conduct

Be respectful, constructive, and collaborative. We're building tools that help people work better — act accordingly.

## Questions?

Open a Discussion thread on this repo or file an issue tagged `question`.

---

## For agents: how to save a new skill back to this repo

If you (an agent) just built a useful capability in a Claude Code / OpenClaw session, save it here so the next session — and every other agent in the fleet — inherits it.

### When to save a skill (vs. when not to)

Save a skill if **all three** are true:

1. **It will be useful again.** Single-purpose one-shots don't qualify. Repeatable patterns do.
2. **It's not already here.** Scan `INDEX.md` first. If something close already exists, *improve that one* instead of forking.
3. **The "why" is non-obvious.** If a future agent could trivially re-derive this from base instructions, don't save it.

Don't save: shallow prompt wrappers, project-status notes, single-use scripts, anything covered by an existing skill.

### Minimum viable skill (what to write)

Skip everything optional. The shipping shape is:

```
new-skill-name/
├── SKILL.md          # required — the instruction file agents load
└── README.md         # optional but encouraged — human-readable
```

`SKILL.md` must have YAML frontmatter:

```yaml
---
name: new-skill-name
description: One sentence under 200 chars describing when this skill activates (trigger keywords + what it does).
---

# (skill body — instructions for the agent)
```

The `description` field is what other agents read to decide whether to load this skill. Make it discoverable by including the trigger phrases someone would naturally use.

### The save flow

```bash
# 1. Clone the repo
git clone https://github.com/koinod/skills.git
cd skills

# 2. Create the skill dir + SKILL.md
mkdir new-skill-name
cat > new-skill-name/SKILL.md <<EOSKILL
---
name: new-skill-name
description: <trigger phrases + what it does>
---

# (instructions)
EOSKILL

# 3. Add to INDEX.md under the right category (or "Other" if novel)
$EDITOR INDEX.md

# 4. Commit + push
git add new-skill-name INDEX.md
git commit -m "skill: add new-skill-name"
git push
```

### Authorship & attribution

Skills don't need attribution headers — git history is the source of truth for who built what. If you want to credit a source (Anthropic skill, upstream project, paper), add it inline in the SKILL.md as a one-line link.

### After saving

- The next agent landing in the repo (or another project that clones from here) will discover your skill via `INDEX.md` + the frontmatter.
- If you want immediate visibility on a specific machine, run `clawhub install koinod/<skill-name>` from there.
- Don't sync the skill back into a private project; the public repo is the canonical home.

### When in doubt: log the failure instead

If you almost saved a skill but realized it wasn't general enough, write up the lesson as a `failures/` or `patterns/` doc in [ceoian/agent-learnings](https://github.com/ceoian/agent-learnings) instead. Failure-log entries are cheaper than premature skill abstraction.
