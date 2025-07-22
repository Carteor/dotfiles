#!/usr/bin/env bash

# Default durations (in minutes)
work_minutes=25
short_break_minutes=5
long_break_minutes=15
cycles_before_long_break=4

# Internal state
paused=false
stop_requested=false

print_usage() {
    echo "Usage: $0 [--work MIN] [--short MIN] [--long MIN] [--cycles N]"
    echo "  --work     Focus duration in minutes (default: 25)"
    echo "  --short    Short break duration (default: 5)"
    echo "  --long     Long break duration (default: 15)"
    echo "  --cycles   Cycles before long break (default: 4)"
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        --work) work_minutes="$2"; shift 2 ;;
        --short) short_break_minutes="$2"; shift 2 ;;
        --long) long_break_minutes="$2"; shift 2 ;;
        --cycles) cycles_before_long_break="$2"; shift 2 ;;
        -h|--help) print_usage; exit 0 ;;
        *) echo "Unknown option: $1"; print_usage; exit 1 ;;
    esac
done

# Handle pause/resume and stop via signals
trap 'paused=!$paused' SIGUSR1
trap 'stop_requested=true' SIGUSR2

chime() {
    paplay /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null || \
    aplay /usr/share/sounds/alsa/Front_Center.wav 2>/dev/null || \
    printf '\a'
}

notify() {
    notify-send "$1" "$2"
}

update_tmux_status() {
    local phase="$1"
    local time="$2"

    case "$phase" in
        FOCUS) icon="🍅" ;;
        BREAK) icon="🌿" ;;
        LONG\ BREAK) icon="☕" ;;
        PAUSED) icon="⏸️" ;;
        *) icon="❓" ;;
    esac

    tmux set-option -g status-right "$icon $phase: $time"
}

run_timer() {
    local seconds_left=$1
    local label="$2"

    while [ $seconds_left -gt 0 ]; do
        if $stop_requested; then
            tmux set-option -g status-right ""
            exit 0
        fi

        if $paused; then
            update_tmux_status "PAUSED" ""
            sleep 1
            continue
        fi

        mins=$((seconds_left / 60))
        secs=$((seconds_left % 60))
        time_str=$(printf '%02d:%02d' $mins $secs)
        update_tmux_status "$label" "$time_str"
        sleep 1
        seconds_left=$((seconds_left - 1))
    done
}

main() {
    cycle=0

    # Ensure clean exit on Ctrl+C or other signals
    trap 'update_tmux_status ""; exit' SIGINT SIGTERM

    while true; do
        cycle=$((cycle + 1))

        notify "Pomodoro" "Cycle $cycle: Focus time! 🍅"
        run_timer $((work_minutes * 60)) "FOCUS"
        chime

        if (( cycle % cycles_before_long_break == 0 )); then
            notify "Pomodoro" "Long break time! ☕"
            run_timer $((long_break_minutes * 60)) "LONG BREAK"
        else
            notify "Pomodoro" "Short break time! 🌿"
            run_timer $((short_break_minutes * 60)) "BREAK"
        fi
        chime
    done
}

main
