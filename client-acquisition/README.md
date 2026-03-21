# Client Acquisition Skill

**KOINO Capital Original IP** -- Universal client acquisition system for any service business.

## What It Does

Handles the full client acquisition funnel:

| Stage | Commands | What You Get |
|-------|----------|-------------|
| **Define** | `/icp` | Ideal Client Profile with scoring rubric |
| **Find** | `/prospect` | Researched prospects scored against your ICP |
| **Reach** | `/outreach` | Personalized multi-channel sequences (email, LinkedIn, DM) |
| **Qualify** | `/qualify` | BANT + MEDDIC scoring with next-action recommendations |
| **Close** | `/propose` | 60-second proposals with ROI anchoring and risk reversal |
| **Onboard** | `/onboard` | Complete onboarding workflow with checklists |
| **Retain** | `/health` | Client health scoring, churn alerts, upsell detection |
| **Grow** | `/casestudy` | Case study generation from client results |
| **Audit** | `/pipeline` | Full pipeline metrics, bottlenecks, revenue forecast |

## Who It's For

- Solo consultants going from 2 clients to 10
- Agencies at $20K/mo targeting $100K/mo
- SaaS founders doing founder-led sales
- Freelancers escaping feast-or-famine cycles
- Local service businesses wanting more leads
- AI services companies building pipeline

## Replaces

| Tool | Cost | What We Replace |
|------|------|----------------|
| Apollo.io | $49/user/mo | ICP + prospecting |
| Instantly.ai | $30/mo | Outreach sequencing |
| Lemlist | $69/user/mo | Personalization engine |
| HeyReach | $79/mo | LinkedIn outreach strategy |
| Rocketlane | $29/user/mo | Client onboarding |
| **Total** | **$256-656/mo** | **$0 with this skill** |

## Setup

1. Copy to your OpenClaw skills directory
2. Ensure `ollama` is running with `qwen2.5:3b` (or any model)
3. Run any command: `/prospect "Acme Corp"`

## Key Files

- `SKILL.md` -- Full skill definition with all commands and rules
- `references/outreach-templates.md` -- Cold email, DM, LinkedIn frameworks
- `references/qualification-frameworks.md` -- BANT, MEDDIC, and scoring rubrics
- `references/pricing-strategies.md` -- Pricing psychology and strategies
- `scripts/prospect.sh` -- CLI prospect research tool
- `scripts/outreach.sh` -- CLI outreach sequence generator
- `SCORECARD.md` -- Pipeline health metrics and benchmarks
