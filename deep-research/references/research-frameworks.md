# Research Frameworks Reference

## 1. OSINT Framework (Bellingcat Method)

### Core Process
1. **Define the question** — What specifically are you trying to verify or discover?
2. **Identify source categories** — Satellite imagery, social media, public records, corporate filings, domain registrations, archived web pages, metadata
3. **Collect broadly** — Gather everything, filter later
4. **Cross-reference** — No single source is authoritative. Every claim needs independent corroboration
5. **Document methodology** — Every step recorded so others can verify
6. **Preserve evidence** — Archive pages (Wayback Machine, archive.today) because sources disappear
7. **Chronological reconstruction** — Build timelines to identify inconsistencies

### Key OSINT Source Types
| Source Type | Examples | Strength | Weakness |
|-------------|----------|----------|----------|
| Satellite imagery | Google Earth, Sentinel Hub, Planet Labs | Hard to fake, timestamped | Resolution limits, cloud cover |
| Corporate filings | SEC EDGAR, state SOS, Companies House | Legal obligation = more reliable | Lags reality, can be shell structures |
| Social media | Twitter, LinkedIn, Reddit, HN | Real-time, candid | Manipulation, bots, selection bias |
| Domain/DNS | WHOIS, DNS history, SSL certs | Reveals infrastructure and timing | Privacy services obscure data |
| Web archives | Wayback Machine, archive.today | Historical evidence preservation | Incomplete coverage |
| Job postings | LinkedIn, Indeed, Glassdoor | Reveals strategy and priorities | Aspirational vs actual |
| Patent filings | USPTO, Google Patents, Espacenet | Reveals R&D direction | Filed years before products |
| Financial data | Crunchbase, PitchBook, SEC filings | Concrete numbers | Private companies opaque |
| Academic | Google Scholar, Semantic Scholar, arXiv | Peer-reviewed, methodological | Slow, may lag practice |
| Government | Data.gov, census, regulatory databases | Authoritative, comprehensive | Aggregated, delayed |

### Bellingcat Verification Checklist
- Can you independently verify this with a different source type?
- Does the metadata (timestamps, geolocation) match the claims?
- Who published this and what do they gain?
- Has this been altered? (reverse image search, metadata analysis)
- What is the chain of custody for this information?

---

## 2. Systematic Review Protocol (Academic Method)

### PRISMA-Derived Steps for Business Research
1. **Registration**: Write down your research question and methodology BEFORE searching (prevents confirmation bias)
2. **Search strategy**: Define search terms, databases, date ranges, inclusion/exclusion criteria
3. **Screening**: Title/abstract screen -> Full review -> Final inclusion
4. **Data extraction**: Pull structured data from each source using consistent framework
5. **Quality assessment**: Rate each source on methodology, bias risk, relevance
6. **Synthesis**: Identify patterns, conflicts, gaps across all included sources
7. **Sensitivity analysis**: Would your conclusions change if you removed the weakest sources?
8. **Reporting**: Transparent documentation of entire process

### Adapting Academic Rigor for Speed
- Use the PROTOCOL step even in quick research (30 seconds to write down your question and criteria)
- Always do a sensitivity check: "If my best source is wrong, does my conclusion still hold?"
- Keep a running exclusion log: sources you found but rejected, and why

---

## 3. Competitive Intelligence Framework (Hedge Fund Method)

### Porter's Five Forces + Extensions
1. **Competitive rivalry** — Who competes directly? Market share? Growth rates? Strategy differentiation?
2. **Supplier power** — Who controls critical inputs? Single points of failure?
3. **Buyer power** — How much leverage do customers have? Switching costs?
4. **Threat of substitution** — What alternatives exist? What would make customers switch?
5. **Threat of new entry** — Barriers? Capital requirements? Network effects? Regulatory moats?
6. **Complementors** (Brandenburger extension) — Who benefits when this market grows?
7. **Regulatory environment** — Who regulates? Pending legislation? Enforcement trends?

### Alternative Data Sources (Hedge Fund Style)
| Data Type | What It Reveals | Where to Find |
|-----------|-----------------|---------------|
| Job postings | Strategic priorities, growth areas, tech stack | LinkedIn, Indeed, Glassdoor |
| App store rankings | Consumer traction, feature velocity | App Annie, Sensor Tower, manual checks |
| Web traffic estimates | Growth trajectory, geographic mix | SimilarWeb, Semrush |
| Patent filings | R&D direction 2-3 years out | USPTO, Google Patents |
| Hiring velocity | Confidence level, growth vs contraction | LinkedIn headcount, job board volume |
| Domain registrations | New product lines, pivots | WHOIS databases, DNS records |
| GitHub activity | Engineering investment, community health | GitHub API, contributor analysis |
| Conference talks | Thought leadership, positioning shifts | YouTube, conference archives |
| Regulatory filings | Compliance posture, market entry signals | SEC, state regulators, FCC |
| Customer reviews | True product quality, pain points | G2, Capterra, TrustPilot, Reddit |

### Mosaic Theory
No single data point tells the full story. Combine:
- **Quantitative signals** (traffic, downloads, revenue estimates)
- **Qualitative signals** (customer sentiment, employee reviews, expert opinions)
- **Structural signals** (market dynamics, regulatory shifts, technology changes)
- **Temporal signals** (how all of the above are changing over time)

The ALPHA is in the intersection where most people look at only one dimension.

---

## 4. Scenario Planning Framework

### 2x2 Matrix Method
1. Identify the two most UNCERTAIN and most IMPACTFUL variables
2. Create a 2x2 matrix with high/low for each
3. Name each quadrant scenario
4. For each scenario: What happens? Who wins? Who loses? What are the leading indicators?
5. Develop monitoring triggers: what observable events would tell you which scenario is unfolding?

### Pre-Mortem (Inversion)
Instead of: "How does this succeed?"
Ask: "It's 12 months later and this failed spectacularly. What happened?"
- List every possible failure mode
- Rate each on likelihood and impact
- The failure modes that multiple people independently identify are your real risks

---

## 5. Red Team / Contrarian Analysis

### Devil's Advocate Protocol
For every major finding or thesis:
1. State the thesis clearly
2. Steel-man the strongest possible counterargument
3. Find evidence that supports the counterargument
4. Assess: is the counterargument fatal, wounding, or superficial?
5. If wounding or fatal: revise the thesis
6. Document the surviving (stress-tested) thesis with both supporting and opposing evidence

### Cognitive Bias Checklist
Before finalizing research, check for:
- **Confirmation bias**: Did I weight confirming evidence more heavily?
- **Anchoring**: Am I overly influenced by the first information I found?
- **Availability bias**: Am I overweighting recent or vivid examples?
- **Survivorship bias**: Am I only looking at successes, not failures?
- **Authority bias**: Am I accepting expert claims without verification?
- **Narrative bias**: Am I fitting data to a story rather than letting data drive conclusions?
- **Sunk cost**: Am I reluctant to discard a thesis I spent time building?
