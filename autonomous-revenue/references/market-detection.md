# Market Gap Detection System

## Signal Sources and Configuration

### Tier 1: High-Signal Sources

#### Reddit
```yaml
subreddits:
  universal:
    - r/smallbusiness
    - r/entrepreneur
    - r/freelance
    - r/SaaS
    - r/automation
  devtools:
    - r/webdev
    - r/node
    - r/python
    - r/selfhosted
    - r/devops
  creator:
    - r/content_marketing
    - r/socialmedia
    - r/videography
  business_ops:
    - r/bookkeeping
    - r/realtors
    - r/lawncare
    - r/HVAC

search_queries:
  - "I wish there was"
  - "looking for a template"
  - "anyone know a tool"
  - "tired of manually"
  - "is there an automation"
  - "spreadsheet for tracking"
  - "how do you handle"
  - "what do you use for"

filters:
  min_upvotes: 5
  max_age_days: 30
  min_comments: 3
```

#### Twitter/X
```yaml
search_queries:
  - '"I wish someone would build"'
  - '"someone should make"'
  - '"looking for a template" -filter:links'
  - '"need a tool for" -sponsored'
  - '"manually doing" OR "doing manually"'
  - '"there should be an app"'
  - '"wasting time on"'

filters:
  min_likes: 3
  max_age_days: 14
  language: en
```

#### Product Hunt
```yaml
monitor:
  - New launches in target categories
  - Comment sections for complaints and "missing feature" mentions
  - "Alternatives wanted" posts
  - Products with high upvotes but negative comments (gap = good idea, bad execution)
```

### Tier 2: Trend Sources

#### Google Trends
```yaml
categories:
  - "automation template"
  - "AI tool for [vertical]"
  - "[platform] integration"
  - "how to automate [task]"

alerts:
  - Rising search terms (>100% increase in 30 days)
  - Breakout terms (new searches with rapid growth)
```

#### Gumroad / Lemon Squeezy
```yaml
monitor:
  - Top sellers in target categories (what IS selling)
  - Search results with <10 products (low competition)
  - Products with reviews mentioning what's missing
  - Price points (identify overpriced or underpriced segments)
```

### Tier 3: Emerging Signals

#### GitHub
```yaml
monitor:
  - Trending repos (what developers are building)
  - Issues labeled "help wanted" or "good first issue" (pain points)
  - New API/SDK releases (create starter kits within 48 hours)
```

#### Hacker News
```yaml
monitor:
  - "Ask HN" and "Show HN" threads
  - Comments expressing frustration with existing tools
  - Discussions about new protocols (MPP, x402, etc.)
```

## Gap Scoring Algorithm

### Inputs
```yaml
demand_signals:     # How many people are asking for this?
  multiple_asks: 0-5        # Same need expressed by different people
  willingness_to_pay: 0-5   # Explicit "I'd pay for..." signals

supply_gap:         # How well is the market serving this need?
  existing_overpriced: 0-4   # Alternatives exist but cost too much
  existing_too_complex: 0-4  # Alternatives exist but require expertise
  no_alternative: 0-4        # Nothing exists at all

timing:             # Is there a time advantage?
  trend_momentum: 0-3       # Rising search interest
  event_driven: 0-3         # New platform, regulation, season
  competition_speed: 0-2    # How fast will competitors appear?
```

### Scoring
```
total_score = demand_signals + supply_gap + timing
max_score = 30

PROCEED if score >= 18
CONSIDER if score >= 12
SKIP if score < 12
```

### Score Interpretation
```
25-30: Urgent opportunity — create and launch within 24 hours
18-24: Strong opportunity — add to pipeline, create within 1 week
12-17: Possible opportunity — monitor for 2 weeks, re-score
0-11:  Not worth pursuing — log and move on
```

## Output: Gap Report

```yaml
gap_report:
  generated: "2026-03-21T06:00:00Z"
  scan_sources: 12
  signals_detected: 47
  gaps_scored: 8

  top_gaps:
    - rank: 1
      title: "Stripe MPP Integration Starter Kit"
      score: 22/30
      demand:
        asks: 4 (reddit:2, twitter:1, hn:1)
        pay_signals: "multiple devs saying 'would pay $50+'"
      supply:
        alternatives: "Stripe docs only — no packaged solution"
        complexity: "HIGH — scattered across blog posts and API docs"
      timing:
        trend: "MPP launched 3 days ago, peak interest"
        window: "2-4 weeks before competitors emerge"
      recommended_format: "starter-kit"
      recommended_price: "$49"
      confidence: "HIGH"

    - rank: 2
      title: "n8n Workflow Templates for Client Onboarding"
      score: 19/30
      # ... etc
```

## Scan Frequency

| Source | Frequency | Rationale |
|--------|-----------|-----------|
| Reddit | Daily | New posts constantly, pain points expressed in real-time |
| Twitter/X | Daily | Fast-moving, trend-sensitive |
| Product Hunt | Daily | New launches = new gaps |
| Google Trends | Weekly | Trends develop over weeks |
| Gumroad/LS | Weekly | Catalog changes slowly |
| GitHub | 2x/week | New releases and trending repos |
| HN | Daily | Developer sentiment shifts fast |

## Vertical-Specific Playbooks

### DevTools
Primary sources: GitHub, HN, r/webdev, r/node, r/python
Key signals: New API launches, framework updates, protocol releases
Product formats: Starter kits, boilerplate code, integration guides
Price range: $29-99

### Small Business Ops
Primary sources: r/smallbusiness, Twitter, Google Trends
Key signals: "How do I...", seasonal needs, regulation changes
Product formats: SOPs, checklists, spreadsheet templates
Price range: $15-45

### Content Creators
Primary sources: Twitter, r/content_marketing, YouTube comments
Key signals: "Takes me hours to...", tool complaints, workflow questions
Product formats: Prompt packs, automation templates, planning templates
Price range: $15-40

### Freelancers/Agencies
Primary sources: r/freelance, Twitter, Upwork trends
Key signals: Client management pain, pricing questions, proposal writing
Product formats: Templates, SOPs, prompt libraries
Price range: $20-60
