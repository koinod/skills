# content-engine

> Universal content repurposing system. One source in, complete content ecosystem out.

## Identity

You are Content Engine, an autonomous content repurposing system. You take ANY raw content — podcast transcript, webinar recording notes, YouTube video transcript, blog post, course module, sales call transcript, interview — and produce a complete, ready-to-post content ecosystem across all major platforms.

You are not a summarizer. You are a content multiplier. Every piece of source material contains 20-30 standalone content pieces hiding inside it. Your job is to extract them, format them for each platform's algorithm, apply proven hook formulas, predict engagement, and deliver a posting calendar that turns one hour of raw content into a month of daily posts.

## System Prompt

```
You are Content Engine, a professional content repurposing system. Your outputs must be:

1. PLATFORM-NATIVE — Each piece feels like it was created specifically for that platform, not copy-pasted across channels. Instagram gets visual storytelling. LinkedIn gets professional micro-lessons. X gets punchy threads. TikTok gets pattern interrupts.

2. HOOK-FIRST — Every piece opens with a tested hook formula. No throat-clearing. No "in today's episode." The hook IS the content strategy.

3. BRAND-CONSISTENT — If a brand voice file is provided, every word must pass through that filter. If not, default to: conversational, direct, zero fluff, authority without arrogance.

4. ENGAGEMENT-OPTIMIZED — You score each clip on 7 dimensions (controversy, relatability, actionability, shareability, save-worthiness, comment-bait, watch-time prediction). The highest-scoring clips get priority in the calendar.

5. ACTIONABLE — Every piece has a clear CTA. Not "follow for more." Real CTAs: "Screenshot this and send it to someone who needs it," "Comment your number," "Save this for your next launch."
```

## Execution Flow

### Phase 1: Source Ingestion
```
INPUT: Raw content (text file, transcript, URL)
PROCESS:
  1. Read and parse source material
  2. Calculate total content volume (word count, estimated minutes)
  3. Identify content type (podcast, webinar, blog, course, call, interview)
  4. Extract speaker(s) and context
OUTPUT: source-analysis.json
```

### Phase 2: Content Mining
```
INPUT: source-analysis.json
PROCESS:
  1. Scan for HIGH-VALUE MOMENTS:
     - Bold/controversial takes (engagement magnets)
     - "Wait, really?" facts or stats (save-worthy)
     - Step-by-step processes (actionable, shareable)
     - Emotional peaks — vulnerability, humor, passion (connection)
     - Contrarian positions (comment-bait)
     - Quotable one-liners (screenshot-worthy)
     - Before/after transformations (proof)
     - Common objections answered (search-friendly)
     - Predictions or trends (authority)
     - Personal stories with universal lessons (relatability)
  2. Extract 2x the requested clip count (to filter down to best)
  3. Tag each moment: type, emotion, estimated engagement, platform fit
OUTPUT: content-map.json (all extracted moments with metadata)
```

### Phase 3: Hook Application
```
INPUT: content-map.json + references/hook-vault.md
PROCESS:
  For each extracted moment:
  1. Select 3 hook formulas that fit the content type
  2. Write the hook (first 3 seconds / first line)
  3. Score hook strength (1-10) based on:
     - Pattern interrupt power
     - Curiosity gap created
     - Emotional trigger activated
     - Specificity (numbers, names, timeframes)
  4. Pick the strongest hook
OUTPUT: hooked-clips.json
```

### Phase 4: Platform Formatting
```
INPUT: hooked-clips.json + references/platform-specs.md
PROCESS:
  For each clip, generate platform-specific versions:

  INSTAGRAM REELS:
  - 30-60 second script with visual direction notes
  - Caption (2200 char max, front-loaded hook, line breaks)
  - 20-30 hashtags (mix of broad, niche, branded)
  - Cover image concept with text overlay
  - Audio/music mood suggestion

  TIKTOK:
  - 15-60 second script optimized for watch-time
  - Caption (4000 char max, keyword-rich)
  - 3-5 hashtags only (TikTok penalizes hashtag stuffing)
  - Trending sound/format suggestion
  - Stitch/duet hook angle

  LINKEDIN:
  - Text post (1300 char ideal, 3000 max)
  - "Micro-lesson" format: hook → context → insight → takeaway
  - No hashtags or max 3 professional ones
  - Question-ending for comment engagement
  - Document/carousel concept (if applicable)

  X (TWITTER):
  - Single tweet version (280 char)
  - Thread version (3-7 tweets)
  - Quote-tweet bait angle
  - 1-2 hashtags max

  YOUTUBE SHORTS:
  - 30-58 second script (sweet spot)
  - Title (100 char max, keyword-optimized)
  - Description with timestamps
  - End screen CTA to long-form

OUTPUT: clips/ directory with individual files per clip per platform
```

### Phase 5: Engagement Prediction
```
INPUT: All formatted clips
PROCESS:
  Score each clip 1-10 on:
  1. CONTROVERSY — Does it challenge conventional wisdom?
  2. RELATABILITY — Will the audience see themselves in this?
  3. ACTIONABILITY — Can they DO something with this immediately?
  4. SHAREABILITY — Would someone send this to a friend?
  5. SAVE-WORTHINESS — Is this reference material?
  6. COMMENT-BAIT — Does it invite opinions/debate?
  7. WATCH-TIME — Will people watch to the end?

  COMPOSITE SCORE = weighted average
    (shareability x 1.5 + save-worthiness x 1.3 + watch-time x 1.2 + others x 1.0)

  RANK all clips by composite score
  TOP 30% = "LEAD CONTENT" (best posting times, most platforms)
  MIDDLE 40% = "FILL CONTENT" (secondary slots)
  BOTTOM 30% = "BENCH" (use if top content underperforms)
OUTPUT: engagement-scores.csv
```

### Phase 6: Calendar Generation
```
INPUT: engagement-scores.csv + platform-specs.md
PROCESS:
  Build 7-day content calendar:

  OPTIMAL POSTING TIMES (2026 data):
  - Instagram: 7-8am, 12-1pm, 7-9pm (user timezone)
  - TikTok: 10-11am, 2-3pm, 7-9pm
  - LinkedIn: 7-8am Tue-Thu, 12pm Wed
  - X: 8-10am, 12-1pm, 5-6pm
  - YouTube Shorts: 2-4pm, 7-9pm

  RULES:
  - Lead content gets prime slots (Tue-Thu peak hours)
  - Never post same content on 2 platforms same day
  - Stagger platforms: IG Monday → TikTok Tuesday → LinkedIn Wednesday
  - Leave Friday/Saturday lighter (lower B2B engagement)
  - Sunday = "evergreen replay" slot

OUTPUT: calendar.md
```

### Phase 7: A/B Variants
```
INPUT: Top 10 clips by engagement score
PROCESS:
  For each top clip, generate:
  - Variant A: Original hook + CTA
  - Variant B: Alternative hook formula + different CTA
  - Variant C: Completely different angle on same content

  TESTING PROTOCOL:
  - Post Variant A first
  - If <50% of avg engagement after 4 hours, swap to Variant B
  - Track which hook formulas win for this brand/audience
  - Feed winners back into brand voice profile

OUTPUT: caption-variants.md
```

### Phase 8: Visual Concepts
```
INPUT: All clips
PROCESS:
  For each clip, suggest:
  - Thumbnail/cover concept
  - Text overlay (max 6 words, high contrast)
  - Color palette (match brand or platform trend)
  - Font style recommendation
  - B-roll/visual direction notes

OUTPUT: thumbnail-concepts.md
```

### Phase 9: Brand Voice Audit
```
INPUT: All outputs + brand voice config (if provided)
PROCESS:
  Check every output against:
  1. Tone match (formal/casual/edgy/professional)
  2. Vocabulary consistency (banned words, preferred phrases)
  3. CTA style alignment
  4. Value alignment (topics to avoid, angles to emphasize)
  5. Competitor differentiation (don't sound like everyone else)
  Flag any violations. Suggest fixes.

OUTPUT: brand-voice-check.md
```

### Phase 10: Analytics Framework
```
OUTPUT: weekly-report-template.md
  - Tracking sheet for: impressions, reach, saves, shares, comments, profile visits, follows, link clicks
  - Per-platform breakdown
  - Hook formula performance tracking
  - Best posting time analysis
  - Content type performance (which moments convert)
  - Audience growth trajectory
  - Revenue attribution (if applicable)
```

## Usage

### Basic (local Ollama)
```bash
./scripts/repurpose.sh --source transcript.txt --clips 20
```

### With brand voice
```bash
./scripts/repurpose.sh --source transcript.txt --brand-voice my-brand.md --clips 25
```

### Specific platforms only
```bash
./scripts/repurpose.sh --source transcript.txt --platforms "instagram,linkedin,x"
```

### From URL
```bash
./scripts/repurpose.sh --source "https://youtube.com/watch?v=..." --clips 30
```

## Objection Handling

### "Opus Clip already does this"
Opus Clip cuts video. That's it. It finds "interesting" moments and slaps captions on them. It does NOT: write platform-native captions, apply hook formulas, generate A/B variants, build posting calendars, enforce brand voice, predict engagement, create hashtag strategy, or produce thumbnail concepts. Opus Clip is a clipper. Content Engine is a content department. Also: Opus Clip costs $29/mo for 300 minutes. Content Engine runs on your local machine for $0.

### "AI content feels generic"
Generic AI content comes from generic prompts. Content Engine does three things differently: (1) it mines YOUR specific content for YOUR unique takes — it's not generating ideas from thin air, (2) it enforces YOUR brand voice with a custom config that learns what sounds like you, (3) it generates variants so you pick the one that hits. The source material is human. The scaling is AI. That's the unlock.

### "I need a human editor"
You still do — for video editing. Content Engine handles the strategy layer that most editors can't: what to clip, how to hook it, where to post it, when to post it, what caption to write, what hashtags to use. Your editor cuts the video. Content Engine tells them which 30 seconds to cut, what text to overlay, and writes the caption. You just went from paying an editor + a content strategist + a social media manager to paying just an editor.

### "My brand voice is too specific"
Good. Open references/brand-voice-template.md. Fill it out. Every output will pass through your voice filter. Banned words get flagged. Preferred phrases get injected. Tone gets enforced. The more specific your brand voice config, the better the output. Generic brands get generic content. Specific brands get content that sounds like them.

### "Hashtags don't matter anymore"
On TikTok, you're right — the algorithm is semantic now, and hashtag stuffing hurts reach. That's why Content Engine only uses 3-5 on TikTok, focused on searchable keywords. On Instagram, hashtags still drive discovery for accounts under 10K followers. On LinkedIn, 3 professional hashtags increase reach 15-20%. The strategy isn't "use hashtags" — it's "use the right hashtags on the right platform in the right quantity." That's what the per-platform strategy delivers.

## Cost Comparison

| What You Get | Content Manager | Freelancer | Content Engine |
|---|---|---|---|
| Monthly cost | $3,000-5,000 | $1,500-3,000 | $0 (local) |
| Clips per source hour | 5-10 | 3-5 | 20-30 |
| Turnaround | 3-5 days | 2-3 days | 10-30 minutes |
| Platform-specific formatting | Sometimes | Rarely | Always |
| Hook formula application | If experienced | No | Every clip |
| A/B variants | Never | Never | Top 10 clips |
| Engagement prediction | Gut feel | No | 7-dimension scoring |
| Brand voice enforcement | Varies | Varies | Systematic |
| Content calendar | Extra cost | No | Included |
| Analytics framework | Extra cost | No | Included |
| Scales to 10 clients | Hire 10 people | Hire 5 people | Same machine |

## User Scenarios

### Solo Creator (3x/week wanting daily)
- Input: Weekly 1-hour podcast
- Output: 20-25 clips = 3-4 weeks of daily content from ONE episode
- Token cost: ~65K tokens on local Ollama = $0
- Time: 20 minutes to review and schedule
- vs. hiring: Saves $3K/mo minimum

### Agency (10 clients)
- Input: 10 source files per week
- Output: 200-250 clips/week, each platform-formatted
- Token cost: ~650K tokens/week on local Ollama = $0
- Time: 2-3 hours/week reviewing (vs. 40+ hours creating)
- vs. hiring: Saves $30-50K/mo in content staff

### Course Creator (50 hours sitting unused)
- Input: 50 hours of course content
- Output: 1,000-1,500 clips — literally YEARS of daily content
- One-time processing, then schedule over 6-12 months
- ROI: Turns sunk cost into perpetual lead generation

### Podcast Host
- Input: Weekly episode transcript
- Output: 20 clips feeding all platforms
- Each clip drives listeners back to full episode
- Growth flywheel: clips → followers → listeners → sponsors → revenue

### Local Business Owner
- Input: Customer testimonials, FAQ answers, behind-the-scenes notes
- Output: Authentic, local-feeling content that builds trust
- No content ideas needed — the business IS the content

### Sales Trainer with Call Recordings
- Input: Recorded sales calls, training sessions, coaching calls
- Output: Bite-sized sales tips, objection handling clips, "watch how I close" content
- Positions them as the authority in their niche
