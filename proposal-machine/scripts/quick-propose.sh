#!/bin/bash
# Proposal Machine Lite -- Quick Proposal Generator
# Usage: ./quick-propose.sh "Client Name" "industry" "budget"

set -euo pipefail

CLIENT="${1:?Usage: quick-propose.sh 'Client' 'industry' 'budget'}"
INDUSTRY="${2:?Missing industry}"
BUDGET="${3:?Missing budget range}"

PROMPT="Generate a 1-page proposal outline:

CLIENT: ${CLIENT}
INDUSTRY: ${INDUSTRY}
BUDGET: ${BUDGET}
DATE: $(date +%Y-%m-%d)

Include:
1. Executive Summary (3 sentences: pain, transformation, urgency)
2. Scope of Work (deliverable table)
3. Investment (3 tiers: Good at 70% budget, Better at 100% [RECOMMENDED], Best at 250%)
4. Next Steps (CTA, valid 14 days)

Keep it concise. Use specific numbers. Say 'investment' not 'cost'."

if command -v ollama &>/dev/null; then
    echo "$PROMPT" | ollama run qwen2.5:3b
else
    echo "ERROR: No LLM backend available. Install ollama."
    exit 1
fi
