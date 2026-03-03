#!/usr/bin/env bash
set -u

EMULATOR_NAME="Pixel_8_API_34_PlayStore_arm64-v8a"
MAX_WAIT_SEC=300
POLL_SEC=5
DEVICE_TIMEOUT=120
WORKDIR="/Users/jaebinchoi/Desktop/VibeMental"
cd "$WORKDIR" || { echo "[ERROR] Cannot cd to $WORKDIR"; exit 1; }

TS="$(date +%Y%m%d_%H%M%S)"
LOG="$WORKDIR/emulator_flutter_flow_${TS}.log"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG"
}

find_emulator_bin() {
  if command -v emulator >/dev/null 2>&1; then
    command -v emulator
    return 0
  fi

  local candidates=()
  [[ -n "${ANDROID_SDK_ROOT:-}" ]] && candidates+=("$ANDROID_SDK_ROOT/emulator/emulator")
  [[ -n "${ANDROID_HOME:-}" ]] && candidates+=("$ANDROID_HOME/emulator/emulator")
  candidates+=("$HOME/Library/Android/sdk/emulator/emulator")

  local c
  for c in "${candidates[@]}"; do
    if [[ -x "$c" ]]; then
      echo "$c"
      return 0
    fi
  done
  return 1
}

extract_emulator_id() {
  local devices_out="$1"
  echo "$devices_out" | sed -nE 's/^[[:space:]]*(emulator-[0-9]+)[[:space:]].*/\1/p' | head -n1
}

log "Starting flow. Log file: $LOG"

if ! command -v flutter >/dev/null 2>&1; then
  log "[ERROR] Flutter CLI ('flutter') not found in PATH."
  exit 1
fi

EMU_BIN="$(find_emulator_bin || true)"
if [[ -z "$EMU_BIN" ]]; then
  log "[ERROR] Android emulator CLI not found (checked PATH, ANDROID_SDK_ROOT, ANDROID_HOME, ~/Library/Android/sdk)."
  exit 1
fi

log "Step 1/4: Launching emulator '$EMULATOR_NAME' with '$EMU_BIN'"
("$EMU_BIN" -avd "$EMULATOR_NAME" >>"$LOG" 2>&1) &
EMU_PID=$!
log "Emulator launch command started (pid=$EMU_PID)."

log "Step 2/4: Polling 'flutter devices' for emulator id (timeout=${MAX_WAIT_SEC}s)"
START_TS=$(date +%s)
DEVICE_ID=""

while true; do
  NOW_TS=$(date +%s)
  ELAPSED=$((NOW_TS - START_TS))
  if (( ELAPSED >= MAX_WAIT_SEC )); then
    log "[ERROR] Timed out after ${MAX_WAIT_SEC}s waiting for an emulator-* device."
    break
  fi

  DEVICES_OUT="$(flutter devices 2>&1)"
  echo "$DEVICES_OUT" >> "$LOG"
  DEVICE_ID="$(extract_emulator_id "$DEVICES_OUT")"

  if [[ -n "$DEVICE_ID" ]]; then
    log "Found emulator device id: $DEVICE_ID"
    break
  fi

  log "No emulator-* device yet (elapsed=${ELAPSED}s). Retrying in ${POLL_SEC}s..."
  sleep "$POLL_SEC"
done

if [[ -z "$DEVICE_ID" ]]; then
  log "Step 4/4: FAILURE"
  log "Key lines:"
  grep -E "\[ERROR\]|Found emulator device id|No emulator-\* device yet|Timed out" "$LOG" | tail -n 20
  exit 1
fi

log "Step 3/4: Running Flutter app on '$DEVICE_ID'"
RUN_OUT="$WORKDIR/flutter_run_${TS}.log"
set +e
flutter run -d "$DEVICE_ID" --no-resident --device-timeout "$DEVICE_TIMEOUT" >"$RUN_OUT" 2>&1
RUN_CODE=$?
set -e

log "flutter run exit code: $RUN_CODE"
log "Appending flutter run output to main log"
cat "$RUN_OUT" >> "$LOG"

log "Step 4/4: Reporting result"
if [[ $RUN_CODE -eq 0 ]]; then
  log "SUCCESS: flutter run completed successfully."
  log "Key lines:"
  grep -E "Found emulator device id|Launching lib/main.dart|Running Gradle task|Built |Installing build|Syncing files|Application finished|SUCCESS" "$LOG" | tail -n 30
  exit 0
else
  log "FAILURE: flutter run failed with exit code $RUN_CODE."
  log "Key lines:"
  grep -E "Found emulator device id|Error|Exception|FAILURE|Could not|failed|exit code" "$LOG" | tail -n 40
  exit "$RUN_CODE"
fi
