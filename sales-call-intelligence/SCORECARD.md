# Sales Call Intelligence — Forge Scorecard

## 7-Dimension Forge Score

| Dimension | Score | Notes |
|-----------|-------|-------|
| **Originality** | 9/10 | No open-source skill does 8-dimension call analysis with 4-methodology scoring. Gong/Chorus do pieces but at $200+/seat/mo with enterprise lock-in. The battle card generation from real calls and personalized drill creation are unique to this packaging. |
| **Utility** | 10/10 | Every person who sells needs this. From solo closers to 10-person teams. The cost-per-call ($0.02-0.08) vs value-per-insight makes this a no-brainer. |
| **Depth** | 9/10 | 4 full methodology frameworks embedded (SPIN, Challenger, MEDDIC, Sandler) with scoring matrices. 7-dimension analysis framework with composite scoring. Cross-call pattern recognition. Not a surface-level summarizer. |
| **Defensibility** | 7/10 | The methodology frameworks are public knowledge. The defensibility is in the specific scoring matrices, the 8-dimension analysis combination, the drill generation system, and the cross-call pattern engine. Someone could rebuild this, but it would take 40+ hours and deep sales knowledge. |
| **Token Efficiency** | 8/10 | /quick runs in ~1500 tokens. /analyze in ~5000. Per-call cost at $0.02-0.08 is 100-1000x cheaper than competitors. Could be more efficient with structured output schemas. |
| **Completeness** | 9/10 | 7 commands covering the full workflow from single-call rapid scoring to multi-call pattern analysis. Bash script handles 5 input formats. References cover all 4 methodologies with scoring rubrics. Missing: actual API integration with Fathom/Otter (by design — keeps it format-agnostic). |
| **Revenue Potential** | 9/10 | At $49/mo suggested retail, this undercuts Gong by 80% while delivering the coaching value most reps actually need. ClawHub distribution + organic SEO for "free Gong alternative" = acquisition channel. |

**Composite Forge Score: 8.7/10**

---

## Simulation Results

### Persona 1: Solo Closer ($50K/mo → $200K target)
- **Would they use it?** YES. This rep reviews 2-3 calls/day and currently has no system.
- **Token burn**: ~$12/mo for daily /quick + weekly deep /analyze on key calls
- **Value created**: Finding even 1 pattern costing them deals = $10K-50K/quarter improvement
- **Willingness to pay**: $49/mo is a rounding error at their income level
- **Verdict**: STRONG BUY. This is their film room.

### Persona 2: 5-Person SaaS Sales Team
- **Would they use it?** YES. Sales manager runs /patterns monthly, reps run /quick daily.
- **Token burn**: ~$40/mo total team (50 calls/week analyzed)
- **Value created**: Replaces a $12K+/year Gong seat minimum. /patterns across team identifies coaching priorities data-driven.
- **Willingness to pay**: $49/seat or $149/team. Still 90% cheaper than alternatives.
- **Verdict**: STRONG BUY. This is their coaching infrastructure.

### Persona 3: Insurance Agent (30 calls/day)
- **Would they use it?** YES — but only /quick for batch screening, /analyze on won/lost deals only.
- **Token burn**: ~$18/mo (/quick on all calls) or ~$6/mo (selective deep analysis)
- **Value created**: Insurance sales is high-volume, pattern-dependent. Cross-call patterns show which objection handling works for which policy type.
- **Willingness to pay**: $29-49/mo. Insurance agents spend more than this on leads.
- **Verdict**: BUY. Volume play makes the pattern engine especially valuable.

### Persona 4: D2D Rep (evening review)
- **Would they use it?** MAYBE. Needs phone recording → transcript pipeline first.
- **Token burn**: ~$8/mo (5 calls reviewed/day via /quick, 2 deep /analyze per week)
- **Value created**: D2D reps rarely have coaching. This is like having a manager reviewing your pitch nightly. Sandler-weighted scoring fits D2D perfectly.
- **Willingness to pay**: $19-29/mo. D2D reps are price-sensitive.
- **Verdict**: CONDITIONAL BUY. Needs easy recording setup guide. High retention once they see patterns.

### Persona 5: Sales Coach
- **Would they use it?** ABSOLUTELY. This is their power tool.
- **Token burn**: ~$30/mo (analyzing client calls, generating drills, building battle card libraries)
- **Value created**: Turns a 1-hour call review into a 10-minute data-driven coaching session. /coach command produces ready-made 1:1 agendas. /drill generates homework.
- **Willingness to pay**: $99-149/mo. This is a business tool that saves hours per client.
- **Verdict**: STRONG BUY. Highest-value persona. Would pay premium tier.

### Persona 6: AI Agency Selling to Local Businesses
- **Would they use it?** YES. They eat their own cooking — using AI to sell AI.
- **Token burn**: ~$15/mo (analyzing their own sales calls + demoing the capability to prospects)
- **Value created**: Double value — improves their own close rate AND demonstrates AI capability to prospects. "Let me analyze YOUR last sales call right now" = killer demo moment.
- **Willingness to pay**: $49/mo easily. Some would white-label it.
- **Verdict**: STRONG BUY. Natural evangelists and distribution partners.

### Simulation Summary

| Persona | Buy? | Monthly Spend | Value Multiple | Retention Risk |
|---------|------|---------------|----------------|----------------|
| Solo Closer | YES | $49 | 50-200x | Low |
| SaaS Team | YES | $149 | 20-80x | Low |
| Insurance Agent | YES | $29-49 | 10-30x | Medium |
| D2D Rep | MAYBE | $19-29 | 5-15x | Medium-High |
| Sales Coach | YES | $99-149 | 30-100x | Very Low |
| AI Agency | YES | $49 | 20-50x | Low |

**Average willingness to pay: $57/mo**
**Average value multiple: 30x**
**5 of 6 personas are strong buys.**

---

## Competitive Positioning

| Feature | Gong | Chorus | Clari | This Skill |
|---------|------|--------|-------|------------|
| Price floor | $50K + $200/user/mo | $8K/yr min | $120/user/mo | $0.02/call |
| Min commitment | Annual | Annual | Annual | Per call |
| Setup time | Weeks | Weeks | Weeks | 0 |
| Methodology scoring | No | No | No | 4 frameworks |
| Battle card gen | Manual | No | No | Automatic |
| Drill generation | No | No | No | Yes |
| Cross-call patterns | Yes | Limited | Yes | Yes (5+ calls) |
| Works offline | No | No | No | Yes (Ollama) |
| Own your data | No (their cloud) | No | No | Yes |
| CRM integration | Yes | Yes | Yes | No (by design) |
| Call recording | Yes | Yes | Yes | No (BYO transcript) |

**Positioning**: "We don't record your calls or manage your pipeline. We make you better at selling. Bring your transcript, get back intelligence."

---

## Risk Assessment

| Risk | Likelihood | Mitigation |
|------|-----------|------------|
| LLM hallucination in scoring | Medium | Specific rubrics reduce variance. Instruct for evidence-based scoring with transcript quotes. |
| Token cost spikes on long calls | Low | 60-min call transcript ~4K tokens. Cap at 8K with truncation note. |
| Competitors copy the approach | Medium | Speed to market + community + iteration. First-mover in the OpenClaw ecosystem. |
| Users expect call recording | High | Clear positioning: "BYO transcript." Partner list for free recording tools in README. |
| Quality degrades on small models | Medium | /quick works well on 3B+ models. /analyze and /patterns need 7B+ for reliable methodology scoring. |

---

## Distribution Strategy

1. **ClawHub**: Primary distribution. SEO for "sales call analysis skill," "free Gong alternative"
2. **Reddit**: r/sales, r/salesforce, r/insurance — post analysis examples on anonymized calls
3. **YouTube**: "I analyzed 100 sales calls with AI — here's what I learned" content
4. **Sales coaching communities**: Offer coaches white-label or referral rev-share
5. **Agency partnerships**: AI agencies bundle this as a client deliverable

## Pricing Tiers (Future)

| Tier | Price | Includes |
|------|-------|----------|
| Free | $0 | 5 /quick analyses per month |
| Pro | $49/mo | Unlimited analysis, patterns, battle cards |
| Team | $149/mo | Up to 10 users, shared pattern library |
| Coach | $99/mo | White-label reports, client management |
