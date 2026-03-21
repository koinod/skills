# Deep Research — KOINO Capital

Institutional-grade research engine that produces analysis better than Perplexity, better than ad-hoc AI searches, and competitive with junior analyst work at top firms.

## Why This Exists

Most "AI research" is a glorified Google summary. It finds the consensus, rephrases it, and calls it done. That is not research. Research means triangulating multiple sources, actively seeking disconfirmation, scoring confidence, identifying blind spots, and producing actionable synthesis.

This skill encodes the methodologies used by Bellingcat investigators, hedge fund analysts, McKinsey consultants, and academic systematic reviewers into a repeatable protocol that any KOINO agent can execute.

## Quick Start

```bash
# Make executable
chmod +x /tmp/skills/deep-research/scripts/research.sh

# Run
research market "AI video editing SaaS for agencies"
research alpha "undervalued Shopify app niches" --depth exhaustive
research people "Alex Hormozi" --depth standard --format brief
research risk "launching fintech without money transmitter license"
research trend "AI agents replacing SaaS" --depth quick
research technical "WebRTC vs HLS for sub-500ms latency"
```

## 6 Research Modes

| Mode | Focus | Best For |
|------|-------|----------|
| **market** | Competitive landscape, pricing, TAM, positioning | Entering a new market, evaluating opportunities |
| **technical** | Architecture, APIs, benchmarks, tradeoffs | Build vs buy, framework selection, system design |
| **people** | Background, track record, incentives, network | Pre-meeting research, hiring, partnership evaluation |
| **trend** | Adoption curves, inflection points, S-curves | Strategic planning, timing decisions |
| **risk** | Threat modeling, scenarios, vulnerabilities | Investment decisions, launch readiness, due diligence |
| **alpha** | Information asymmetries, contrarian insights | Finding edges, non-obvious opportunities |

## 3 Depth Levels

| Depth | Sources | Time | Use Case |
|-------|---------|------|----------|
| quick | 3-5 | 2-5 min | Time-sensitive, initial screen |
| standard | 10-20 | 10-20 min | Most decisions |
| exhaustive | 30+ | 30-60 min | Major investments, strategy |

## What Makes This Better

| Feature | ChatGPT | Perplexity | KOINO Deep Research |
|---------|---------|------------|---------------------|
| Multi-source triangulation | No | Partial | Yes, required |
| Confidence scoring | No | No | Every finding |
| Contrarian analysis | No | No | Mandatory section |
| Source credibility scoring | No | No | CRAAP+ framework |
| Blind spot detection | No | No | Mandatory section |
| Temporal analysis | Rare | Sometimes | Mandatory section |
| Actionable output | Generic | Sometimes | Prioritized with effort estimates |
| Methodology transparency | No | Partial | Full documentation |
| Quality scorecard | No | No | 10-dimension, 50-point scale |

## Objection Handling

**"I can just use Perplexity."**
Perplexity finds consensus and summarizes it. It does not triangulate, seek disconfirmation, score confidence, detect blind spots, or produce prioritized actions. It scores 25-32/50 on our scorecard. This skill targets 40-50.

**"AI hallucinations make research unreliable."**
That is why every claim requires citations, every finding gets a confidence score, and the protocol demands triangulation. The methodology is designed to catch hallucinations before they reach conclusions.

**"Deep research takes too long."**
Quick mode runs in 2-5 minutes. The question is not how long research takes, but how much a bad decision costs. A 20-minute standard research pass that prevents a $10K mistake is an infinite ROI.

**"I need human judgment for this."**
This skill does not replace judgment. It produces the inputs that make human judgment better. The "So What" and "Now What" sections are designed to accelerate decisions, not make them for you.

## File Structure

```
deep-research/
  _meta.json                          # Skill metadata and configuration
  SKILL.md                            # Complete research protocol (the brain)
  README.md                           # This file
  SCORECARD.md                        # Quality evaluation rubric
  scripts/research.sh                 # CLI entry point
  references/
    research-frameworks.md            # OSINT, systematic review, CI methods
    source-evaluation.md              # CRAAP+ framework, source hierarchy
    synthesis-patterns.md             # 8 patterns for extracting insight
```

## KOINO Capital IP

This skill is proprietary KOINO Capital intellectual property. It synthesizes methodologies from Bellingcat (OSINT), academic systematic review protocols (PRISMA), hedge fund competitive intelligence frameworks, and original synthesis patterns developed by KOINO Capital.
