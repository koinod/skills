# Autonomous Revenue Skill

**KOINO Capital Original IP**

An OpenClaw skill that enables AI agents to autonomously detect market gaps, create digital products, and generate revenue through Stripe — with ethical guardrails baked in.

## What This Does

This skill implements a complete autonomous revenue loop:

1. **Detect** — Scans Reddit, Twitter/X, Product Hunt, and trend data for unmet needs
2. **Ideate** — Generates product concepts matched to detected gaps
3. **Create** — Builds digital products (templates, starter kits, skill files, SOPs)
4. **Price** — Tests and optimizes pricing against market data
5. **Launch** — Creates Stripe listings with automated delivery
6. **Learn** — Monitors sales, refunds, and conversion data
7. **Iterate** — Kills underperformers, doubles down on winners

## Quick Start

```bash
# 1. Set environment
export STRIPE_SECRET_KEY="sk_live_..."

# 2. Run first market scan
./scripts/market-scan.sh

# 3. Review detected gaps (human approval for first 5 products)
cat /tmp/autonomous-revenue/gaps.json

# 4. Create and launch
# (Follow SKILL.md Phase 3-6)
```

## Requirements

- Stripe account with API access
- `curl`, `jq`, `python3`
- Optional: Ollama for local inference, OpenRouter for cloud inference

## Revenue Targets

| Timeline | Products Live | Monthly Revenue |
|----------|--------------|-----------------|
| Month 1  | 3-5          | $100-500        |
| Month 3  | 8-15         | $500-2000       |
| Month 6  | 15-30        | $2000-5000      |
| Month 12 | 30+          | $5000+          |

These are conservative estimates assuming a single agent. Fleet deployment multiplies linearly.

## Ethical Stance

This skill has hard-coded ethical constraints:
- All products disclose AI involvement
- No false claims, fake urgency, or fake testimonials
- 30-day refund policy mandatory
- Max 2 products created per day
- Human approval required for products over $100
- Prohibited categories enforced (health claims, get-rich-quick, etc.)

See `references/ethical-guidelines.md` for full framework.

## Payment Protocols Supported

- **Stripe Standard** — Card payments, traditional checkout
- **Stripe MPP** — Machine Payments Protocol for agent-to-agent commerce
- **x402** — HTTP-native micropayments via stablecoins (future integration)

## Files

| File | Purpose |
|------|---------|
| `SKILL.md` | Complete system prompt and operational playbook |
| `_meta.json` | Skill metadata, triggers, constraints |
| `SCORECARD.md` | KPIs and grading rubric |
| `references/stripe-mpp.md` | Stripe Machine Payments Protocol integration guide |
| `references/product-templates.md` | Proven digital product formats and examples |
| `references/ethical-guidelines.md` | Compliance framework and guardrails |
| `references/market-detection.md` | Signal source configuration and gap scoring |
| `scripts/market-scan.sh` | Automated market gap detection script |
| `scripts/revenue-report.sh` | Revenue analytics and reporting script |

## License

Proprietary — KOINO Capital. Not for redistribution.
