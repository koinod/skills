# Sales Call Intelligence

**Enterprise conversation intelligence without the enterprise price tag.**

Gong charges $50K+ platform fees. Chorus needs 3-seat minimums. Clari wants $160/user/month. You just want to know why you lost that deal and how to win the next one.

Sales Call Intelligence analyzes your transcripts and gives you what matters: the objection patterns you keep hitting, the buying signals you keep missing, the exact phrases that move deals, and drills to fix your weaknesses. All powered by the LLM you already pay for.

## What You Get

| Feature | Gong ($240/mo) | This Skill ($0.05/call) |
|---------|----------------|------------------------|
| Talk-to-listen ratio | Yes | Yes |
| Objection detection | Basic categories | Root cause + battle cards |
| Buying signal alerts | Next-day email | Instant, with missed-signal flags |
| Methodology scoring | No | SPIN + Challenger + MEDDIC + Sandler |
| Emotional arc mapping | "Sentiment" label | Phase-by-phase energy tracking |
| Golden moment extraction | Keyword highlights | Context-aware inflection points |
| Personalized drills | No | Scenario-based from your weaknesses |
| Battle card generation | Manual | Auto-generated from real calls |
| Cross-call patterns | Yes (expensive) | Yes (5+ transcripts) |
| Min commitment | Annual contract | Per call |

## Cost Math

- Average transcript: 2,000-4,000 input tokens
- Analysis output: ~3,000 tokens
- Cost per call (Claude Haiku): ~$0.02
- Cost per call (GPT-4o-mini): ~$0.01
- Cost per call (local Ollama): $0.00

**A rep doing 10 calls/day spends ~$6/month.** Gong would charge $2,880/year for the same rep.

## Who This Is For

**Solo closers** doing $50K-500K/mo who know they're leaving money on the table but can't pinpoint where. You'll find the 2-3 patterns costing you deals and get drills to fix them in a week.

**Small sales teams (2-10 reps)** who need coaching infrastructure without a $50K platform. Run /patterns across your team's calls and build a shared battle card library from real objections.

**Insurance agents** doing 30+ calls/day who need rapid scoring. Use /quick for 60-second assessments and only deep-dive on the calls that matter.

**D2D reps** reviewing evening recordings. Process the day's calls in batch, get a training plan for tomorrow.

**Sales coaches** who want data behind their feedback. Stop guessing — show reps exactly where they lost the deal with transcript evidence and methodology scores.

**AI/agency founders** selling services to businesses. Your calls have unique objection patterns (trust, ROI timeline, "we tried AI before"). Build battle cards specific to your vertical.

## Objection Responses (Why This Beats Alternatives)

### "Gong already does this"
Gong does call recording, CRM sync, deal boards, and team dashboards. It's a platform. This is a scalpel. Gong gives you a sentiment score and keyword tags. This gives you root-cause objection analysis, methodology grading across 4 frameworks, and generates practice drills from your actual weaknesses. Also: Gong's minimum is $50K/year platform + $200/user/month. This costs pennies per call. If you have Gong and $50K to spare, great. If you don't, this gets you 80% of the coaching value at 1% of the cost.

### "I don't have call recordings"
You need transcripts, not recordings. Options that cost $0: Fathom (free tier, unlimited recordings/transcriptions on Zoom/Meet/Teams), Otter.ai free tier, Google Meet's built-in transcription, Zoom's built-in transcription. Record on your phone and run Whisper locally. If you're making sales calls without recording them, that's the first problem — you're practicing without film.

### "AI can't understand sales nuance"
Fair concern, bad conclusion. AI won't replace your gut feeling on a live call. That's not what this does. This catches the patterns you can't see because you're inside the conversation. You talked for 72% of that call — did you notice? The prospect asked about implementation twice and you pivoted to features both times — did you catch that? The best athletes watch film. This is film review for sales.

### "Too expensive in tokens"
At $0.02-0.08 per call analysis, a rep doing 10 calls/day spends $6-24/month. If one analysis helps you close one extra deal per quarter, the ROI is somewhere between 100x and infinite. Use /quick for $0.005/call if you want to screen which calls deserve deep analysis.

### "I'll just use ChatGPT and paste my transcript"
You can. You'll get a generic summary. This skill embeds 4 sales methodology frameworks, scores against proven benchmarks, generates battle cards in a reusable format, tracks patterns across calls, and creates drills targeted at your specific weaknesses. It's the difference between asking a random person to watch your game tape vs. having a position coach break it down.

## Commands

| Command | What It Does | Tokens | Time |
|---------|-------------|--------|------|
| `/analyze` | Full 8-dimension deep analysis | ~5K | 30s |
| `/quick` | Rapid A-F score with top win/fix | ~1.5K | 10s |
| `/battlecard` | Generate objection battle cards | ~2K | 15s |
| `/patterns` | Cross-call pattern recognition | ~8K | 60s |
| `/drill` | Practice scenarios from weaknesses | ~2K | 15s |
| `/coach` | Manager-style coaching report | ~4K | 25s |
| `/compare` | Side-by-side call comparison | ~5K | 30s |

## Quick Start

1. Record your next sales call (Fathom, Otter, phone recorder, anything)
2. Get the transcript (copy-paste, export, or run Whisper)
3. Run: `openclaw sales-call-intelligence analyze < transcript.txt`
4. Read your report. Fix the #1 thing. Make the next call better.
5. After 5+ calls, run `/patterns` to see your trends.

## Vertical Playbooks

This skill works across verticals but is especially tuned for:
- **SaaS sales** (demo calls, discovery, negotiation)
- **Insurance** (needs analysis, policy comparison, objection handling)
- **Real estate** (listing presentations, buyer consultations)
- **Coaching/consulting** (enrollment calls, strategy sessions)
- **Agency sales** (pitch meetings, scope discussions)
- **D2D** (door approaches, in-home presentations)

## The Philosophy

Most sales tools optimize for managers who want dashboards. This optimizes for the rep who wants to close more. Every output is designed to be actionable tomorrow, not interesting in a quarterly review.

Your calls contain thousands of data points about how you sell. Right now, those data points evaporate the moment you hang up. This captures them, finds the patterns, and turns them into repeatable skill.

The best closers aren't born — they're built through deliberate practice on real scenarios. This is the practice engine.
