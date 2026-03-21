#!/usr/bin/env bash
#
# analyze-call.sh — Sales Call Intelligence analysis via OpenClaw
#
# Usage:
#   analyze-call.sh <transcript_file> [command] [options]
#
# Commands:
#   analyze    Full 8-dimension analysis (default)
#   quick      Rapid A-F score
#   battlecard Generate objection battle cards
#   patterns   Cross-call analysis (pass directory)
#   drill      Practice scenarios from weaknesses
#   coach      Coaching report
#   compare    Compare two transcripts
#
# Options:
#   --model <model>    LLM to use (default: from env or "default")
#   --output <file>    Write report to file
#   --format <fmt>     Output format: markdown (default), json, plain
#   --vertical <v>     Sales vertical: saas, insurance, realestate, d2d, coaching, agency
#   --quiet            Suppress progress messages
#
# Examples:
#   analyze-call.sh call-2026-03-21.txt
#   analyze-call.sh call.vtt quick
#   analyze-call.sh calls/ patterns
#   analyze-call.sh call1.txt compare --output report.md
#   cat transcript.txt | analyze-call.sh -
#
set -euo pipefail

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SKILL_NAME="sales-call-intelligence"
VERSION="1.0.0"

# Defaults
COMMAND="analyze"
MODEL="${SCI_MODEL:-${OPENCLAW_MODEL:-default}}"
OUTPUT=""
FORMAT="markdown"
VERTICAL="auto"
QUIET=false
INPUT=""
INPUT2=""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

usage() {
    head -28 "$0" | tail -26 | sed 's/^# \?//'
    exit 0
}

log() {
    if [ "$QUIET" = false ]; then
        echo -e "${CYAN}[SCI]${NC} $*" >&2
    fi
}

error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
    exit 1
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help) usage ;;
        --model) MODEL="$2"; shift 2 ;;
        --output) OUTPUT="$2"; shift 2 ;;
        --format) FORMAT="$2"; shift 2 ;;
        --vertical) VERTICAL="$2"; shift 2 ;;
        --quiet) QUIET=true; shift ;;
        analyze|quick|battlecard|patterns|drill|coach|compare)
            COMMAND="$1"; shift ;;
        -) INPUT="/dev/stdin"; shift ;;
        *)
            if [ -z "$INPUT" ]; then
                INPUT="$1"
            elif [ -z "$INPUT2" ]; then
                INPUT2="$1"
            fi
            shift ;;
    esac
done

# Validate input
if [ -z "$INPUT" ]; then
    error "No input provided. Usage: analyze-call.sh <transcript_file> [command]"
fi

if [ "$INPUT" != "/dev/stdin" ] && [ ! -e "$INPUT" ]; then
    error "Input not found: $INPUT"
fi

if [ "$COMMAND" = "compare" ] && [ -z "$INPUT2" ]; then
    error "Compare requires two transcript files. Usage: analyze-call.sh <file1> compare <file2>"
fi

if [ "$COMMAND" = "patterns" ] && [ ! -d "$INPUT" ]; then
    error "Patterns command requires a directory of transcripts. Got: $INPUT"
fi

# Detect transcript format
detect_format() {
    local file="$1"
    local first_lines
    first_lines=$(head -5 "$file" 2>/dev/null || echo "")

    if echo "$first_lines" | grep -q "WEBVTT"; then
        echo "vtt"
    elif echo "$first_lines" | grep -q "^[0-9]*$" && echo "$first_lines" | grep -q " --> "; then
        echo "srt"
    elif echo "$first_lines" | grep -q '"segments"'; then
        echo "json"
    else
        echo "plain"
    fi
}

# Normalize transcript to plain text with speaker labels
normalize_transcript() {
    local file="$1"
    local fmt
    fmt=$(detect_format "$file")

    case "$fmt" in
        vtt)
            # Strip VTT headers and timestamps, keep speaker tags
            sed -E '/^WEBVTT/d; /^$/d; /^[0-9]{2}:[0-9]{2}/d; /^NOTE/d; s/<v ([^>]+)>/\1: /g; s/<\/v>//g' "$file"
            ;;
        srt)
            # Strip SRT numbers and timestamps
            sed -E '/^[0-9]+$/d; /^$/d; /[0-9]{2}:[0-9]{2}.*-->/d' "$file"
            ;;
        json)
            # Extract text from JSON segments
            if command -v jq &>/dev/null; then
                jq -r '.segments[] | "\(.speaker // "Speaker"): \(.text)"' "$file"
            else
                # Fallback: basic extraction
                grep -oP '"text"\s*:\s*"[^"]*"' "$file" | sed 's/"text"\s*:\s*"//;s/"$//'
            fi
            ;;
        plain)
            cat "$file"
            ;;
    esac
}

# Calculate basic stats
calc_stats() {
    local transcript="$1"
    local total_words rep_words prospect_words

    total_words=$(echo "$transcript" | wc -w)
    rep_words=$(echo "$transcript" | grep -iE "^(rep|sales|agent|seller|me):" | sed 's/^[^:]*://' | wc -w || echo 0)
    prospect_words=$(echo "$transcript" | grep -iE "^(prospect|client|customer|buyer|them):" | sed 's/^[^:]*://' | wc -w || echo 0)

    # If no speaker labels detected, estimate 50/50
    if [ "$rep_words" -eq 0 ] && [ "$prospect_words" -eq 0 ]; then
        rep_words=$((total_words / 2))
        prospect_words=$((total_words / 2))
    fi

    local rep_pct=0 prospect_pct=0
    if [ "$total_words" -gt 0 ]; then
        rep_pct=$((rep_words * 100 / total_words))
        prospect_pct=$((prospect_words * 100 / total_words))
    fi

    echo "TOTAL_WORDS=$total_words"
    echo "REP_WORDS=$rep_words"
    echo "PROSPECT_WORDS=$prospect_words"
    echo "REP_PCT=$rep_pct"
    echo "PROSPECT_PCT=$prospect_pct"
}

# Build the prompt based on command
build_prompt() {
    local command="$1"
    local transcript="$2"
    local stats="$3"
    local vertical_ctx=""

    if [ "$VERTICAL" != "auto" ]; then
        vertical_ctx="The rep sells in the $VERTICAL vertical. Weight methodology scoring accordingly."
    fi

    case "$command" in
        analyze)
            cat <<PROMPT
You are a sales call intelligence analyst. Analyze this sales call transcript using the full 8-dimension framework.

$vertical_ctx

Pre-calculated stats:
$stats

TRANSCRIPT:
---
$transcript
---

Produce a CALL INTELLIGENCE REPORT with:
1. Summary (3 lines max)
2. Verdict: WIN PROBABILITY [X%] | DEAL HEALTH [GREEN/YELLOW/RED]
3. Key Numbers: Talk Ratio, Objections found/handled, Buying Signals found/caught, Methodology Scores (SPIN/Challenger/MEDDIC/Sandler 0-100), Golden Moments count
4. Detailed analysis of all 8 dimensions:
   - Objection Mapping (type, surface vs root, rep response score, optimal response)
   - Buying Signal Detection (verbal/engagement signals, CAUGHT/MISSED/PARTIALLY CAUGHT)
   - Talk-to-Listen Ratio (by phase if timestamps available)
   - Emotional Arc (phase-by-phase energy mapping)
   - Golden Moments (exact quotes that moved the deal, with replicability rating)
   - Methodology Scorecard (SPIN, Challenger, MEDDIC, Sandler — each 0-100 with evidence)
   - 3 Drill Recommendations (scenario, prospect line, good/great response)
   - Battle Cards (for each objection encountered)
5. Action Items (3 prioritized, specific enough to execute tomorrow)
6. "If You Could Redo This Call" (2-3 sentences, written to the rep)

Be specific. Use quotes from the transcript. No corporate jargon. Score honestly — a mediocre call is a C, not a B+.
PROMPT
            ;;
        quick)
            cat <<PROMPT
You are a sales call intelligence analyst. Give a 60-second rapid assessment.

$vertical_ctx

Pre-calculated stats:
$stats

TRANSCRIPT:
---
$transcript
---

Output EXACTLY this format:
QUICK SCORE: [A/B/C/D/F]
TALK RATIO: [X% rep / Y% prospect]
ENERGY: [One-line emotional arc description]
#1 WIN: [Best thing the rep did — specific, with quote if possible]
#1 FIX: [Most critical improvement — specific, actionable]
VERDICT: [One sentence assessment]

Be direct. No fluff. Honest grade.
PROMPT
            ;;
        battlecard)
            cat <<PROMPT
You are a sales objection specialist. Extract every objection from this transcript and generate battle cards.

$vertical_ctx

TRANSCRIPT:
---
$transcript
---

For each objection found, output:

OBJECTION: "[Exact quote or close paraphrase]"
FREQUENCY: [Estimate: Common / Occasional / Rare]
SURFACE MEANING: [What they said]
ROOT CAUSE: [What they actually mean]
RESPONSE FRAMEWORK:
  1. Acknowledge: [Validate without agreeing]
  2. Isolate: [Confirm this is the real issue]
  3. Reframe: [Shift perspective]
  4. Evidence: [Proof point or story]
  5. Advance: [Move to next step]
EXAMPLE RESPONSE: "[Full scripted response]"
AVOID: "[Common mistakes]"

---

Then add: OBJECTION SUMMARY — total count, types breakdown, handling success rate.
PROMPT
            ;;
        coach)
            cat <<PROMPT
You are a senior sales manager doing a 1:1 coaching session with a rep. You've just reviewed their call.

$vertical_ctx

Pre-calculated stats:
$stats

TRANSCRIPT:
---
$transcript
---

Write a coaching report:
1. Start with what they did well (specific examples with quotes)
2. Identify the 2-3 biggest improvement areas with evidence from the call
3. For each improvement area: what happened, why it matters, what to do instead, and a practice exercise
4. Rate their methodology execution (SPIN/Challenger/MEDDIC/Sandler)
5. End with a 2-week development plan (specific daily/weekly actions)

Tone: direct, constructive, like a manager who cares about their growth. Not harsh, not soft. Specific.
PROMPT
            ;;
        drill)
            cat <<PROMPT
You are a sales training coach. Based on this call transcript, generate 5 practice drills targeting the rep's weaknesses.

$vertical_ctx

TRANSCRIPT:
---
$transcript
---

For each drill:

DRILL: [Name]
TARGETS: [Specific weakness from the call]
SETUP: [Scenario description — industry, prospect role, situation]
PROSPECT OPENS WITH: "[The challenging line they'll face]"
GOOD RESPONSE (6/10): "[Acceptable but not great]"
GREAT RESPONSE (9/10): "[What a top closer would say]"
WHY IT WORKS: [1 sentence on the technique]
PRACTICE TIP: [How to rehearse this]

Make drills progressively harder. Drill 1 = foundational. Drill 5 = advanced.
PROMPT
            ;;
        compare)
            local transcript2
            transcript2=$(normalize_transcript "$INPUT2")
            cat <<PROMPT
You are a sales call intelligence analyst. Compare these two calls side-by-side.

$vertical_ctx

CALL 1:
---
$transcript
---

CALL 2:
---
$transcript2
---

Produce a comparison report:
1. Quick scores for both calls (A-F)
2. Side-by-side dimension comparison (table format)
3. What IMPROVED between calls
4. What REGRESSED between calls
5. What stayed CONSISTENT (strengths and weaknesses)
6. Net assessment: is the rep getting better?
7. Priority focus for the next call
PROMPT
            ;;
        patterns)
            # Collect all transcripts from directory
            local all_transcripts=""
            local count=0
            for f in "$INPUT"/*; do
                if [ -f "$f" ]; then
                    count=$((count + 1))
                    local norm
                    norm=$(normalize_transcript "$f")
                    all_transcripts="${all_transcripts}

=== CALL $count: $(basename "$f") ===
$norm"
                fi
            done

            if [ "$count" -lt 5 ]; then
                error "Pattern analysis requires at least 5 transcripts. Found: $count in $INPUT"
            fi

            cat <<PROMPT
You are a sales pattern analyst. Analyze these $count sales calls and identify cross-call patterns.

$vertical_ctx

$all_transcripts

Produce a PATTERN INTELLIGENCE report:
1. Win/Loss Correlation (traits of good vs bad calls)
2. Objection Frequency Map (ranked, with handling success rate)
3. Talk Ratio Trends (getting better or worse?)
4. Rep Strengths (consistent across calls — lean into these)
5. Rep Weaknesses (consistent across calls — drill these)
6. Emotional Arc Patterns (when does the rep lose/gain momentum?)
7. Golden Moments Library (best lines across all calls, reusable)
8. Recommended Training Plan (prioritized, specific)
9. Predicted Impact: If the rep fixes the #1 weakness, estimated close rate improvement

Be data-driven. Reference specific calls by number. Quantify wherever possible.
PROMPT
            ;;
    esac
}

# Execute analysis
run_analysis() {
    local transcript stats prompt

    if [ "$COMMAND" = "patterns" ]; then
        # Patterns handles its own transcript loading
        stats="(multi-call analysis — stats per call in prompt)"
        transcript=""
        prompt=$(build_prompt "$COMMAND" "$transcript" "$stats")
    else
        if [ "$INPUT" = "/dev/stdin" ]; then
            transcript=$(cat)
        else
            transcript=$(normalize_transcript "$INPUT")
        fi

        if [ -z "$transcript" ]; then
            error "Transcript is empty"
        fi

        stats=$(calc_stats "$transcript")
        prompt=$(build_prompt "$COMMAND" "$transcript" "$stats")
    fi

    log "Running $COMMAND analysis..."
    log "Model: $MODEL"
    log "Format: $FORMAT"

    local result

    # Try OpenClaw first, fall back to direct API calls
    if command -v openclaw &>/dev/null; then
        log "Using OpenClaw..."
        result=$(echo "$prompt" | openclaw run --skill "$SKILL_NAME" --command "$COMMAND" 2>/dev/null || true)
    fi

    # If OpenClaw didn't work, try ollama
    if [ -z "$result" ] && command -v ollama &>/dev/null; then
        log "Using Ollama (local)..."
        result=$(echo "$prompt" | ollama run "${MODEL:-qwen2.5:3b}" 2>/dev/null || true)
    fi

    # If nothing worked, output the prompt for piping
    if [ -z "$result" ]; then
        log "No LLM available. Outputting prompt for manual use."
        log "Pipe this to your preferred LLM:"
        echo "$prompt"
        return
    fi

    # Output
    if [ -n "$OUTPUT" ]; then
        echo "$result" > "$OUTPUT"
        log "Report written to: $OUTPUT"
    else
        echo "$result"
    fi
}

# Main
log "Sales Call Intelligence v$VERSION"
log "Command: $COMMAND"
log "Input: $INPUT"

run_analysis
