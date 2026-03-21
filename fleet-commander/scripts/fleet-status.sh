#!/usr/bin/env bash
# fleet-status.sh — Fleet Commander Health Dashboard
# Enhanced version with agent registry, task tracking, and performance scoring
# Usage: fleet-status.sh [--full | --agents | --tasks | --costs]

set -uo pipefail

# ── Config ────────────────────────────────────────────────────────────────────
FLEET_DIR="${FLEET_DIR:-/mnt/c/Users/PLATINUM/KOINO/systems/fleet}"
REGISTRY_DIR="$FLEET_DIR/registry"
TASK_DIR="$FLEET_DIR/tasks"
MEMORY_DIR="$FLEET_DIR/shared-memory"
LOG_DIR="$FLEET_DIR/logs"
SCORE_DIR="$FLEET_DIR/scores"

SSH_TIMEOUT=5
SSH_OPTS_PW="-o ConnectTimeout=$SSH_TIMEOUT -o StrictHostKeyChecking=no -o PreferredAuthentications=password -o PubkeyAuthentication=no"

# Machine definitions
declare -A MACHINES=(
  [omni]="localhost"
  [bmo]="192.168.1.98"
  [oci]="192.168.1.92"
  [sailorsbot1]="192.168.1.99"
)
declare -A ROLES=(
  [omni]="CEO / Commander"
  [bmo]="Specialist (Bryson)"
  [oci]="Workhorse / C-Suite"
  [sailorsbot1]="Client Ops / RepFlow"
)

# ── Colors ────────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GRN='\033[0;32m'; YLW='\033[1;33m'
BLU='\033[0;34m'; CYN='\033[0;36m'; WHT='\033[1;37m'
MAG='\033[0;35m'; RST='\033[0m'
BOLD='\033[1m'

NOW=$(date '+%Y-%m-%d %H:%M:%S')

# ── Helpers ───────────────────────────────────────────────────────────────────
header() {
  echo ""
  echo -e "${BLU}════════════════════════════════════════════════════════${RST}"
  echo -e "${WHT}  $1${RST}"
  echo -e "${BLU}════════════════════════════════════════════════════════${RST}"
}

status_line() {
  local label="$1" value="$2" color="${3:-$WHT}"
  printf "  ${CYN}%-24s${RST} ${color}%s${RST}\n" "$label" "$value"
}

ok()   { echo -e "  ${GRN}[OK]${RST} $*"; }
warn() { echo -e "  ${YLW}[WARN]${RST} $*"; }
fail() { echo -e "  ${RED}[FAIL]${RST} $*"; }
info() { echo -e "  ${CYN}[INFO]${RST} $*"; }

separator() { echo -e "  ${BLU}────────────────────────────────────────────${RST}"; }

# ── Machine Check ─────────────────────────────────────────────────────────────
check_machine() {
  local name="$1"
  local host="${MACHINES[$name]}"
  local role="${ROLES[$name]}"
  local status="OFFLINE"
  local uptime_str="--"
  local load_str="--"
  local disk_str="--"

  if [[ "$name" == "omni" ]]; then
    status="ONLINE"
    uptime_str=$(uptime -p 2>/dev/null || uptime | awk '{print $3,$4}')
    load_str=$(uptime | awk -F'load average:' '{print $2}' | xargs)
    disk_str=$(df -h /mnt/c 2>/dev/null | awk 'NR==2{print $5}' || echo "--")
  else
    if ping -c1 -W2 "$host" &>/dev/null 2>&1; then
      status="ONLINE"
      # Try to get basic info via SSH (best effort)
      local remote_info
      remote_info=$(timeout 10 sshpass -p "$(get_pass $name)" ssh $SSH_OPTS_PW "$(get_user $name)@$host" \
        'echo "UP:$(uptime -p 2>/dev/null || uptime | awk "{print \$3,\$4}")";echo "LOAD:$(uptime | awk -F"load average:" "{print \$2}" | xargs)";echo "DISK:$(df -h / | awk "NR==2{print \$5}")"' 2>/dev/null) || true

      if [[ -n "$remote_info" ]]; then
        uptime_str=$(echo "$remote_info" | grep "^UP:" | cut -d: -f2-)
        load_str=$(echo "$remote_info" | grep "^LOAD:" | cut -d: -f2-)
        disk_str=$(echo "$remote_info" | grep "^DISK:" | cut -d: -f2-)
      fi
    fi
  fi

  # Display
  local status_color="$RED"
  [[ "$status" == "ONLINE" ]] && status_color="$GRN"

  printf "  ${status_color}%-3s${RST} ${WHT}%-14s${RST} ${CYN}%-26s${RST} " \
    "$( [[ "$status" == "ONLINE" ]] && echo "[+]" || echo "[-]" )" \
    "$name" "$role"
  printf "${status_color}%-8s${RST} " "$status"
  printf "load:${WHT}%-16s${RST} disk:${WHT}%s${RST}\n" "$load_str" "$disk_str"
}

get_user() {
  case "$1" in
    bmo) echo "operator" ;;
    oci) echo "macmini" ;;
    sailorsbot1) echo "sailorsbot1" ;;
  esac
}

get_pass() {
  case "$1" in
    bmo) echo "    " ;;
    oci) echo "fengxue8" ;;
    sailorsbot1) echo '061#01Cs!' ;;
  esac
}

# ── Agent Registry ────────────────────────────────────────────────────────────
show_agents() {
  header "Agent Registry"

  if [[ ! -d "$REGISTRY_DIR" ]] || [[ -z "$(ls -A "$REGISTRY_DIR" 2>/dev/null)" ]]; then
    info "No agents registered yet. Registry: $REGISTRY_DIR"
    info "Create agent cards as JSON files in the registry directory."
    return
  fi

  printf "  ${BOLD}%-22s %-10s %-18s %-10s %-8s${RST}\n" "AGENT ID" "MACHINE" "TOP CAPABILITY" "SCORE" "STATUS"
  separator

  for card in "$REGISTRY_DIR"/*.json; do
    [[ -f "$card" ]] || continue
    local aid machine top_cap score status
    aid=$(jq -r '.agent_id // "unknown"' "$card" 2>/dev/null)
    machine=$(jq -r '.machine // "?"' "$card" 2>/dev/null)
    top_cap=$(jq -r '[.specialties | to_entries[] | {key, value}] | sort_by(-.value) | .[0].key // "none"' "$card" 2>/dev/null)
    score=$(jq -r '[.specialties | to_entries[] | .value] | max // 0' "$card" 2>/dev/null)
    status=$(jq -r '.status // "unknown"' "$card" 2>/dev/null)

    local sc="${WHT}"
    [[ "$status" == "online" ]] && sc="$GRN"
    [[ "$status" == "offline" ]] && sc="$RED"
    [[ "$status" == "suspect" ]] && sc="$YLW"

    printf "  %-22s %-10s %-18s %-10s ${sc}%-8s${RST}\n" "$aid" "$machine" "$top_cap" "$score" "$status"
  done
}

# ── Task Summary ──────────────────────────────────────────────────────────────
show_tasks() {
  header "Active Tasks"

  if [[ ! -d "$TASK_DIR" ]] || [[ -z "$(ls -A "$TASK_DIR" 2>/dev/null)" ]]; then
    info "No tasks tracked. Task directory: $TASK_DIR"
    return
  fi

  local active=0 completed=0 failed=0 total=0
  for task_file in "$TASK_DIR"/*.json; do
    [[ -f "$task_file" ]] || continue
    total=$((total + 1))
    local s
    s=$(jq -r '.status // "unknown"' "$task_file" 2>/dev/null)
    case "$s" in
      active|in_progress) active=$((active + 1)) ;;
      complete) completed=$((completed + 1)) ;;
      failed) failed=$((failed + 1)) ;;
    esac
  done

  status_line "Total tasks" "$total"
  status_line "Active" "$active" "$YLW"
  status_line "Completed" "$completed" "$GRN"
  status_line "Failed" "$failed" "$RED"
}

# ── Cost Summary ──────────────────────────────────────────────────────────────
show_costs() {
  header "Cost Summary (Current Period)"

  local total_tokens=0
  local total_cost="0.00"

  if [[ -d "$TASK_DIR" ]]; then
    for task_file in "$TASK_DIR"/*.json; do
      [[ -f "$task_file" ]] || continue
      local tokens
      tokens=$(jq -r '.tokens_used // 0' "$task_file" 2>/dev/null)
      total_tokens=$((total_tokens + tokens))
    done
  fi

  status_line "Total tokens used" "$total_tokens"
  status_line "Estimated cost" "\$${total_cost} (local models = free)"
  status_line "Budget policy" "Local Ollama first, Claude Code for complex only"
}

# ── Main ──────────────────────────────────────────────────────────────────────
MODE="${1:---full}"

echo ""
echo -e "${WHT}${BOLD}+----------------------------------------------------------+${RST}"
echo -e "${WHT}${BOLD}|         FLEET COMMANDER — STATUS DASHBOARD                |${RST}"
echo -e "${WHT}${BOLD}|         KOINO Capital | $NOW            |${RST}"
echo -e "${WHT}${BOLD}+----------------------------------------------------------+${RST}"

# Always show machine status
header "Fleet Machines"
printf "  ${BOLD}%-3s %-14s %-26s %-8s %-16s %s${RST}\n" "" "MACHINE" "ROLE" "STATUS" "LOAD" "DISK"
separator

for machine in omni bmo oci sailorsbot1; do
  check_machine "$machine"
done

case "$MODE" in
  --full)
    show_agents
    show_tasks
    show_costs
    ;;
  --agents)
    show_agents
    ;;
  --tasks)
    show_tasks
    ;;
  --costs)
    show_costs
    ;;
esac

# ── Footer ────────────────────────────────────────────────────────────────────
echo ""
separator
echo -e "  ${CYN}Commands:${RST}"
echo -e "    fleet-status.sh --full     Full dashboard"
echo -e "    fleet-status.sh --agents   Agent registry only"
echo -e "    fleet-status.sh --tasks    Task summary only"
echo -e "    fleet-status.sh --costs    Cost report only"
echo ""

# Log
mkdir -p "$LOG_DIR"
{
  echo "=== Fleet Commander Status: $NOW ==="
  for m in omni bmo oci sailorsbot1; do
    host="${MACHINES[$m]}"
    if [[ "$m" == "omni" ]] || ping -c1 -W2 "$host" &>/dev/null 2>&1; then
      echo "$m: ONLINE"
    else
      echo "$m: OFFLINE"
    fi
  done
} >> "$LOG_DIR/fleet-$(date +%Y%m%d).log" 2>/dev/null || true
