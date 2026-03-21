#!/usr/bin/env bash
# Objection Destroyer - Practice Drill Mode
# Usage: ./drill.sh [reps] [difficulty] [industry]
#   reps: number of rounds (default: 10)
#   difficulty: rookie|closer|destroyer (default: closer)
#   industry: saas|insurance|d2d|realestate|agency|mixed (default: mixed)

set -euo pipefail

REPS="${1:-10}"
DIFFICULTY="${2:-closer}"
INDUSTRY="${3:-mixed}"
SCORE_TOTAL=0
ROUND=0
LOG_FILE="${LOG_FILE:-/tmp/skills/objection-destroyer/drill-log-$(date +%Y%m%d-%H%M%S).csv}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

# Objection banks per industry
declare -a SAAS_OBJECTIONS=(
  "We're happy with our current solution.|COMPETITION|driver"
  "It's too expensive for what it does.|PRICE|analytical"
  "I need to talk to my engineering team.|AUTHORITY|analytical"
  "We tried something like this and it failed.|TRUST|amiable"
  "We'll look at this next quarter.|TIMING|driver"
  "I don't see how this is different from Salesforce.|COMPETITION|analytical"
  "Our CEO won't approve new vendors right now.|AUTHORITY|amiable"
  "Can you just send me a deck?|TIMING|driver"
  "We built something in-house that works fine.|COMPETITION|analytical"
  "What if it doesn't integrate with our stack?|TRUST|analytical"
  "We're in the middle of a reorg.|TIMING|amiable"
  "I've never heard of your company.|TRUST|analytical"
  "We don't have the bandwidth to onboard.|TIMING|driver"
  "My team won't adopt another tool.|NEED|amiable"
  "Your reviews on G2 aren't great.|TRUST|analytical"
)

declare -a INSURANCE_OBJECTIONS=(
  "I already have coverage through work.|COMPETITION|driver"
  "I'm too young to worry about this.|NEED|expressive"
  "Insurance is a scam.|TRUST|expressive"
  "I need to talk to my wife first.|AUTHORITY|amiable"
  "I can't afford the monthly premium.|PRICE|amiable"
  "Let me think about it and get back to you.|TIMING|amiable"
  "I don't trust insurance companies.|TRUST|driver"
  "My buddy sells insurance, I'll go with him.|COMPETITION|expressive"
  "I'm healthy, I don't need life insurance.|NEED|driver"
  "What if I never use it?|NEED|analytical"
  "The deductible is way too high.|PRICE|analytical"
  "I just bought a policy last month.|TIMING|driver"
  "I'll just do it online, it's cheaper.|COMPETITION|analytical"
  "I don't understand all the fine print.|TRUST|amiable"
  "I've had agents lie to me before.|TRUST|expressive"
)

declare -a D2D_OBJECTIONS=(
  "I'm not interested.|NEED|driver"
  "I'm busy right now.|TIMING|driver"
  "I don't buy from door-to-door salespeople.|TRUST|driver"
  "Leave me your card.|TIMING|amiable"
  "How do I know this is legit?|TRUST|analytical"
  "I already have a provider.|COMPETITION|driver"
  "I'm renting, talk to my landlord.|AUTHORITY|amiable"
  "I can't afford it.|PRICE|amiable"
  "My neighbor said it was a scam.|TRUST|expressive"
  "I need to talk to my husband.|AUTHORITY|amiable"
  "We just signed a 2-year contract.|COMPETITION|driver"
  "I don't make decisions at the door.|TIMING|driver"
  "Just email me the info.|TIMING|driver"
  "The HOA won't allow it.|AUTHORITY|analytical"
  "I've heard bad things about your company.|TRUST|expressive"
)

declare -a REALESTATE_OBJECTIONS=(
  "The price is too high.|PRICE|analytical"
  "I want to wait for the market to drop.|TIMING|analytical"
  "I need to sell my house first.|TIMING|amiable"
  "I'm just browsing.|NEED|amiable"
  "My partner isn't sold on this one.|AUTHORITY|amiable"
  "Your commission is too high.|PRICE|driver"
  "I can find homes on Zillow myself.|COMPETITION|driver"
  "I had a bad experience with my last agent.|TRUST|expressive"
  "Interest rates are way too high.|TIMING|analytical"
  "Another agent offered a lower rate.|COMPETITION|analytical"
  "I want to do FSBO.|COMPETITION|driver"
  "The inspection report concerns me.|TRUST|analytical"
  "I'm waiting for more inventory.|TIMING|analytical"
  "This house needs too much work.|NEED|analytical"
  "I don't want to be locked into a listing agreement.|TRUST|driver"
)

declare -a AGENCY_OBJECTIONS=(
  "That's way too expensive for us.|PRICE|driver"
  "We can do this in-house.|COMPETITION|driver"
  "I've been burned by agencies before.|TRUST|expressive"
  "I don't see the ROI.|NEED|analytical"
  "We're not ready for this yet.|TIMING|amiable"
  "What makes you different from every other agency?|COMPETITION|driver"
  "We just hired a marketing person.|COMPETITION|amiable"
  "Our industry is different.|NEED|driver"
  "Can you guarantee results?|TRUST|analytical"
  "Send me a proposal and I'll review it.|TIMING|driver"
  "We need month-to-month, not a contract.|TRUST|driver"
  "We need to see results in 30 days.|TRUST|driver"
  "I got a cheaper quote from another agency.|COMPETITION|analytical"
  "We've already allocated our budget.|PRICE|driver"
  "Marketing doesn't work for our business.|NEED|expressive"
)

get_random_objection() {
  local ind="$INDUSTRY"
  if [[ "$ind" == "mixed" ]]; then
    local industries=("saas" "insurance" "d2d" "realestate" "agency")
    ind="${industries[$((RANDOM % ${#industries[@]}))]}"
  fi

  local -n arr
  case "$ind" in
    saas) arr=SAAS_OBJECTIONS ;;
    insurance) arr=INSURANCE_OBJECTIONS ;;
    d2d) arr=D2D_OBJECTIONS ;;
    realestate) arr=REALESTATE_OBJECTIONS ;;
    agency) arr=AGENCY_OBJECTIONS ;;
  esac

  local entry="${arr[$((RANDOM % ${#arr[@]}))]}"
  IFS='|' read -r OBJECTION OBJ_TYPE BUYER_TONE <<< "$entry"
  CURRENT_INDUSTRY="$ind"
}

add_difficulty_layer() {
  case "$DIFFICULTY" in
    rookie)
      echo -e "${BLUE}HINT: This is a ${OBJ_TYPE} objection from a ${BUYER_TONE} buyer.${NC}"
      ;;
    closer)
      echo -e "${BLUE}HINT: ${BUYER_TONE} buyer style.${NC}"
      ;;
    destroyer)
      # No hints
      ;;
  esac
}

score_round() {
  local response="$1"
  echo ""
  echo -e "${BOLD}--- SCORING ---${NC}"
  echo -e "Objection Type: ${YELLOW}${OBJ_TYPE}${NC}"
  echo -e "Buyer Tone: ${YELLOW}${BUYER_TONE}${NC}"
  echo -e "Industry: ${YELLOW}${CURRENT_INDUSTRY}${NC}"
  echo ""

  # Self-scoring
  echo -e "${BOLD}Rate yourself (1-5) on each dimension:${NC}"

  local total=0
  local dimensions=("Classification" "Framework Selection" "Tone Match" "Response Quality" "Follow-Up")
  local weights=(15 20 15 20 10)

  for i in "${!dimensions[@]}"; do
    read -rp "  ${dimensions[$i]} (1-5): " score
    score="${score:-3}"
    if [[ "$score" -lt 1 || "$score" -gt 5 ]]; then score=3; fi
    total=$((total + score * weights[i]))
  done

  local weighted_avg=$(echo "scale=2; $total / 80" | bc 2>/dev/null || echo "3.0")
  echo ""

  if (( $(echo "$weighted_avg >= 4.5" | bc -l 2>/dev/null || echo 0) )); then
    echo -e "${GREEN}${BOLD}DESTROYER${NC} -- Score: ${weighted_avg}/5.0"
  elif (( $(echo "$weighted_avg >= 3.5" | bc -l 2>/dev/null || echo 0) )); then
    echo -e "${YELLOW}${BOLD}CLOSER${NC} -- Score: ${weighted_avg}/5.0"
  elif (( $(echo "$weighted_avg >= 2.5" | bc -l 2>/dev/null || echo 0) )); then
    echo -e "${BLUE}${BOLD}DEVELOPING${NC} -- Score: ${weighted_avg}/5.0"
  else
    echo -e "${RED}${BOLD}ROOKIE${NC} -- Score: ${weighted_avg}/5.0"
  fi

  # Log to CSV
  echo "$(date +%Y-%m-%d %H:%M),${CURRENT_INDUSTRY},\"${OBJECTION}\",${OBJ_TYPE},${BUYER_TONE},${weighted_avg}" >> "$LOG_FILE"

  SCORE_TOTAL=$(echo "$SCORE_TOTAL + $weighted_avg" | bc 2>/dev/null || echo "$SCORE_TOTAL")
}

# --- Main ---
echo ""
echo -e "${BOLD}========================================${NC}"
echo -e "${RED}${BOLD}   OBJECTION DESTROYER - DRILL MODE${NC}"
echo -e "${BOLD}========================================${NC}"
echo -e "  Reps: ${REPS} | Difficulty: ${DIFFICULTY} | Industry: ${INDUSTRY}"
echo -e "  Log: ${LOG_FILE}"
echo -e "${BOLD}========================================${NC}"
echo ""
echo "Rules:"
echo "  1. Read the scenario"
echo "  2. Classify the objection type"
echo "  3. Pick a framework"
echo "  4. Deliver your response OUT LOUD (type it when done)"
echo "  5. Self-score"
echo ""
read -rp "Press ENTER to begin..."

# Header for log
if [[ ! -f "$LOG_FILE" ]]; then
  echo "date,industry,objection,type,tone,score" > "$LOG_FILE"
fi

for ((i=1; i<=REPS; i++)); do
  ROUND=$i
  echo ""
  echo -e "${BOLD}--- ROUND ${i}/${REPS} ---${NC}"
  get_random_objection
  echo ""
  echo -e "${BOLD}INDUSTRY:${NC} ${CURRENT_INDUSTRY^^}"
  echo -e "${BOLD}PROSPECT SAYS:${NC}"
  echo -e "  ${RED}\"${OBJECTION}\"${NC}"
  echo ""
  add_difficulty_layer
  echo ""

  START_TIME=$(date +%s)
  read -rp "Your response (speak it aloud, then type summary): " user_response
  END_TIME=$(date +%s)
  ELAPSED=$((END_TIME - START_TIME))

  echo -e "\nResponse time: ${ELAPSED}s"
  if [[ $ELAPSED -lt 5 ]]; then
    echo -e "${GREEN}Lightning fast.${NC}"
  elif [[ $ELAPSED -lt 15 ]]; then
    echo -e "${YELLOW}Good speed.${NC}"
  else
    echo -e "${RED}Too slow. In a live call, you lost momentum.${NC}"
  fi

  score_round "$user_response"
done

# Summary
echo ""
echo -e "${BOLD}========================================${NC}"
echo -e "${BOLD}   SESSION COMPLETE${NC}"
echo -e "${BOLD}========================================${NC}"
AVG=$(echo "scale=2; $SCORE_TOTAL / $REPS" | bc 2>/dev/null || echo "N/A")
echo -e "  Rounds: ${REPS}"
echo -e "  Average Score: ${AVG}/5.0"
echo -e "  Log saved: ${LOG_FILE}"
echo ""

if [[ "$AVG" != "N/A" ]]; then
  if (( $(echo "$AVG >= 4.5" | bc -l 2>/dev/null || echo 0) )); then
    echo -e "${GREEN}${BOLD}  VERDICT: DESTROYER. You're ready for war.${NC}"
  elif (( $(echo "$AVG >= 3.5" | bc -l 2>/dev/null || echo 0) )); then
    echo -e "${YELLOW}${BOLD}  VERDICT: CLOSER. Sharpen the weak spots.${NC}"
  elif (( $(echo "$AVG >= 2.5" | bc -l 2>/dev/null || echo 0) )); then
    echo -e "${BLUE}${BOLD}  VERDICT: DEVELOPING. Run 10 more reps tomorrow.${NC}"
  else
    echo -e "${RED}${BOLD}  VERDICT: ROOKIE. Drill daily until you hit 3.5+.${NC}"
  fi
fi

echo ""
