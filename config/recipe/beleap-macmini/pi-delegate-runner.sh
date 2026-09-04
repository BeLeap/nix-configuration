#!/bin/sh
set -eu

STATE_DIR="@stateDir@"
HOME_DIR="@homeDir@"
PI_BIN="@piBin@"
COREUTILS="@coreutils@/bin"

CAT="$COREUTILS/cat"
HEAD="$COREUTILS/head"
MKDIR="$COREUTILS/mkdir"
MV="$COREUTILS/mv"
SLEEP="$COREUTILS/sleep"
TAIL="$COREUTILS/tail"
TIMEOUT="$COREUTILS/timeout"
TR="$COREUTILS/tr"
WC="$COREUTILS/wc"

TASK_FILE="$STATE_DIR/task.md"
CWD_FILE="$STATE_DIR/cwd"
PID_FILE="$STATE_DIR/pid"
STATUS_FILE="$STATE_DIR/status"
EXIT_FILE="$STATE_DIR/exit"
STDOUT_FILE="$STATE_DIR/stdout"
STDERR_FILE="$STATE_DIR/stderr"

MAX_TASK_BYTES=100000
MAX_OUTPUT_BYTES=48000
REPORT_HEAD_BYTES=30000
REPORT_TAIL_BYTES=16000
PI_TIMEOUT_SECS=540
STATUS_WAIT_SECS=45

"$MKDIR" -p "$STATE_DIR"

fail() {
  printf 'Pi delegation error: %s\n' "$1" >&2
  exit 2
}

write_status() {
  value=$1
  temporary="$STATE_DIR/status.tmp.$$"
  printf '%s\n' "$value" > "$temporary"
  "$MV" -f "$temporary" "$STATUS_FILE"
}

read_status() {
  if [ -f "$STATUS_FILE" ]; then
    "$CAT" "$STATUS_FILE"
  else
    printf 'not_started\n'
  fi
}

pid_is_alive() {
  pid=$1
  case "$pid" in
    ''|*[!0-9]*) return 1 ;;
  esac
  kill -0 "$pid" 2>/dev/null
}

print_bounded() {
  file=$1
  if [ ! -f "$file" ]; then
    printf '(no output)\n'
    return 0
  fi

  bytes=$("$WC" -c < "$file" | "$TR" -d '[:space:]')
  if [ "$bytes" -le "$MAX_OUTPUT_BYTES" ]; then
    "$CAT" "$file"
    return 0
  fi

  "$HEAD" -c "$REPORT_HEAD_BYTES" "$file"
  printf '\n... [Pi output truncated to %s bytes] ...\n' "$MAX_OUTPUT_BYTES"
  "$TAIL" -c "$REPORT_TAIL_BYTES" "$file"
}

resolve_cwd() (
  if [ ! -s "$CWD_FILE" ]; then
    fail "missing target directory in $CWD_FILE"
  fi

  raw_cwd=$("$CAT" "$CWD_FILE")
  newline='
'
  carriage_return=$(printf '\r')
  case "$raw_cwd" in
    *"$newline"*) fail "target directory must be a single line" ;;
    *"$carriage_return"*) fail "target directory must not contain carriage returns" ;;
  esac

  home_root=$(cd "$HOME_DIR" 2>/dev/null && pwd -P) || fail "home directory is unavailable"
  case "$raw_cwd" in
    /*) candidate=$raw_cwd ;;
    *) candidate="$HOME_DIR/$raw_cwd" ;;
  esac

  cd "$candidate" 2>/dev/null || fail "target directory does not exist: $raw_cwd"
  resolved=$(pwd -P)

  case "$resolved" in
    "$home_root"|"$home_root"/*) ;;
    *) fail "target directory must be inside $home_root" ;;
  esac

  case "$resolved" in
    "$home_root/.ssh"|"$home_root/.ssh/"*|\
    "$home_root/.aws"|"$home_root/.aws/"*|\
    "$home_root/.gnupg"|"$home_root/.gnupg/"*|\
    "$home_root/.config"|"$home_root/.config/"*|\
    "$home_root/.zeroclaw"|"$home_root/.zeroclaw/"*)
      fail "target directory is protected: $resolved"
      ;;
  esac

  printf '%s\n' "$resolved"
)

start_delegation() {
  if [ ! -s "$TASK_FILE" ]; then
    fail "missing task in $TASK_FILE"
  fi
  if [ ! -s "$CWD_FILE" ]; then
    fail "missing target directory in $CWD_FILE"
  fi

  task_bytes=$("$WC" -c < "$TASK_FILE" | "$TR" -d '[:space:]')
  if [ "$task_bytes" -gt "$MAX_TASK_BYTES" ]; then
    fail "task is too large (maximum: $MAX_TASK_BYTES bytes)"
  fi
  task=$("$CAT" "$TASK_FILE")
  [ -n "$task" ] || fail "task is empty"

  current_status=$(read_status)
  if [ "$current_status" = "running" ]; then
    pid=''
    if [ -f "$PID_FILE" ]; then
      pid=$("$CAT" "$PID_FILE")
    fi
    if [ -n "$pid" ] && pid_is_alive "$pid"; then
      fail "a Pi delegation is already running (pid $pid)"
    fi
    write_status failed
    printf 'Previous Pi delegation stopped without recording a result.\n' >> "$STDERR_FILE"
  fi

  resolved_cwd=$(resolve_cwd)
  : > "$STDOUT_FILE"
  : > "$STDERR_FILE"
  : > "$EXIT_FILE"
  write_status running

  (
    set +e
    child_pid=''
    trap 'if [ -n "$child_pid" ]; then kill "$child_pid" 2>/dev/null || true; fi; exit 143' HUP INT TERM

    if cd "$resolved_cwd" 2>> "$STDERR_FILE"; then
      "$TIMEOUT" --signal=TERM --kill-after=5 "$PI_TIMEOUT_SECS" \
        "$PI_BIN" --no-session --no-approve --print -- "$task" \
        > "$STDOUT_FILE" 2>> "$STDERR_FILE" &
      child_pid=$!
      if wait "$child_pid"; then
        exit_status=0
      else
        exit_status=$?
      fi
    else
      exit_status=1
    fi

    if [ "$exit_status" -eq 124 ]; then
      printf 'Pi timed out after %s seconds.\n' "$PI_TIMEOUT_SECS" >> "$STDERR_FILE"
    fi
    printf '%s\n' "$exit_status" > "$EXIT_FILE"
    if [ "$exit_status" -eq 0 ]; then
      write_status completed
    else
      write_status failed
    fi
  ) </dev/null >/dev/null 2>&1 &
  pid=$!
  printf '%s\n' "$pid" > "$PID_FILE"

  printf 'Pi delegation started in %s.\n' "$resolved_cwd"
  printf 'Use pi_delegate.status to retrieve its report.\n'
}

status_delegation() {
  waited=0
  status=$(read_status)
  while [ "$status" = "running" ] && [ "$waited" -lt "$STATUS_WAIT_SECS" ]; do
    "$SLEEP" 1
    waited=$((waited + 1))
    status=$(read_status)
  done

  if [ "$status" = "running" ]; then
    pid=''
    if [ -f "$PID_FILE" ]; then
      pid=$("$CAT" "$PID_FILE")
    fi
    if [ -z "$pid" ] || ! pid_is_alive "$pid"; then
      write_status failed
      printf 'Pi delegation stopped without recording a result.\n' >> "$STDERR_FILE"
      status=failed
    fi
  fi

  case "$status" in
    not_started)
      printf 'No Pi delegation is waiting.\n'
      ;;
    running)
      printf 'Pi delegation is still running after %s seconds.\n' "$waited"
      printf 'Run pi_delegate.status again later.\n'
      ;;
    completed)
      printf 'Pi delegation completed successfully.\n'
      printf '%s\n' '--- Pi report ---'
      print_bounded "$STDOUT_FILE"
      if [ -s "$STDERR_FILE" ]; then
        printf '%s\n' '--- Pi diagnostics ---'
        print_bounded "$STDERR_FILE"
      fi
      ;;
    failed)
      printf 'Pi delegation failed.\n'
      if [ -s "$EXIT_FILE" ]; then
        printf 'Exit status: %s\n' "$("$CAT" "$EXIT_FILE")"
      fi
      printf '%s\n' '--- Pi output ---'
      print_bounded "$STDOUT_FILE"
      if [ -s "$STDERR_FILE" ]; then
        printf '%s\n' '--- Pi diagnostics ---'
        print_bounded "$STDERR_FILE"
      fi
      ;;
    cancelled)
      printf 'Pi delegation was cancelled.\n'
      ;;
    *)
      printf 'Unknown Pi delegation state: %s\n' "$status" >&2
      exit 2
      ;;
  esac
}

cancel_delegation() {
  status=$(read_status)
  if [ "$status" != "running" ]; then
    printf 'No running Pi delegation to cancel (state: %s).\n' "$status"
    return 0
  fi

  pid=''
  if [ -f "$PID_FILE" ]; then
    pid=$("$CAT" "$PID_FILE")
  fi
  if [ -n "$pid" ] && pid_is_alive "$pid"; then
    kill "$pid" 2>/dev/null || true
    "$SLEEP" 1
    if pid_is_alive "$pid"; then
      kill -9 "$pid" 2>/dev/null || true
    fi
  fi
  write_status cancelled
  printf 'Pi delegation cancelled.\n'
}

case "${1:-}" in
  start) start_delegation ;;
  status) status_delegation ;;
  cancel) cancel_delegation ;;
  *)
    printf 'usage: zeroclaw-pi-delegate {start|status|cancel}\n' >&2
    exit 2
    ;;
esac
