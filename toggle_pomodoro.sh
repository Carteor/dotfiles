#!/usr/bin/env bash

# Customize this path to your real pomodoro script
POMODORO_SCRIPT="$HOME/dotfiles/pomodoro.sh"

# Check if Pomodoro is running
pid=$(pgrep -f "$POMODORO_SCRIPT")

if [[ -z "$pid" ]]; then
    # Not running — start a new one
    nohup "$POMODORO_SCRIPT" --work 25 --short 5 --long 15 --cycles 4 >/dev/null 2>&1 &

    tmux display-message "Pomodoro started"
else
    # Already running — toggle pause/resume
    kill -USR1 "$pid"
fi
