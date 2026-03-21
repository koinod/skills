# Content Engine

**One source in. Complete content ecosystem out. $0/month.**

Content Engine takes any raw content — podcast transcript, webinar notes, YouTube video transcript, blog post, course module, call recording — and produces a full, ready-to-post content ecosystem across Instagram, TikTok, LinkedIn, X, and YouTube Shorts.

## What You Get

From a single source file, Content Engine generates:

- **20-30 short-form clips** with hooks, body copy, and CTAs
- **Platform-specific formatting** — each piece is native to its platform, not copy-pasted
- **52 proven hook formulas** applied to your specific content
- **7-day content calendar** with optimal posting times per platform
- **Engagement prediction scoring** — know which clips will perform before posting
- **A/B caption variants** for split testing your top clips
- **Hashtag/keyword strategy** tailored per platform
- **Thumbnail/cover concepts** with text overlay suggestions
- **Brand voice enforcement** — learns your voice from a config file
- **Weekly analytics framework** — track what's working and iterate

## Quick Start

```bash
# Basic — 20 clips from a transcript
./scripts/repurpose.sh --source my-podcast-transcript.txt

# With brand voice enforcement
./scripts/repurpose.sh --source transcript.txt --brand-voice my-brand.md

# 30 clips, specific platforms only
./scripts/repurpose.sh --source transcript.txt --clips 30 --platforms "instagram,linkedin"
```

## Requirements

- Ollama (local, free)
- Any model (default: qwen2.5:3b — runs on 8GB RAM)
- jq, curl, bash

## Cost Comparison

| | Content Manager | Content Engine |
|---|---|---|
| Monthly cost | $3,000-5,000 | $0 |
| Clips per source hour | 5-10 | 20-30 |
| Turnaround | 3-5 days | 20 minutes |
| Brand consistency | Variable | Systematic |
| A/B testing | Never | Built-in |
| Scales to 10 clients | Hire 10 people | Same machine |

## Demo Output

Given a 45-minute podcast transcript about sales coaching:

```
content-engine-output/
├── source-analysis.json          # Content type, topics, audience
├── content-map.json              # 40 extracted high-value moments
├── hooked-clips.json             # 20 clips with hook formulas applied
├── clips/
│   ├── instagram.json            # IG Reels: scripts, captions, 25 hashtags each
│   ├── tiktok.json               # TikTok: keyword-rich captions, 3-5 tags
│   ├── linkedin.json             # LinkedIn: micro-lesson text posts
│   ├── x.json                    # X: single tweets + thread versions
│   └── youtube_shorts.json       # Shorts: titles, descriptions, CTAs
├── engagement-scores.csv         # All clips ranked by 7-dimension scoring
├── calendar.md                   # 7-day schedule with optimal times
├── caption-variants.md           # A/B/C variants for top 10 clips
├── hashtag-strategy.md           # Per-platform hashtag + keyword plan
├── thumbnail-concepts.md         # Visual concepts + text overlays
├── brand-voice-check.md          # Voice consistency audit
└── weekly-report-template.md     # Analytics tracking framework
```

## Who This Is For

- **Solo creators** wanting to go from 3x/week to daily without burnout
- **Agencies** managing multiple client accounts
- **Course creators** sitting on hours of unused video content
- **Podcast hosts** wanting to grow on short-form platforms
- **Business owners** who don't know what to post
- **Sales trainers** with call recordings gathering dust

## File Structure

```
content-engine/
├── SKILL.md                          # Complete skill definition + execution flow
├── README.md                         # This file
├── _meta.json                        # Skill metadata
├── SCORECARD.md                      # Quality assessment + competitive analysis
├── scripts/
│   └── repurpose.sh                  # Main execution script
└── references/
    ├── hook-vault.md                 # 52 proven hook formulas by category
    ├── platform-specs.md             # 2026 specs for 5 platforms
    └── brand-voice-template.md       # 10-section brand voice config
```
