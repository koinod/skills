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
