#!/bin/bash
# Reputation Engine Lite -- Review Response Generator
# Usage: ./respond.sh "review text" "positive|negative|neutral" "industry"

set -euo pipefail

REVIEW="${1:?Usage: respond.sh 'review text' 'positive|negative|neutral' 'industry'}"
SENTIMENT="${2:?Missing sentiment}"
INDUSTRY="${3:?Missing industry}"

case "$SENTIMENT" in
    positive) FRAMEWORK="AMPLIFY: Thank > Mirror > Personalize > Invite > Sign" ;;
    negative) FRAMEWORK="HEARD: Hear > Empathize > Apologize > Resolve > Direct offline" ;;
    neutral)  FRAMEWORK="BRIDGE: Thank > Acknowledge > Inquire > Demonstrate > Open door" ;;
    *)        FRAMEWORK="HEARD"; echo "Unknown sentiment, defaulting to HEARD" ;;
esac

PROMPT="Generate a review response for a ${INDUSTRY} business.

REVIEW: ${REVIEW}
SENTIMENT: ${SENTIMENT}
FRAMEWORK: ${FRAMEWORK}

Rules: Under 120 words. Reference specific details. Never defensive. Sign with [Owner Name].
Output ONLY the response text."

if command -v ollama &>/dev/null; then
    echo "$PROMPT" | ollama run qwen2.5:3b
else
    echo "ERROR: No LLM backend. Install ollama."
    exit 1
fi
