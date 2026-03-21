# Objection Destroyer

> KOINO Capital Original IP. The skill that pays for itself on the first call.

## What It Does

Universal sales objection handling system that makes anyone unbeatable at handling objections in sales, negotiations, and persuasion.

- **Classifies** any objection into 6 types (price, timing, authority, need, trust, competition)
- **Generates** instant responses using 7 proven frameworks
- **Matches** the prospect's communication style automatically
- **Detects** when to push vs. pull back
- **Drills** you with realistic scenarios across 5 industries
- **Tracks** which frameworks produce the highest win rates

## Quick Start

### Handle an objection
Ask the agent with the objection-destroyer skill loaded:

```
Destroy this objection: "We're happy with our current solution"
Industry: SaaS
Context: Mid-market company, VP of Sales, second call
```

### Practice mode
```bash
chmod +x scripts/drill.sh
./scripts/drill.sh           # 10 reps, closer difficulty, mixed industries
./scripts/drill.sh 20 destroyer saas  # 20 reps, no hints, SaaS only
./scripts/drill.sh 5 rookie insurance # 5 reps, with hints, insurance
```

### Preempt objections in a pitch
```
Preempt objections for: Agency retainer pitch, $5K/month, prospect is a 50-person e-commerce brand
```

### Analyze a transcript
```
Analyze this sales call transcript for objection patterns: [paste transcript]
```

## Frameworks

1. **Feel-Felt-Found** -- empathy-based reframing
2. **Isolate & Solve** -- confirm the ONLY objection, then handle it
3. **Boomerang** -- turn the objection into a reason to buy
4. **Preemptive Strike** -- handle objections before they surface
5. **Social Proof Stack** -- similar person + similar situation + positive outcome
6. **Cost of Inaction** -- reframe price against the cost of NOT buying
7. **The Takeaway** -- strategic withdrawal to create urgency

## File Structure

```
objection-destroyer/
├── _meta.json                          # Skill metadata and config
├── SKILL.md                            # Core skill definition (agent reads this)
├── README.md                           # This file
├── SCORECARD.md                        # Tracking template for win rates
├── references/
│   ├── frameworks.md                   # All 7 frameworks with examples
│   ├── industry-objections.md          # Top 20 objections x 5 industries
│   └── psychology.md                   # Cialdini, Kahneman, Voss research
└── scripts/
    └── drill.sh                        # Interactive practice mode
```

## Psychology Backing

Every framework maps to peer-reviewed research:
- **Cialdini**: Reciprocity, Commitment, Social Proof, Authority, Liking, Scarcity, Unity
- **Kahneman & Tversky**: Loss Aversion, Anchoring, Status Quo Bias, Framing Effect
- **Chris Voss**: Tactical Empathy, Labeling, Calibrated Questions, Accusation Audit
- **Sandler**: Pain Funnel, Negative Reverse Selling, Equal Business Stature

## Competitive Comparison

| Feature | Gong ($5K + $1.4K/user/yr) | Chorus ($1.2K/user/yr) | Objection Destroyer ($0) |
|---------|---------------------------|----------------------|-------------------------|
| Objection detection | Post-call tagging | Post-call tagging | Real-time classification |
| Response generation | None (analytics only) | None (analytics only) | Instant, 3 tone variants |
| Practice mode | Call library review | Call library review | Interactive drilling |
| Framework library | None | None | 7 frameworks, industry-mapped |
| Psychology backing | None | None | Full Cialdini/Kahneman/Voss |
| Runs locally | No (cloud SaaS) | No (cloud SaaS) | Yes (Ollama + bash) |
| Price | $6,400+/year | $1,200+/year | Free (KOINO IP) |

## Ethics

This system is built on a foundation of genuine value delivery:
- Never generates deceptive or manipulative responses
- Recommends walking away when the product isn't right for the prospect
- Respects hard boundaries
- The goal is helping prospects make the best decision, not "winning"
