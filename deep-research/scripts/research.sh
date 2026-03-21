#!/usr/bin/env bash
# deep-research — KOINO Capital Research Engine
# Usage: research <mode> "<topic>" [--depth quick|standard|exhaustive] [--format report|brief|raw|csv]
#
# Modes: market, technical, people, trend, risk, alpha
# Examples:
#   research market "AI video editing SaaS"
#   research alpha "undervalued Shopify app niches" --depth exhaustive
#   research people "Alex Hormozi" --depth standard
#   research risk "launching fintech without MTL" --depth quick

set -euo pipefail

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
REPORTS_DIR="${KOINO_HOME:-/mnt/c/Users/PLATINUM/KOINO}/research-reports"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# Defaults
MODE=""
TOPIC=""
DEPTH="standard"
FORMAT="report"

usage() {
    echo -e "${BOLD}KOINO Deep Research Engine${NC}"
    echo ""
    echo -e "Usage: ${CYAN}research <mode> \"<topic>\" [options]${NC}"
    echo ""
    echo -e "${BOLD}Modes:${NC}"
    echo -e "  ${GREEN}market${NC}     Competitive landscape, pricing, TAM, positioning"
    echo -e "  ${GREEN}technical${NC}  Architecture, APIs, benchmarks, tradeoffs"
    echo -e "  ${GREEN}people${NC}     Background, track record, incentives, network"
    echo -e "  ${GREEN}trend${NC}      Emergence, adoption curves, inflection points"
    echo -e "  ${GREEN}risk${NC}       Threat modeling, scenario planning, vulnerabilities"
    echo -e "  ${GREEN}alpha${NC}      Information asymmetries, non-obvious insights"
    echo ""
    echo -e "${BOLD}Options:${NC}"
    echo -e "  --depth    ${YELLOW}quick${NC} (2-5m) | ${YELLOW}standard${NC} (10-20m) | ${YELLOW}exhaustive${NC} (30-60m)"
    echo -e "  --format   ${YELLOW}report${NC} | ${YELLOW}brief${NC} | ${YELLOW}raw${NC} | ${YELLOW}csv${NC}"
    echo ""
    echo -e "${BOLD}Examples:${NC}"
    echo "  research market \"AI video editing SaaS for agencies\""
    echo "  research alpha \"undervalued Shopify app niches\" --depth exhaustive"
    echo "  research people \"Alex Hormozi\" --depth standard"
    exit 0
}

# Parse args
[[ $# -lt 2 ]] && usage

MODE="$1"
TOPIC="$2"
shift 2

while [[ $# -gt 0 ]]; do
    case "$1" in
        --depth) DEPTH="$2"; shift 2 ;;
        --format) FORMAT="$2"; shift 2 ;;
        -h|--help) usage ;;
        *) echo -e "${RED}Unknown option: $1${NC}"; usage ;;
    esac
done

# Validate mode
case "$MODE" in
    market|technical|people|trend|risk|alpha) ;;
    *) echo -e "${RED}Invalid mode: $MODE. Use: market, technical, people, trend, risk, alpha${NC}"; exit 1 ;;
esac

# Validate depth
case "$DEPTH" in
    quick|standard|exhaustive) ;;
    *) echo -e "${RED}Invalid depth: $DEPTH. Use: quick, standard, exhaustive${NC}"; exit 1 ;;
esac

# Create reports directory
mkdir -p "$REPORTS_DIR"

# Slugify topic for filename
SLUG=$(echo "$TOPIC" | tr '[:upper:]' '[:lower:]' | tr -cs '[:alnum:]' '-' | sed 's/^-//;s/-$//')
REPORT_FILE="${REPORTS_DIR}/${TIMESTAMP}-${MODE}-${SLUG}.md"

echo -e "${BOLD}${CYAN}======================================${NC}"
echo -e "${BOLD}  KOINO Deep Research Engine${NC}"
echo -e "${CYAN}======================================${NC}"
echo ""
echo -e "  ${BOLD}Topic:${NC}  $TOPIC"
echo -e "  ${BOLD}Mode:${NC}   $MODE"
echo -e "  ${BOLD}Depth:${NC}  $DEPTH"
echo -e "  ${BOLD}Output:${NC} $REPORT_FILE"
echo ""

# Depth-based source targets
case "$DEPTH" in
    quick)      SOURCE_TARGET=5;  TIME_EST="2-5 minutes" ;;
    standard)   SOURCE_TARGET=15; TIME_EST="10-20 minutes" ;;
    exhaustive) SOURCE_TARGET=30; TIME_EST="30-60 minutes" ;;
esac

echo -e "${YELLOW}Target: ${SOURCE_TARGET} sources | Est. time: ${TIME_EST}${NC}"
echo ""

# Mode-specific research prompts
case "$MODE" in
    market)
        MODE_INSTRUCTIONS="Focus on: competitive landscape, pricing models, market size (TAM/SAM/SOM), positioning, go-to-market strategies, customer pain points, distribution channels, barriers to entry. Use both bottom-up and top-down market sizing. Check G2, Reddit, HN for real user sentiment."
        ;;
    technical)
        MODE_INSTRUCTIONS="Focus on: architecture patterns, API design, performance benchmarks (independent only), GitHub activity, migration stories, failure modes at scale, security advisories, dependency chains, documentation quality vs real-world experience."
        ;;
    people)
        MODE_INSTRUCTIONS="Focus on: career history, public statements over time, network/connections, board seats, investments, legal/regulatory history, incentive structure, what others say candidly. Stick to publicly available information only."
        ;;
    trend)
        MODE_INSTRUCTIONS="Focus on: timeline of emergence, adoption data (users, revenue, search volume, job postings), S-curve position, historical analogies, enabling technologies, accelerators/blockers, contrarian views, second-order effects."
        ;;
    risk)
        MODE_INSTRUCTIONS="Focus on: threat enumeration (technical, market, legal, operational, reputational), likelihood/impact/detection scoring, scenario matrix (best/base/worst/black swan), leading indicators, historical precedents, risk interdependencies, mitigation strategies."
        ;;
    alpha)
        MODE_INSTRUCTIONS="Focus on: consensus documentation, cracks in consensus, under-examined public information, structural advantages/disadvantages, insider signals (hiring, patents, domains), inversion analysis, time horizon mismatches. Mark findings [ALPHA - DO NOT DISTRIBUTE]."
        ;;
esac

# Build the research prompt for the AI agent
RESEARCH_PROMPT="You are executing KOINO Capital's Deep Research protocol.

TOPIC: ${TOPIC}
MODE: ${MODE} research
DEPTH: ${DEPTH} (target ${SOURCE_TARGET} sources)

MODE-SPECIFIC INSTRUCTIONS:
${MODE_INSTRUCTIONS}

PROTOCOL:
1. SCOPE: Restate the question. List 5-10 sub-questions. Define what 'done' looks like.
2. WIDE SWEEP: Search the topic, adjacent terms, critics, primary data, absences, temporal changes.
3. SOURCE EVALUATION: Score every source on CRAAP (Currency, Relevance, Authority, Accuracy, Purpose). Minimum 15/25 to include.
4. TRIANGULATION: Map consensus, conflict, silence. Extract contrarian signals. Build temporal map.
5. NETWORK ANALYSIS: Key players, incentives, connections, power dynamics.
6. SYNTHESIS: Apply convergence mapping, tension mapping, absence analysis, incentive mapping, and so-what extraction.
7. REPORT: Use the standard KOINO report template with all sections.

QUALITY GATES:
- Every claim has a citation
- Every finding has a confidence score [HIGH/MEDIUM/LOW/SPECULATIVE]
- Contrarian analysis is substantive
- Blind spots section is honest
- Action items are specific with priority and effort
- No single source dominates

OUTPUT FORMAT: ${FORMAT}

Execute now."

# If Claude Code or an AI agent is available, pass the prompt
# Otherwise, create a template report for manual completion
if command -v claude &>/dev/null; then
    echo -e "${GREEN}Dispatching to Claude Code...${NC}"
    echo "$RESEARCH_PROMPT" | claude --skill deep-research > "$REPORT_FILE" 2>/dev/null || {
        echo -e "${YELLOW}Claude dispatch failed. Creating template for manual research.${NC}"
        # Fall through to template creation
    }
fi

# If report wasn't created by AI, create template
if [[ ! -s "$REPORT_FILE" ]]; then
    cat > "$REPORT_FILE" << TEMPLATE
# ${TOPIC} — Deep Research Report
**Date**: $(date +%Y-%m-%d)
**Mode**: ${MODE}
**Depth**: ${DEPTH}
**Analyst**: KOINO Capital Deep Research Engine
**Confidence**: [PENDING]

## Research Plan
**Core question**: ${TOPIC}

### Sub-questions to answer:
1.
2.
3.
4.
5.

### Source categories to check:
- [ ] Academic / peer-reviewed
- [ ] Industry reports / analyst coverage
- [ ] News / investigative journalism
- [ ] Primary documents / filings
- [ ] Community / social (Reddit, HN, forums)
- [ ] Financial data / filings
- [ ] Alternative data (job postings, patents, domains)

---

## Executive Summary
[3-5 sentences. The answer.]

## Key Findings
1. [Finding] [CONFIDENCE] (Source, Date)
2.
3.
4.
5.

## Evidence Map
| Finding | Supporting Sources | Contradicting Sources | Confidence |
|---------|-------------------|----------------------|------------|
|         |                   |                      |            |

## Contrarian Analysis
[What does the minority view say? Why might consensus be wrong?]

## Temporal Analysis
[How has this evolved? Trajectory? Inflection points?]

## Network Map
[Key players, incentives, connections]

## Blind Spots & Unknowns
[What we couldn't find. What should exist but doesn't.]

## So What (Implications)
[What does this mean?]

## Now What (Action Items)
| Priority | Action | Effort | Expected Value |
|----------|--------|--------|----------------|
| P0       |        |        |                |
| P1       |        |        |                |
| P2       |        |        |                |

## Source Evaluation
| Source | Type | Authority | Recency | Score |
|--------|------|-----------|---------|-------|
|        |      |           |         |  /25  |

## Methodology Notes
Research protocol: KOINO Deep Research v1.0
Mode: ${MODE} | Depth: ${DEPTH}
Mode instructions: ${MODE_INSTRUCTIONS}
TEMPLATE

    echo -e "${GREEN}Research template created: ${REPORT_FILE}${NC}"
fi

echo ""
echo -e "${BOLD}${GREEN}Research initialized.${NC}"
echo -e "Report: ${CYAN}${REPORT_FILE}${NC}"
echo ""
echo -e "${YELLOW}To execute with AI:${NC}"
echo -e "  claude \"$(cat "${SKILL_DIR}/SKILL.md" | head -5 | tail -1)\" < ${REPORT_FILE}"
echo ""
