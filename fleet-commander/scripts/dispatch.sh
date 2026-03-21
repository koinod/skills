#!/usr/bin/env bash
# dispatch.sh — Fleet Commander Task Dispatch Engine
# Enhanced dispatch with pattern support, retry logic, and cost tracking
#
# Usage:
#   dispatch.sh <machine|all> "<command>"                    # Simple dispatch
#   dispatch.sh --pattern scatter "<command>" bmo,oci        # Scatter to multiple
#   dispatch.sh --pattern pipeline "<cmd1>" bmo "<cmd2>" oci # Sequential pipeline
#   dispatch.sh --task <task.json>                           # Dispatch from task file

set -uo pipefail

FLEET_DIR="${FLEET_DIR:-/mnt/c/Users/PLATINUM/KOINO/systems/fleet}"
DISPATCH_LOG="$FLEET_DIR/logs/dispatch.log"
TASK_DIR="$FLEET_DIR/tasks"

RED='\033[0;31m'; GRN='\033[0;32m'; YLW='\033[1;33m'
CYN='\033[0;36m'; WHT='\033[1;37m'; MAG='\033[0;35m'; RST='\033[0m'
BOLD='\033[1m'

SSH_TIMEOUT=10
SSH_OPTS_PW="-o ConnectTimeout=$SSH_TIMEOUT -o StrictHostKeyChecking=no -o PreferredAuthentications=password -o PubkeyAuthentication=no"

MAX_RETRIES=2
RETRY_DELAY=5

NOW=$(date '+%Y-%m-%d %H:%M:%S')
TASK_ID="task-$(date +%Y%m%d)-$(head -c 4 /dev/urandom | xxd -p)"

mkdir -p "$FLEET_DIR/logs" "$TASK_DIR"

# ── Machine Credentials ──────────────────────────────────────────────────────
get_ssh_cmd() {
  local machine="$1" cmd="$2"
  case "$machine" in
    omni)
      echo "eval '$cmd'"
      ;;
    bmo)
      echo "sshpass -p '    ' ssh $SSH_OPTS_PW operator@192.168.1.98 '$cmd'"
      ;;
    oci)
      echo "sshpass -p 'fengxue8' ssh $SSH_OPTS_PW macmini@192.168.1.92 '$cmd'"
      ;;
    sailorsbot1)
      echo "sshpass -p '061#01Cs!' ssh $SSH_OPTS_PW sailorsbot1@192.168.1.99 '$cmd'"
      ;;
    *)
      echo ""
      ;;
  esac
}

# ── Core Dispatch ─────────────────────────────────────────────────────────────
dispatch_to() {
  local machine="$1"
  local cmd="$2"
  local attempt=0
  local output rc

  while [ $attempt -le $MAX_RETRIES ]; do
    attempt=$((attempt + 1))

    if [ $attempt -gt 1 ]; then
      echo -e "  ${YLW}Retry $attempt/$((MAX_RETRIES+1))...${RST}"
      sleep $RETRY_DELAY
    fi

    local start_time=$(date +%s%N)

    if [[ "$machine" == "omni" ]]; then
      output=$(eval "$cmd" 2>&1)
      rc=$?
    else
      local ssh_cmd
      ssh_cmd=$(get_ssh_cmd "$machine" "$cmd")
      if [[ -z "$ssh_cmd" ]]; then
        echo -e "  ${RED}Unknown machine: $machine${RST}"
        return 1
      fi
      output=$(eval "$ssh_cmd" 2>&1)
      rc=$?
    fi

    local end_time=$(date +%s%N)
    local duration_ms=$(( (end_time - start_time) / 1000000 ))

    if [ $rc -eq 0 ]; then
      echo -e "  ${GRN}[OK]${RST} ${machine} (${duration_ms}ms)"
      log_entry "OK" "$machine" "$cmd" "$duration_ms"
      if [ -n "$output" ]; then
        echo "$output" | head -50
        local lines
        lines=$(echo "$output" | wc -l)
        if [ "$lines" -gt 50 ]; then
          echo -e "  ${YLW}... ($((lines - 50)) more lines truncated)${RST}"
        fi
      fi
      return 0
    fi

    if [ $attempt -le $MAX_RETRIES ]; then
      echo -e "  ${YLW}[FAIL rc=$rc]${RST} ${machine} — retrying..."
    fi
  done

  echo -e "  ${RED}[FAIL rc=$rc]${RST} ${machine} — all retries exhausted"
  log_entry "FAIL($rc)" "$machine" "$cmd" "0"
  if [ -n "$output" ]; then
    echo -e "  ${RED}Error:${RST} $(echo "$output" | head -5)"
  fi
  return $rc
}

log_entry() {
  local status="$1" machine="$2" cmd="$3" duration="$4"
  echo "[$NOW] [$TASK_ID] $status | $machine | ${duration}ms | $cmd" >> "$DISPATCH_LOG" 2>/dev/null || true
}

# ── Pattern: Scatter ──────────────────────────────────────────────────────────
pattern_scatter() {
  local cmd="$1"
  shift
  local machines_csv="$1"

  echo -e "\n${MAG}${BOLD}SCATTER${RST} — Dispatching to: ${WHT}${machines_csv}${RST}"
  echo -e "Command: ${CYN}${cmd}${RST}\n"

  IFS=',' read -ra TARGETS <<< "$machines_csv"

  local pids=()
  local tmpdir
  tmpdir=$(mktemp -d)

  for machine in "${TARGETS[@]}"; do
    machine=$(echo "$machine" | xargs)  # trim whitespace
    (
      dispatch_to "$machine" "$cmd" > "$tmpdir/$machine.out" 2>&1
      echo $? > "$tmpdir/$machine.rc"
    ) &
    pids+=($!)
  done

  # Wait for all
  for pid in "${pids[@]}"; do
    wait "$pid" 2>/dev/null || true
  done

  # Display results
  local success=0 fail=0
  for machine in "${TARGETS[@]}"; do
    machine=$(echo "$machine" | xargs)
    echo -e "\n${WHT}── $machine ──${RST}"
    cat "$tmpdir/$machine.out" 2>/dev/null
    local rc
    rc=$(cat "$tmpdir/$machine.rc" 2>/dev/null || echo 1)
    if [ "$rc" -eq 0 ]; then
      success=$((success + 1))
    else
      fail=$((fail + 1))
    fi
  done

  rm -rf "$tmpdir"

  echo -e "\n${WHT}Scatter complete:${RST} ${GRN}${success} ok${RST}, ${RED}${fail} failed${RST}"
}

# ── Pattern: Pipeline ─────────────────────────────────────────────────────────
pattern_pipeline() {
  # Args: cmd1 machine1 cmd2 machine2 ...
  echo -e "\n${MAG}${BOLD}PIPELINE${RST} — Sequential execution"

  local stage=1
  local prev_output=""

  while [ $# -ge 2 ]; do
    local cmd="$1"
    local machine="$2"
    shift 2

    # Inject previous output as PIPELINE_INPUT env var
    if [ -n "$prev_output" ]; then
      cmd="export PIPELINE_INPUT='$(echo "$prev_output" | head -20 | sed "s/'/'\\\\''/g")'; $cmd"
    fi

    echo -e "\n${WHT}Stage $stage:${RST} ${CYN}$cmd${RST} → ${WHT}$machine${RST}"

    local tmpfile
    tmpfile=$(mktemp)
    dispatch_to "$machine" "$cmd" > "$tmpfile" 2>&1
    local rc=$?

    cat "$tmpfile"

    if [ $rc -ne 0 ]; then
      echo -e "\n${RED}Pipeline FAILED at stage $stage${RST}"
      rm -f "$tmpfile"
      return $rc
    fi

    prev_output=$(cat "$tmpfile")
    rm -f "$tmpfile"
    stage=$((stage + 1))
  done

  echo -e "\n${GRN}Pipeline complete:${RST} $((stage - 1)) stages executed"
}

# ── Usage ─────────────────────────────────────────────────────────────────────
usage() {
  echo -e "${WHT}${BOLD}Fleet Commander Dispatch${RST}"
  echo ""
  echo -e "  ${CYN}dispatch.sh <machine> \"<command>\"${RST}"
  echo -e "  ${CYN}dispatch.sh all \"<command>\"${RST}"
  echo -e "  ${CYN}dispatch.sh --pattern scatter \"<command>\" bmo,oci${RST}"
  echo -e "  ${CYN}dispatch.sh --pattern pipeline \"<cmd1>\" bmo \"<cmd2>\" oci${RST}"
  echo ""
  echo "  Machines: omni, bmo, oci, sailorsbot1, all"
  echo "  Patterns: scatter, pipeline"
  echo ""
  echo "  Options:"
  echo "    --retries N    Max retry attempts (default: $MAX_RETRIES)"
  echo "    --timeout N    SSH timeout seconds (default: $SSH_TIMEOUT)"
  exit 1
}

# ── Argument Parsing ──────────────────────────────────────────────────────────
[ $# -lt 1 ] && usage

# Parse options
while [[ "${1:-}" == --* ]]; do
  case "$1" in
    --pattern)
      PATTERN="$2"
      shift 2
      case "$PATTERN" in
        scatter)
          [ $# -lt 2 ] && { echo "scatter needs: \"<command>\" machine1,machine2"; exit 1; }
          CMD="$1"
          MACHINES_CSV="$2"
          shift 2
          echo -e "\n${WHT}${BOLD}KOINO Fleet Commander${RST} — $NOW"
          echo -e "Task ID: ${CYN}$TASK_ID${RST}"
          pattern_scatter "$CMD" "$MACHINES_CSV"
          exit $?
          ;;
        pipeline)
          echo -e "\n${WHT}${BOLD}KOINO Fleet Commander${RST} — $NOW"
          echo -e "Task ID: ${CYN}$TASK_ID${RST}"
          pattern_pipeline "$@"
          exit $?
          ;;
        *)
          echo "Unknown pattern: $PATTERN (use: scatter, pipeline)"
          exit 1
          ;;
      esac
      ;;
    --retries)
      MAX_RETRIES="$2"
      shift 2
      ;;
    --timeout)
      SSH_TIMEOUT="$2"
      SSH_OPTS_PW="-o ConnectTimeout=$SSH_TIMEOUT -o StrictHostKeyChecking=no -o PreferredAuthentications=password -o PubkeyAuthentication=no"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      usage
      ;;
  esac
done

# Simple dispatch mode
[ $# -lt 2 ] && usage

TARGET="$1"
CMD="$2"

echo -e "\n${WHT}${BOLD}KOINO Fleet Commander${RST} — $NOW"
echo -e "Task ID: ${CYN}$TASK_ID${RST}"
echo -e "Command: ${YLW}$CMD${RST}\n"

if [ "$TARGET" = "all" ]; then
  for machine in omni bmo oci sailorsbot1; do
    echo -e "${WHT}── $machine ──${RST}"
    dispatch_to "$machine" "$CMD" || true
    echo ""
  done
else
  dispatch_to "$TARGET" "$CMD"
fi
