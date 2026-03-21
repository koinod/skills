#!/usr/bin/env bash
# content-engine/scripts/repurpose.sh
# Universal content repurposing engine — local Ollama execution
# Usage: ./repurpose.sh --source <file> [--brand-voice <file>] [--clips <n>] [--platforms <list>] [--output <dir>]

set -euo pipefail

# ── Defaults ──
SOURCE=""
BRAND_VOICE=""
CLIP_COUNT=20
PLATFORMS="instagram,tiktok,linkedin,x,youtube_shorts"
OUTPUT_DIR="./content-engine-output"
MODEL="${CONTENT_ENGINE_MODEL:-qwen2.5:3b}"
OLLAMA_HOST="${OLLAMA_HOST:-http://localhost:11434}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

# ── Colors ──
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

log()  { echo -e "${CYAN}[engine]${NC} $1"; }
ok()   { echo -e "${GREEN}[  OK  ]${NC} $1"; }
warn() { echo -e "${YELLOW}[ WARN ]${NC} $1"; }
fail() { echo -e "${RED}[FATAL]${NC} $1"; exit 1; }

# ── Parse Args ──
while [[ $# -gt 0 ]]; do
  case "$1" in
    --source)       SOURCE="$2"; shift 2 ;;
    --brand-voice)  BRAND_VOICE="$2"; shift 2 ;;
    --clips)        CLIP_COUNT="$2"; shift 2 ;;
    --platforms)    PLATFORMS="$2"; shift 2 ;;
    --output)       OUTPUT_DIR="$2"; shift 2 ;;
    --model)        MODEL="$2"; shift 2 ;;
    --help|-h)
      echo "Usage: repurpose.sh --source <file> [options]"
      echo ""
      echo "Options:"
      echo "  --source <file>       Path to source content (required)"
      echo "  --brand-voice <file>  Path to brand voice config"
      echo "  --clips <n>           Number of clips to generate (default: 20)"
      echo "  --platforms <list>    Comma-separated platforms (default: all)"
      echo "  --output <dir>        Output directory (default: ./content-engine-output)"
      echo "  --model <name>        Ollama model (default: qwen2.5:3b)"
      exit 0
      ;;
    *) fail "Unknown arg: $1" ;;
  esac
done

[[ -z "$SOURCE" ]] && fail "Missing --source. Run with --help for usage."
[[ ! -f "$SOURCE" ]] && fail "Source file not found: $SOURCE"

# ── Preflight ──
log "Checking Ollama at $OLLAMA_HOST..."
if ! curl -sf "$OLLAMA_HOST/api/tags" > /dev/null 2>&1; then
  warn "Ollama not responding. Attempting to start..."
  ollama serve &>/dev/null &
  sleep 3
  curl -sf "$OLLAMA_HOST/api/tags" > /dev/null 2>&1 || fail "Cannot reach Ollama. Start it manually: ollama serve"
fi
ok "Ollama online"

# Check model
if ! curl -sf "$OLLAMA_HOST/api/tags" | jq -e ".models[] | select(.name | startswith(\"$MODEL\"))" > /dev/null 2>&1; then
  log "Pulling model $MODEL..."
  ollama pull "$MODEL"
fi
ok "Model $MODEL ready"

# ── Setup Output ──
mkdir -p "$OUTPUT_DIR"/{clips,reports}
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="$OUTPUT_DIR/reports/run_${TIMESTAMP}.log"

log "Source: $SOURCE"
log "Clips: $CLIP_COUNT"
log "Platforms: $PLATFORMS"
log "Output: $OUTPUT_DIR"
log "Model: $MODEL"
echo "---"

# ── Helper: Query Ollama ──
query_ollama() {
  local prompt="$1"
  local response
  response=$(curl -sf "$OLLAMA_HOST/api/generate" \
    -d "$(jq -n --arg model "$MODEL" --arg prompt "$prompt" '{model: $model, prompt: $prompt, stream: false}')" \
    2>/dev/null)
  echo "$response" | jq -r '.response // empty'
}

# ── Read Source ──
SOURCE_TEXT=$(cat "$SOURCE")
WORD_COUNT=$(echo "$SOURCE_TEXT" | wc -w)
EST_MINUTES=$(( WORD_COUNT / 150 ))  # ~150 wpm speaking rate

log "Source: ${WORD_COUNT} words (~${EST_MINUTES} min of spoken content)"

# ── Load References ──
HOOK_VAULT=""
[[ -f "$SKILL_DIR/references/hook-vault.md" ]] && HOOK_VAULT=$(cat "$SKILL_DIR/references/hook-vault.md")
PLATFORM_SPECS=""
[[ -f "$SKILL_DIR/references/platform-specs.md" ]] && PLATFORM_SPECS=$(cat "$SKILL_DIR/references/platform-specs.md")
BRAND_CONFIG=""
[[ -n "$BRAND_VOICE" && -f "$BRAND_VOICE" ]] && BRAND_CONFIG=$(cat "$BRAND_VOICE")

# ── Phase 1: Source Analysis ──
log "Phase 1/10: Analyzing source content..."

ANALYSIS_PROMPT="Analyze this content and return a JSON object with these fields:
- content_type: (podcast/webinar/blog/course/call/interview/other)
- primary_topic: main subject
- sub_topics: array of 3-5 sub-topics covered
- speakers: array of speaker names/roles (or ['unknown'] if unclear)
- key_themes: array of 3-5 recurring themes
- tone: (casual/professional/educational/motivational/technical)
- target_audience: who this content is for
- unique_angles: 3 things said here that you wouldn't find in generic content on this topic

SOURCE CONTENT:
${SOURCE_TEXT:0:8000}

Return ONLY valid JSON, no markdown fencing."

ANALYSIS=$(query_ollama "$ANALYSIS_PROMPT")
echo "$ANALYSIS" > "$OUTPUT_DIR/source-analysis.json"
ok "Source analysis complete"

# ── Phase 2: Content Mining ──
log "Phase 2/10: Mining high-value moments..."

MINING_COUNT=$(( CLIP_COUNT * 2 ))
MINING_PROMPT="You are a content strategist. Extract the ${MINING_COUNT} most valuable, clip-worthy moments from this content.

For each moment, return a JSON array where each item has:
- id: sequential number
- quote: the exact text or close paraphrase (2-4 sentences)
- type: (bold_take/surprising_fact/step_by_step/emotional_peak/contrarian/quotable/transformation/objection_answer/prediction/personal_story)
- emotion: primary emotion it triggers
- standalone: can this make sense without context? (true/false)
- platform_fit: array of best platforms for this moment

SOURCE CONTENT:
${SOURCE_TEXT:0:12000}

Return ONLY a valid JSON array."

CONTENT_MAP=$(query_ollama "$MINING_PROMPT")
echo "$CONTENT_MAP" > "$OUTPUT_DIR/content-map.json"
ok "Extracted moments from source"

# ── Phase 3: Hook Application ──
log "Phase 3/10: Applying hook formulas..."

HOOK_PROMPT="You are a hook writing expert. Take these content moments and write hooks for each one.

CONTENT MOMENTS:
$CONTENT_MAP

HOOK FORMULAS TO USE (pick the best fit for each moment):
- Curiosity Gap: 'Nobody talks about [X]...'
- Contrarian: '[Popular belief] is completely wrong...'
- Relatability: 'If you're [type], this is for you...'
- Value: 'Here's exactly how I [result]...'
- Story: 'The moment I realized [truth]...'
- Pattern Interrupt: Start mid-sentence, no context
- Authority: 'After [X years], here's what actually works...'
- Urgency: '[Platform] just changed [thing]...'
- Question: 'Why does everyone [X] when [better thing] exists?'

For each moment, return a JSON array with:
- id: matching moment id
- hook: the written hook (first 1-2 sentences only)
- hook_type: which formula used
- hook_score: 1-10 strength rating
- body: 3-5 sentence main content
- cta: specific call to action

Return ONLY valid JSON array."

HOOKED=$(query_ollama "$HOOK_PROMPT")
echo "$HOOKED" > "$OUTPUT_DIR/hooked-clips.json"
ok "Hooks applied"

# ── Phase 4: Platform Formatting ──
log "Phase 4/10: Formatting for each platform..."

IFS=',' read -ra PLAT_ARRAY <<< "$PLATFORMS"
for platform in "${PLAT_ARRAY[@]}"; do
  platform=$(echo "$platform" | xargs)  # trim whitespace
  log "  Formatting for: $platform"

  FORMAT_PROMPT="Format these content clips for ${platform}. Use platform-native conventions.

CLIPS:
$HOOKED

PLATFORM RULES FOR ${platform^^}:
$(case $platform in
  instagram) echo "- 30-60 sec scripts, 2200 char caption, 20-25 hashtags, cover image concept, visual storytelling" ;;
  tiktok) echo "- 15-60 sec scripts, keyword-rich caption, 3-5 hashtags only, trending format suggestion, pattern interrupt in 1 sec" ;;
  linkedin) echo "- 1000-1300 char text post, micro-lesson format (hook>context>insight>takeaway>question), max 3 hashtags, professional tone" ;;
  x) echo "- 280 char single tweet + 5-7 tweet thread version, 1-2 hashtags max, punchy and quotable" ;;
  youtube_shorts) echo "- 30-58 sec script, 100 char title (keyword-optimized), description with keywords, CTA to long-form" ;;
esac)

For each clip, return:
- id, hook, body, cta, caption, hashtags (array), visual_notes

Return the top ${CLIP_COUNT} clips as a JSON array."

  FORMATTED=$(query_ollama "$FORMAT_PROMPT")
  echo "$FORMATTED" > "$OUTPUT_DIR/clips/${platform}.json"
done
ok "Platform formatting complete"

# ── Phase 5: Engagement Scoring ──
log "Phase 5/10: Predicting engagement..."

SCORE_PROMPT="Score each of these content clips on 7 dimensions (1-10 each).

CLIPS:
$HOOKED

DIMENSIONS:
1. CONTROVERSY - challenges conventional wisdom?
2. RELATABILITY - audience sees themselves?
3. ACTIONABILITY - can DO something immediately?
4. SHAREABILITY - would send to a friend?
5. SAVE_WORTHINESS - reference material?
6. COMMENT_BAIT - invites opinions/debate?
7. WATCH_TIME - will watch to the end?

COMPOSITE = (shareability*1.5 + save_worthiness*1.3 + watch_time*1.2 + others*1.0) / 8.2

Return a CSV format:
id,hook_preview,controversy,relatability,actionability,shareability,save_worthiness,comment_bait,watch_time,composite,tier

Tier: top 30% = LEAD, middle 40% = FILL, bottom 30% = BENCH

Return ONLY the CSV with header row."

SCORES=$(query_ollama "$SCORE_PROMPT")
echo "$SCORES" > "$OUTPUT_DIR/engagement-scores.csv"
ok "Engagement scores calculated"

# ── Phase 6: Content Calendar ──
log "Phase 6/10: Building content calendar..."

CALENDAR_PROMPT="Build a 7-day content calendar using these scored clips.

ENGAGEMENT SCORES:
$SCORES

PLATFORMS: $PLATFORMS

RULES:
- LEAD clips get prime slots (Tue-Thu peak hours)
- Never post same content on 2 platforms same day
- Stagger: IG Mon > TikTok Tue > LinkedIn Wed > X Thu > YT Fri
- Friday/Saturday lighter
- Sunday = evergreen replay

OPTIMAL TIMES:
- Instagram: 7-8am, 12-1pm, 7-9pm
- TikTok: 10-11am, 2-3pm, 7-9pm
- LinkedIn: 7-8am Tue-Thu, 12pm Wed
- X: 8-10am, 12-1pm, 5-6pm
- YouTube Shorts: 2-4pm, 7-9pm

Output a clean markdown table:
| Day | Time | Platform | Clip ID | Hook Preview | Tier | Notes |

Include at least 2-3 posts per day across platforms."

CALENDAR=$(query_ollama "$CALENDAR_PROMPT")
cat > "$OUTPUT_DIR/calendar.md" << CALEOF
# Content Calendar
Generated: $(date '+%Y-%m-%d %H:%M')
Source: $(basename "$SOURCE")

$CALENDAR

---
## Scheduling Notes
- All times are in your local timezone
- LEAD content is placed in highest-engagement slots
- Adjust based on your audience analytics after Week 1
- If a LEAD clip underperforms, swap with next BENCH clip
CALEOF
ok "Calendar generated"

# ── Phase 7: A/B Caption Variants ──
log "Phase 7/10: Generating A/B variants..."

VARIANT_PROMPT="Take the top 10 clips by engagement score and create A/B caption variants.

TOP CLIPS:
$HOOKED

For each clip, generate:
VARIANT A: Original hook + CTA
VARIANT B: Completely different hook formula + different CTA
VARIANT C: Different angle on the same content

Format as markdown with clear headers per clip.
Include testing protocol: post A first, if <50% avg engagement after 4 hours, try B."

VARIANTS=$(query_ollama "$VARIANT_PROMPT")
cat > "$OUTPUT_DIR/caption-variants.md" << VAREOF
# A/B Caption Variants
Generated: $(date '+%Y-%m-%d %H:%M')

## Testing Protocol
1. Post Variant A at scheduled time
2. Check engagement at 4-hour mark
3. If below 50% of your average: delete and repost Variant B
4. Track which hook formulas consistently win
5. Feed winners back into brand voice profile

---

$VARIANTS
VAREOF
ok "A/B variants generated"

# ── Phase 8: Hashtag Strategy ──
log "Phase 8/10: Building hashtag strategy..."

HASHTAG_PROMPT="Create a platform-specific hashtag and keyword strategy based on this content.

CONTENT ANALYSIS:
$ANALYSIS

For each platform ($PLATFORMS), provide:
1. PRIMARY hashtags (high volume, broad reach) - 5 tags
2. NICHE hashtags (targeted, lower competition) - 10 tags
3. BRANDED hashtags (create or use existing) - 2-3 tags
4. TRENDING keywords to work into captions
5. SEARCH terms your audience is typing

Platform-specific rules:
- TikTok: 3-5 tags max, focus on keywords in caption instead
- LinkedIn: 0-3 tags, professional only
- Instagram: 20-25 mix of sizes
- X: 1-2 or none
- YouTube: keywords in title and description, 3-5 tags

Format as clean markdown."

HASHTAGS=$(query_ollama "$HASHTAG_PROMPT")
cat > "$OUTPUT_DIR/hashtag-strategy.md" << HASHEOF
# Hashtag & Keyword Strategy
Generated: $(date '+%Y-%m-%d %H:%M')
Content Topic: Based on source analysis

$HASHTAGS

---
## Rotation Rules
- Never use the exact same hashtag set twice in a row
- Swap 30% of hashtags each post to test reach
- Track which hashtag sets drive the most non-follower reach
- Remove any hashtag that gets shadowban warnings
HASHEOF
ok "Hashtag strategy built"

# ── Phase 9: Thumbnail Concepts ──
log "Phase 9/10: Generating thumbnail concepts..."

THUMB_PROMPT="Create thumbnail/cover image concepts for the top 15 clips.

CLIPS:
$HOOKED

For each clip, provide:
- TEXT OVERLAY: Max 5-6 words, high contrast, punchy
- VISUAL CONCEPT: What should be in the image/frame
- COLOR PALETTE: 2-3 colors that pop on mobile
- FONT STYLE: Bold sans-serif, handwritten, etc.
- EXPRESSION/ENERGY: If face is shown, what expression
- B-ROLL NOTES: What supplementary footage/images to use

Format as markdown with clear sections per clip."

THUMBS=$(query_ollama "$THUMB_PROMPT")
cat > "$OUTPUT_DIR/thumbnail-concepts.md" << THUMBEOF
# Thumbnail & Cover Concepts
Generated: $(date '+%Y-%m-%d %H:%M')

## Design Rules
- Text must be readable at phone size (minimum 30pt equivalent)
- High contrast between text and background
- Face + text outperforms text alone by 40%
- Consistent brand colors build recognition
- Test 2 thumbnails per video if platform allows

---

$THUMBS
THUMBEOF
ok "Thumbnail concepts generated"

# ── Phase 10: Brand Voice Check + Report ──
log "Phase 10/10: Final audit..."

if [[ -n "$BRAND_CONFIG" ]]; then
  AUDIT_PROMPT="Audit these content outputs against the brand voice config.

BRAND VOICE CONFIG:
$BRAND_CONFIG

SAMPLE OUTPUTS:
$HOOKED

Check for:
1. Tone alignment (formal/casual/edgy match)
2. Banned word violations
3. CTA style consistency
4. Topic alignment
5. Competitor differentiation

Report violations and suggest fixes. Format as markdown."

  AUDIT=$(query_ollama "$AUDIT_PROMPT")
else
  AUDIT="No brand voice config provided. Using default voice (conversational, direct, zero fluff).

To enable brand voice enforcement, create a config file using:
  references/brand-voice-template.md

Then run with: --brand-voice your-config.md"
fi

cat > "$OUTPUT_DIR/brand-voice-check.md" << AUDITEOF
# Brand Voice Audit
Generated: $(date '+%Y-%m-%d %H:%M')

$AUDIT
AUDITEOF

# ── Weekly Report Template ──
cat > "$OUTPUT_DIR/weekly-report-template.md" << REPORTEOF
# Weekly Content Performance Report
Week of: ________

## Overview
| Metric | This Week | Last Week | Change |
|--------|-----------|-----------|--------|
| Total Posts | | | |
| Total Impressions | | | |
| Total Reach | | | |
| Total Engagement | | | |
| New Followers | | | |
| Profile Visits | | | |
| Link Clicks | | | |
| DMs Received | | | |

## Per-Platform Breakdown

### Instagram
| Post | Impressions | Reach | Saves | Shares | Comments | Hook Type |
|------|-------------|-------|-------|--------|----------|-----------|
| | | | | | | |

### TikTok
| Post | Views | Likes | Comments | Shares | Watch Time | Hook Type |
|------|-------|-------|----------|--------|------------|-----------|
| | | | | | | |

### LinkedIn
| Post | Impressions | Reactions | Comments | Reposts | Dwell Time | Hook Type |
|------|-------------|-----------|----------|---------|------------|-----------|
| | | | | | | |

### X
| Post | Impressions | Likes | Replies | Reposts | Bookmarks | Hook Type |
|------|-------------|-------|---------|---------|-----------|-----------|
| | | | | | | |

### YouTube Shorts
| Short | Views | Likes | Comments | Shares | Sub Gained | Hook Type |
|-------|-------|-------|----------|--------|------------|-----------|
| | | | | | | |

## Hook Formula Performance
| Hook Type | Times Used | Avg Engagement | Best Platform | Keep/Drop |
|-----------|-----------|----------------|---------------|-----------|
| Curiosity Gap | | | | |
| Contrarian | | | | |
| Relatability | | | | |
| Value/Tactical | | | | |
| Story | | | | |
| Pattern Interrupt | | | | |
| Authority | | | | |
| Question | | | | |

## Best Performing Content
1. **Top Post:** [link] — [metric] — Hook type: [type]
2. **Top Post:** [link] — [metric] — Hook type: [type]
3. **Top Post:** [link] — [metric] — Hook type: [type]

## Worst Performing Content
1. **Low Post:** [link] — Why it underperformed: ___
2. **Low Post:** [link] — Why it underperformed: ___

## Posting Time Analysis
| Time Slot | Avg Engagement | Best Platform |
|-----------|----------------|---------------|
| Morning (7-9am) | | |
| Midday (11am-1pm) | | |
| Afternoon (2-4pm) | | |
| Evening (7-9pm) | | |

## Content Type Performance
| Type | Posts | Avg Engagement | Trend |
|------|-------|----------------|-------|
| Bold takes | | | |
| How-to/tactical | | | |
| Personal stories | | | |
| Data/stats | | | |
| Behind-the-scenes | | | |

## Revenue Attribution
| Content Piece | Leads Generated | Calls Booked | Revenue Closed |
|---------------|----------------|--------------|----------------|
| | | | |

## Next Week Adjustments
- [ ] Hook formulas to use more: ___
- [ ] Hook formulas to drop: ___
- [ ] Posting times to adjust: ___
- [ ] Platforms to prioritize: ___
- [ ] Content types to lean into: ___
REPORTEOF

ok "Weekly report template created"

# ── Summary ──
echo ""
echo -e "${BOLD}═══════════════════════════════════════════════════${NC}"
echo -e "${GREEN}${BOLD}  CONTENT ENGINE — RUN COMPLETE${NC}"
echo -e "${BOLD}═══════════════════════════════════════════════════${NC}"
echo ""
echo -e "  Source:      $(basename "$SOURCE") (${WORD_COUNT} words, ~${EST_MINUTES} min)"
echo -e "  Clips:       ${CLIP_COUNT} generated across ${#PLAT_ARRAY[@]} platforms"
echo -e "  Output:      ${OUTPUT_DIR}/"
echo ""
echo -e "  ${CYAN}Files generated:${NC}"
echo -e "    source-analysis.json      — Content type, topics, themes"
echo -e "    content-map.json          — All extracted moments"
echo -e "    hooked-clips.json         — Moments with hook formulas applied"
echo -e "    clips/                    — Platform-formatted content"
echo -e "    engagement-scores.csv     — Ranked by 7-dimension scoring"
echo -e "    calendar.md               — 7-day posting schedule"
echo -e "    caption-variants.md       — A/B test variants for top clips"
echo -e "    hashtag-strategy.md       — Per-platform hashtag/keyword plan"
echo -e "    thumbnail-concepts.md     — Visual concepts + text overlays"
echo -e "    brand-voice-check.md      — Voice consistency audit"
echo -e "    weekly-report-template.md — Analytics tracking framework"
echo ""
echo -e "  ${YELLOW}Next steps:${NC}"
echo -e "    1. Review engagement-scores.csv — focus on LEAD tier clips"
echo -e "    2. Follow calendar.md for posting schedule"
echo -e "    3. Use caption-variants.md for A/B testing"
echo -e "    4. Fill weekly-report-template.md after 7 days"
echo -e "    5. Feed performance data back into next run"
echo ""
echo -e "  ${GREEN}Cost: \$0.00 (local Ollama)${NC}"
echo -e "  ${GREEN}vs Content Manager: \$3,000-5,000/month${NC}"
echo -e "${BOLD}═══════════════════════════════════════════════════${NC}"
