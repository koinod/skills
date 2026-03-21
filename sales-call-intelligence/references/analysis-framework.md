# Call Analysis Framework

How the skill scores calls across 7 dimensions and produces actionable output.

---

## Pre-Analysis: Transcript Normalization

Before analysis, the transcript is normalized:
1. **Speaker identification**: Label speakers as REP and PROSPECT (or multiple prospects if group call)
2. **Timestamp extraction**: If available, preserve timing for arc mapping
3. **Phase detection**: Segment the call into phases:
   - **Opening** (0-10%): Rapport, agenda setting
   - **Discovery** (10-40%): Questions, pain exploration
   - **Presentation** (40-70%): Solution, value prop, demo
   - **Negotiation** (70-85%): Objections, pricing, terms
   - **Close** (85-100%): Next steps, commitment, wrap-up
4. **Word count per speaker**: Raw data for talk ratio

---

## Dimension 1: Engagement Quality Score (0-100)

Measures how deeply the prospect was engaged.

**Signals of high engagement:**
- Prospect asks unprompted questions (especially about implementation, pricing, timeline)
- Prospect shares information not asked for (internal politics, past failures, personal stakes)
- Prospect uses "we" language including the rep's solution
- Prospect brings up their own team members by name
- Prospect pushes back thoughtfully (means they're processing, not dismissing)

**Signals of low engagement:**
- Short, one-word answers
- Prospect redirects to email/send info
- Long pauses after rep questions
- Prospect repeats "interesting" or "makes sense" without depth
- Prospect talks about process without talking about problem

**Scoring:**
- 90-100: Prospect was leaning in, driving parts of the conversation
- 70-89: Good back-and-forth, prospect invested
- 50-69: Polite but surface-level
- 30-49: Going through the motions
- 0-29: Prospect checked out, wanted off the call

---

## Dimension 2: Discovery Depth Score (0-100)

Measures how well the rep understood the prospect's world before presenting.

**Level 1 — Surface** (0-25 points): Knows the prospect's role, company, basic situation
**Level 2 — Problem** (25-50 points): Knows what's not working and why
**Level 3 — Impact** (50-75 points): Knows the business cost of the problem
**Level 4 — Personal** (75-100 points): Knows how the problem affects this person's career, compensation, reputation, or stress

Most reps plateau at Level 2. Top closers reach Level 4.

---

## Dimension 3: Objection Handling Score (0-100)

Each objection scored on:
- **Recognition** (0-20): Did the rep hear it? Some reps steamroll past objections.
- **Acknowledgment** (0-20): Did they validate it? "I understand" doesn't count — specific acknowledgment does.
- **Exploration** (0-20): Did they dig deeper? "Is that the main concern?" / "What specifically worries you about that?"
- **Resolution** (0-20): Did they address the root cause, not just the surface?
- **Advancement** (0-20): Did they move forward after handling it, or let awkward silence kill momentum?

**Aggregate**: Average across all objections encountered. Zero objections on a discovery call is neutral (not scored). Zero objections on a closing call is a red flag (means they didn't push hard enough).

---

## Dimension 4: Closing Strength Score (0-100)

**Did the rep:**
- Summarize the value proposition in the prospect's own words? (+20)
- Create urgency tied to the prospect's timeline, not artificial scarcity? (+20)
- Ask for a specific commitment (not "what do you think?")? (+20)
- Handle the final objection cleanly? (+20)
- Leave with a locked next step (date, time, attendees, agenda)? (+20)

**Deductions:**
- "I'll send you some info" without a booked follow-up: -30
- "Let me know if you have questions": -20
- Ending the call without asking for anything: -40
- Premature close before establishing value: -20

---

## Dimension 5: Competitive Intelligence Score (0-100)

**When competitors come up:**
- Did the rep know the competitor? (+15)
- Did they acknowledge competitor strengths honestly? (+15)
- Did they differentiate without bashing? (+20)
- Did they identify the prospect's specific comparison criteria? (+25)
- Did they plant a land mine (question the prospect should ask the competitor)? (+25)

If no competitor was mentioned: Not scored (neutral).

---

## Dimension 6: Value Articulation Score (0-100)

**How well did the rep connect solution to prospect's specific pain?**

- **Generic pitch** (0-25): Same value prop they tell everyone. "We save you time and money."
- **Segment-tailored** (25-50): Right value prop for the industry/role but not personalized.
- **Prospect-tailored** (50-75): Referenced the prospect's specific situation, used their words.
- **Co-created** (75-100): The prospect helped build the value case using their own numbers and scenarios. ("So if you're losing 3 deals a month to slow follow-up, and each deal is worth $15K, that's $45K/month on the table...")

---

## Dimension 7: Overall Call Control Score (0-100)

**The rep's ability to guide the conversation:**
- Set an agenda and followed it (+15)
- Redirected tangents without being rude (+15)
- Managed time well (didn't rush close, didn't waste time on irrelevant topics) (+15)
- Controlled pacing (knew when to speed up, when to let silence work) (+15)
- Handled surprises (unexpected objections, new stakeholders, curveballs) without losing composure (+20)
- Ended with clear mutual commitments (+20)

---

## Composite Call Score

The 7 dimensions produce a composite:

| Grade | Score | Description |
|-------|-------|-------------|
| A+ | 95-100 | Elite call. Study this for replication. |
| A | 90-94 | Excellent. Minor polish items only. |
| A- | 85-89 | Very strong. One dimension to improve. |
| B+ | 80-84 | Good call. Clear areas for growth. |
| B | 75-79 | Solid but leaving money on the table. |
| B- | 70-74 | Decent. Multiple improvement opportunities. |
| C+ | 65-69 | Average. Needs coaching on fundamentals. |
| C | 60-64 | Below average. Re-train on methodology. |
| C- | 55-59 | Weak. Significant gaps in approach. |
| D | 45-54 | Poor. Back to basics. |
| F | 0-44 | Start over. This approach won't scale. |

---

## Pattern Analysis (Multi-Call)

When 5+ calls are provided, additional analysis unlocks:

### Win/Loss Correlation
- Compare dimension scores between won and lost deals
- Identify the dimension with the largest gap (this is the #1 training priority)

### Objection Frequency Map
- Rank all objections by frequency across calls
- Show handling success rate for each
- Identify the "killer objection" — the one that correlates most with lost deals

### Temporal Patterns
- What time of day does the rep perform best?
- Do calls get worse as the day progresses (fatigue)?
- Are Monday/Friday calls weaker?

### Talk Ratio Trends
- Is the rep getting better or worse over time?
- Does talk ratio correlate with outcomes in their specific data?

### Improvement Velocity
- Week-over-week score trends
- Which dimensions are improving vs stagnant
- Predicted time to target score at current improvement rate

---

## Output Prioritization

Reports prioritize by impact:
1. **Revenue-blocking issues**: Things that are actively costing deals (missed buying signals, weak close, unhandled objections)
2. **Efficiency issues**: Things that waste time or tokens (too many situation questions, long monologues)
3. **Style issues**: Things that affect long-term relationship quality (tone, empathy, authenticity)

This ordering ensures the rep fixes the highest-dollar problem first.
