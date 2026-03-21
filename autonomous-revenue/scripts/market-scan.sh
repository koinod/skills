#!/usr/bin/env bash
# market-scan.sh — Autonomous market gap detection
# Usage: ./market-scan.sh [--vertical devtools|smb|creator|freelance] [--output /path/to/output.json]
#
# Scans Reddit, Google Trends proxy, and Gumroad for unmet market needs.
# Outputs scored gaps to JSON for product ideation.

set -euo pipefail

VERTICAL="${1:---vertical}"
OUTPUT_DIR="/tmp/autonomous-revenue"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
GAPS_FILE="$OUTPUT_DIR/gaps.json"
RAW_DIR="$OUTPUT_DIR/raw"
LOG_FILE="$OUTPUT_DIR/scan.log"

# Parse args
while [[ $# -gt 0 ]]; do
    case $1 in
        --vertical) VERTICAL="$2"; shift 2;;
        --output) GAPS_FILE="$2"; shift 2;;
        *) shift;;
    esac
done

mkdir -p "$OUTPUT_DIR" "$RAW_DIR"

log() {
    echo "[$(date -u +"%H:%M:%S")] $1" | tee -a "$LOG_FILE"
}

log "=== Market Scan Started ==="
log "Vertical: $VERTICAL"
log "Output: $GAPS_FILE"

# --- Reddit Scan ---
scan_reddit() {
    local subreddit="$1"
    local query="$2"
    local outfile="$RAW_DIR/reddit_${subreddit}_$(echo "$query" | tr ' ' '_').json"

    log "Scanning r/$subreddit for: $query"

    # Reddit JSON API (no auth needed for public subreddits)
    curl -s -A "autonomous-revenue-scanner/1.0" \
        "https://www.reddit.com/r/${subreddit}/search.json?q=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")&sort=relevance&t=month&limit=25" \
        -o "$outfile" 2>/dev/null || true

    if [[ -f "$outfile" ]] && command -v jq &>/dev/null; then
        local count
        count=$(jq '.data.children | length' "$outfile" 2>/dev/null || echo "0")
        log "  Found $count results in r/$subreddit"

        # Extract signals: title, score, num_comments, url
        jq -r '.data.children[] | select(.data.score > 3) | {
            source: "reddit",
            subreddit: .data.subreddit,
            title: .data.title,
            score: .data.score,
            comments: .data.num_comments,
            url: ("https://reddit.com" + .data.permalink),
            created: .data.created_utc
        }' "$outfile" 2>/dev/null >> "$RAW_DIR/signals.jsonl" || true
    fi

    # Rate limit: Reddit allows ~60 req/min without auth
    sleep 1
}

# --- Gumroad Competition Check ---
scan_gumroad() {
    local query="$1"
    local outfile="$RAW_DIR/gumroad_$(echo "$query" | tr ' ' '_').html"

    log "Checking Gumroad competition for: $query"

    curl -s -A "Mozilla/5.0" \
        "https://gumroad.com/discover?query=$(python3 -c "import urllib.parse; print(urllib.parse.quote('$query'))")" \
        -o "$outfile" 2>/dev/null || true

    if [[ -f "$outfile" ]]; then
        # Count product results (rough estimate from HTML)
        local count
        count=$(grep -c 'product-card' "$outfile" 2>/dev/null || echo "0")
        log "  Gumroad results for '$query': ~$count products"
        echo "{\"source\":\"gumroad\",\"query\":\"$query\",\"competition_count\":$count,\"timestamp\":\"$TIMESTAMP\"}" >> "$RAW_DIR/competition.jsonl"
    fi

    sleep 1
}

# --- Define search queries by vertical ---
declare -a SUBREDDITS
declare -a QUERIES

case "$VERTICAL" in
    devtools)
        SUBREDDITS=("webdev" "node" "python" "selfhosted" "devops")
        QUERIES=("looking for a template" "tired of manually" "starter kit" "boilerplate" "anyone know a tool for")
        GUMROAD_QUERIES=("developer template" "coding starter kit" "API integration guide" "devops checklist")
        ;;
    smb)
        SUBREDDITS=("smallbusiness" "entrepreneur" "bookkeeping")
        QUERIES=("how do you handle" "spreadsheet for tracking" "template for" "automate" "SOP")
        GUMROAD_QUERIES=("small business template" "business checklist" "operations SOP" "client management")
        ;;
    creator)
        SUBREDDITS=("content_marketing" "socialmedia" "videography")
        QUERIES=("takes me hours" "content calendar" "repurpose" "workflow for" "batch create")
        GUMROAD_QUERIES=("content template" "social media planner" "content calendar" "creator toolkit")
        ;;
    freelance)
        SUBREDDITS=("freelance" "graphic_design" "copywriting")
        QUERIES=("client management" "proposal template" "pricing" "invoice" "onboarding process")
        GUMROAD_QUERIES=("freelancer template" "client proposal" "freelance toolkit" "invoice template")
        ;;
    *)
        # Default: broad scan
        SUBREDDITS=("smallbusiness" "entrepreneur" "webdev" "freelance" "automation")
        QUERIES=("I wish there was" "looking for a template" "anyone know a tool" "tired of manually")
        GUMROAD_QUERIES=("automation template" "AI tool" "business template" "starter kit")
        ;;
esac

# Clear previous signals
> "$RAW_DIR/signals.jsonl" 2>/dev/null || true
> "$RAW_DIR/competition.jsonl" 2>/dev/null || true

# --- Execute scans ---
log "--- Reddit Scan ---"
for sub in "${SUBREDDITS[@]}"; do
    for query in "${QUERIES[@]}"; do
        scan_reddit "$sub" "$query"
    done
done

log "--- Competition Scan ---"
for gq in "${GUMROAD_QUERIES[@]}"; do
    scan_gumroad "$gq"
done

# --- Score and rank gaps ---
log "--- Scoring Gaps ---"

SIGNAL_COUNT=$(wc -l < "$RAW_DIR/signals.jsonl" 2>/dev/null || echo "0")
log "Total signals collected: $SIGNAL_COUNT"

# Generate gap report
python3 << 'PYTHON_SCORE' || log "Python scoring failed — raw signals still available"
import json
import sys
from collections import Counter
from datetime import datetime

signals = []
try:
    with open("/tmp/autonomous-revenue/raw/signals.jsonl") as f:
        for line in f:
            line = line.strip()
            if line:
                try:
                    signals.append(json.loads(line))
                except json.JSONDecodeError:
                    continue
except FileNotFoundError:
    print("No signals file found")
    sys.exit(0)

competition = []
try:
    with open("/tmp/autonomous-revenue/raw/competition.jsonl") as f:
        for line in f:
            line = line.strip()
            if line:
                try:
                    competition.append(json.loads(line))
                except json.JSONDecodeError:
                    continue
except FileNotFoundError:
    pass

# Group signals by theme (simple keyword clustering)
themes = Counter()
for s in signals:
    title = s.get("title", "").lower()
    for keyword in ["template", "automate", "tool", "workflow", "checklist", "integration", "api", "script", "dashboard"]:
        if keyword in title:
            themes[keyword] += 1

# Build gap report
comp_map = {c["query"]: c["competition_count"] for c in competition}

gaps = []
for theme, count in themes.most_common(10):
    comp_count = 0
    for q, c in comp_map.items():
        if theme in q.lower():
            comp_count = max(comp_count, c)

    # Simple scoring
    demand_score = min(count * 2, 10)  # More signals = higher demand
    supply_score = max(10 - comp_count, 0)  # Less competition = higher opportunity
    total = demand_score + supply_score

    gaps.append({
        "theme": theme,
        "signal_count": count,
        "competition": comp_count,
        "demand_score": demand_score,
        "supply_score": supply_score,
        "total_score": total,
        "top_signals": [s["title"] for s in signals if theme in s.get("title", "").lower()][:3]
    })

gaps.sort(key=lambda x: x["total_score"], reverse=True)

report = {
    "generated": datetime.utcnow().isoformat() + "Z",
    "total_signals": len(signals),
    "themes_detected": len(themes),
    "gaps": gaps[:10]
}

with open("/tmp/autonomous-revenue/gaps.json", "w") as f:
    json.dump(report, f, indent=2)

print(f"Gap report written: {len(gaps)} gaps scored")
for g in gaps[:5]:
    print(f"  [{g['total_score']:2d}] {g['theme']} ({g['signal_count']} signals, {g['competition']} competitors)")
PYTHON_SCORE

log "=== Market Scan Complete ==="
log "Results: $GAPS_FILE"
log "Raw signals: $RAW_DIR/signals.jsonl"

echo ""
echo "=== TOP GAPS ==="
if command -v jq &>/dev/null && [[ -f "$GAPS_FILE" ]]; then
    jq -r '.gaps[:5][] | "[\(.total_score)] \(.theme) — \(.signal_count) signals, \(.competition) competitors"' "$GAPS_FILE" 2>/dev/null || echo "See $GAPS_FILE"
else
    echo "See $GAPS_FILE"
fi
