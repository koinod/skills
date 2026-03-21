# Autonomous Revenue Scorecard

## Weekly KPIs

| Metric | Target | Grade A | Grade B | Grade C | Grade F |
|--------|--------|---------|---------|---------|---------|
| Products launched | 2/week | 3+ | 2 | 1 | 0 |
| Market scans run | 7/week | 7 | 5-6 | 3-4 | <3 |
| Gross revenue | $125/week | >$200 | $125-200 | $50-124 | <$50 |
| Conversion rate | 3-8% | >5% | 3-5% | 1-3% | <1% |
| Refund rate | <5% | <2% | 2-5% | 5-10% | >10% |
| Products in catalog | Growing | +2 net | +1 net | Flat | Shrinking |
| Ethical violations | 0 | 0 | 0 | 1 (minor) | Any major |
| QA pass rate | 100% | 100% | 90%+ | 80%+ | <80% |

## Monthly Milestones

| Month | Revenue Target | Products Live | Key Milestone |
|-------|---------------|---------------|---------------|
| 1 | $100-500 | 3-5 | First sale. Prove the loop works. |
| 2 | $300-1000 | 6-10 | Consistent daily sales. Identify best vertical. |
| 3 | $500-2000 | 10-15 | Bundle strategy. Agent-to-agent sales via MPP. |
| 6 | $2000-5000 | 15-30 | Fleet deployment (2-3 vertical agents). |
| 12 | $5000+ | 30+ | Self-sustaining. Covers all infrastructure costs. |

## Product Health Score

Rate each product weekly:

```
THRIVING  (score 8-10): Revenue growing, conversion >5%, zero refunds
HEALTHY   (score 5-7):  Steady sales, conversion 2-5%, refunds <5%
DECLINING (score 3-4):  Sales dropping, conversion 1-2%, investigate
DYING     (score 1-2):  <$1/day, conversion <1%, candidate for retirement
DEAD      (score 0):    No sales in 14+ days, retire immediately
```

### Product Score Formula
```
revenue_score  = (daily_revenue / $5) * 3    # max 3 points
convert_score  = (conversion_rate / 3%) * 3  # max 3 points
refund_score   = (1 - refund_rate/10%) * 2   # max 2 points
age_penalty    = -1 if no sale in 7 days     # penalty
trend_bonus    = +1 if revenue growing week-over-week
total          = revenue_score + convert_score + refund_score + age_penalty + trend_bonus
```

## Fleet Scorecard (when running multiple agents)

| Agent | Vertical | Products | Revenue/mo | Status |
|-------|----------|----------|-----------|--------|
| Agent 1 | DevTools | - | $0 | BOOTSTRAP |
| Agent 2 | SMB Ops | - | $0 | PLANNED |
| Agent 3 | Creator | - | $0 | PLANNED |
| Agent 4 | Freelance | - | $0 | PLANNED |
| Agent 5 | Education | - | $0 | PLANNED |
| **TOTAL** | | **0** | **$0** | |

## Decision Triggers

| Condition | Action |
|-----------|--------|
| Product refund rate >15% | Retire immediately, refund all buyers |
| Product 0 sales for 14 days with >100 views | Rewrite sales page, re-price |
| Product 0 sales for 30 days | Retire |
| Product conversion >5% | Raise price 15%, create related products |
| Product revenue >$10/day | Create bundle, expand into adjacent topics |
| Portfolio <3 products | Priority: launch new products |
| Monthly revenue >$500 | Consider fleet expansion |
| Ethical violation detected | Halt all operations, human review required |

## Grading Period

Every Sunday at 9pm, run full scorecard:
1. Pull revenue report (`scripts/revenue-report.sh --days 7`)
2. Score each product
3. Kill bottom performers (>30 days old, score <3)
4. Identify expansion opportunities (score >7)
5. Update fleet scorecard
6. Set next week's targets
7. Log grade to `/tmp/autonomous-revenue/scorecards/week_YYYY-WW.json`

## North Star Metric

**Net revenue per hour of agent compute time.**

If an agent costs $5/month in compute and generates $500/month in revenue, that is a 100x return. Track this ratio obsessively. It determines whether fleet expansion is justified.
