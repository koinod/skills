# Source Evaluation Framework

## CRAAP+ Framework

Score each source 1-5 on each dimension. Minimum threshold: 15/25 for inclusion.

### Currency (1-5)
| Score | Criteria |
|-------|----------|
| 5 | Published within last 3 months, topic is fast-moving |
| 4 | Published within last year |
| 3 | Published within last 2-3 years, topic is stable |
| 2 | Published 3-5 years ago |
| 1 | Published 5+ years ago OR undated |

### Relevance (1-5)
| Score | Criteria |
|-------|----------|
| 5 | Directly addresses the research question with specific data |
| 4 | Closely related, provides useful context or adjacent data |
| 3 | Tangentially related, useful for triangulation |
| 2 | Loosely related, only useful if nothing better exists |
| 1 | Off-topic or too general to be useful |

### Authority (1-5)
| Score | Criteria |
|-------|----------|
| 5 | Primary source, recognized domain expert, peer-reviewed, or official filing |
| 4 | Known publication with editorial standards, credentialed author |
| 3 | Established blog/publication, author has demonstrable experience |
| 2 | Unknown author but content appears well-researched |
| 1 | Anonymous, no credentials, or known unreliable source |

### Accuracy (1-5)
| Score | Criteria |
|-------|----------|
| 5 | Claims are verifiable, data is sourced, methodology is transparent |
| 4 | Most claims verifiable, some data sourced |
| 3 | Claims are plausible but not all verifiable |
| 2 | Some claims unverifiable, potential errors noted |
| 1 | Contains known errors, unsourced claims, or contradicts established facts |

### Purpose (1-5)
| Score | Criteria |
|-------|----------|
| 5 | Informational/educational with no commercial interest |
| 4 | Has commercial context but clearly separates fact from promotion |
| 3 | Sponsored or commercial but contains verifiable facts |
| 2 | Primarily promotional, facts are cherry-picked |
| 1 | Pure marketing, propaganda, or agenda-driven with no factual basis |

## Source Hierarchy

Use higher-tier sources to validate lower-tier sources. Never let lower-tier sources override higher-tier ones without explicit justification.

### Tier 1 — Primary Sources (Most Reliable)
- SEC/regulatory filings (10-K, 10-Q, S-1, proxy statements)
- Court documents and legal filings
- Patent applications
- Academic peer-reviewed papers
- Official government data and statistics
- Company earnings calls and transcripts (direct quotes)
- Published financial statements

### Tier 2 — High-Quality Secondary
- Major investigative journalism (NYT, WSJ, FT, Bloomberg, Reuters)
- Industry analyst reports (Gartner, Forrester, IDC) — note: paid by vendors
- Academic working papers and preprints
- Expert testimony and congressional hearings
- Established trade publications with editorial standards

### Tier 3 — Useful But Verify
- Company blog posts and press releases (biased but contain data)
- Conference talks and interviews (valuable for stated strategy)
- Independent blogger/analyst with track record
- Community platforms (HN, Reddit, specialized forums) — wisdom of crowds
- Customer review platforms (G2, Capterra, Trustpilot)

### Tier 4 — Treat With Caution
- Social media posts (Twitter/X, LinkedIn)
- Anonymous sources
- Wikipedia (useful for leads, never cite as primary)
- AI-generated content (may hallucinate)
- Undated or unattributed content

### Tier 5 — Red Flags
- Content farms and SEO-optimized listicles
- Sources with no author, no date, no methodology
- Obvious promotional content disguised as research
- Sources that have been previously debunked

## Conflict of Interest Detection

Always ask:
1. **Who paid for this?** (funding sources, sponsorships)
2. **Who benefits from this conclusion?** (follow the money)
3. **What is the author's relationship to the subject?** (employee, investor, competitor)
4. **Has the author taken contradictory positions before?** (paid to say different things)
5. **Is there a regulatory or legal incentive to present data this way?**

## Cross-Reference Protocol

A claim is considered:
- **Verified**: 3+ independent Tier 1-2 sources agree
- **Corroborated**: 2 independent sources agree (at least 1 Tier 1-2)
- **Reported**: Single Tier 1-2 source, no contradiction found
- **Unverified**: Single Tier 3+ source only
- **Contested**: Credible sources disagree
- **Debunked**: Contradicted by Tier 1 sources
