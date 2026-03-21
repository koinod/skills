#!/usr/bin/env bash
# KOINO Capital — Client Acquisition: Outreach Sequence Generator
# Usage: ./outreach.sh "Prospect Name" "Company" "pain_point" [channel: email|linkedin|dm|all]
# Requires: ollama running with qwen2.5:3b (or set OLLAMA_MODEL)

set -euo pipefail

PROSPECT="${1:?Usage: outreach.sh \"Name\" \"Company\" \"pain_point\" [email|linkedin|dm|all]}"
COMPANY="${2:?Provide company name as second argument}"
PAIN="${3:?Provide pain point as third argument}"
CHANNEL="${4:-all}"
MODEL="${OLLAMA_MODEL:-qwen2.5:3b}"
OLLAMA_URL="${OLLAMA_URL:-http://localhost:11434}"
OUTPUT_DIR="${OUTREACH_DIR:-/tmp/outreach}"
YOUR_NAME="${SENDER_NAME:-[Your Name]}"
YOUR_COMPANY="${SENDER_COMPANY:-[Your Company]}"

mkdir -p "$OUTPUT_DIR"

TIMESTAMP=$(date +%Y%m%d-%H%M%S)
SLUG="$(echo "$PROSPECT-$COMPANY" | tr ' ' '-' | tr '[:upper:]' '[:lower:]')"
OUTFILE="$OUTPUT_DIR/$SLUG-$TIMESTAMP.md"

echo "====================================="
echo "  OUTREACH SEQUENCE GENERATOR"
echo "  Prospect: $PROSPECT @ $COMPANY"
echo "  Pain: $PAIN"
echo "  Channel: $CHANNEL"
echo "====================================="
echo ""

# Check ollama
if ! curl -sf "$OLLAMA_URL/api/tags" > /dev/null 2>&1; then
    echo "ERROR: Ollama not running at $OLLAMA_URL"
    exit 1
fi

# Channel-specific prompts
case "$CHANNEL" in
    email)
        CHANNEL_INSTRUCTIONS="Generate a 4-email cold email sequence:
- Day 0: Observation opener (4-6 lines, no links, no HTML, subject line 4-7 words)
- Day 3: Follow-up with new angle + social proof
- Day 7: Case study or relevant result
- Day 14: Breakup email (respectful close)
Each email must be plain text, under 100 words, with one clear CTA."
        ;;
    linkedin)
        CHANNEL_INSTRUCTIONS="Generate a LinkedIn outreach sequence:
- Connection request note (under 280 characters, reference their content, NO pitch)
- DM #1 after acceptance: genuine question about their challenge
- DM #2 (3-5 days later if they respond): share a relevant insight
- DM #3 (only if warm): suggest a call
Also suggest 2-3 of their posts to comment on before connecting (describe the type of post)."
        ;;
    dm)
        CHANNEL_INSTRUCTIONS="Generate a Twitter/Instagram DM approach:
- One DM only (max 3 sentences)
- Reference a specific type of post they'd have
- Ask a question, don't pitch
- If no response, do NOT follow up on this channel"
        ;;
    all)
        CHANNEL_INSTRUCTIONS="Generate a multi-channel sequence over 14 days:

WEEK 1:
- Day 1: LinkedIn — engage with 2 of their posts (comment, not like)
- Day 3: LinkedIn — send connection request (280 chars, reference their content)
- Day 4: Email #1 — observation opener (4-6 lines, plain text, no links)

WEEK 2:
- Day 7: Email #2 — follow-up with new angle + social proof
- Day 8: LinkedIn DM (if connected) — genuine question about their challenge
- Day 10: Email #3 — case study relevant to their industry
- Day 14: Email #4 — breakup email

Rules:
- All emails: plain text, under 100 words, 4-7 word subject lines
- LinkedIn connection request: under 280 chars, no pitch
- LinkedIn DMs: conversational, reference their content
- Never pitch in first touch on any channel"
        ;;
    *)
        echo "ERROR: Channel must be email, linkedin, dm, or all"
        exit 1
        ;;
esac

PROMPT="You are an elite cold outreach copywriter. Write outreach for:

Prospect: $PROSPECT
Company: $COMPANY
Their likely pain: $PAIN
Sender: $YOUR_NAME at $YOUR_COMPANY

$CHANNEL_INSTRUCTIONS

RULES:
- Never use: 'I hope this finds you well', 'leverage', 'synergy', 'unlock', 'game-changer', 'revolutionary'
- Never use AI-detectable email patterns
- Every message must deliver standalone value (insight, observation, or resource)
- Sound like a real human who did their homework, not a sales robot
- Be specific to their company and pain point
- Short sentences. Active voice. No filler.

Format each message clearly with labels (Subject, Body) and day numbers."

echo "Generating $CHANNEL outreach sequence via $MODEL..."
echo ""

RESPONSE=$(curl -sf "$OLLAMA_URL/api/generate" \
    -d "$(jq -n --arg model "$MODEL" --arg prompt "$PROMPT" \
        '{model: $model, prompt: $prompt, stream: false}')" \
    | jq -r '.response // "ERROR: No response from model"')

{
    echo "# Outreach Sequence: $PROSPECT @ $COMPANY"
    echo "**Generated:** $(date '+%Y-%m-%d %H:%M')"
    echo "**Channel:** $CHANNEL"
    echo "**Pain Point:** $PAIN"
    echo "**Sender:** $YOUR_NAME @ $YOUR_COMPANY"
    echo ""
    echo "---"
    echo ""
    echo "$RESPONSE"
    echo ""
    echo "---"
    echo ""
    echo "## Pre-Send Checklist"
    echo "- [ ] Verified prospect email (ZeroBounce/NeverBounce)"
    echo "- [ ] Checked LinkedIn profile is active (posted in last 30 days)"
    echo "- [ ] Confirmed decision-maker or influencer role"
    echo "- [ ] Personalization hooks verified (not hallucinated)"
    echo "- [ ] Sending inbox warmed (14+ days)"
    echo "- [ ] SPF/DKIM/DMARC configured on sending domain"
    echo "- [ ] Daily send volume under 50/inbox"
    echo ""
    echo "*Generated by KOINO Capital client-acquisition skill*"
} | tee "$OUTFILE"

echo ""
echo "====================================="
echo "Saved to: $OUTFILE"
echo "====================================="
