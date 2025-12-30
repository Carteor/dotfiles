# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Always restore cursor on shell exit
trap 'tput cnorm' EXIT


# append to the history file, don't overwrite it
shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=20000
HISTCONTROL=ignoredups:erasedups:ignorespace
# Make bash write history after each command
PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
shopt -s cdspell
shopt -s autocd
set completion-ignore-case on

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Nvim
alias nv="nvim"
alias telegram='nohup telegram > /dev/null 2>&1 &'
alias firefox='nohup firefox > /dev/null 2>&1 &'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'

export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export PATH="$PATH:/home/carte/.local/bin"
export PATH="/home/sayat/.npm-global/bin:$PATH"
export WAYLAND_DISPLAY=wayland-0
export GEMINI_API_KEY="AIzaSyAsJ5EM6xBRAJiSREFQ0xOzuchE2S4h5sU"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
export PATH='/home/sayat/.duckdb/cli/latest':$PATH

# Safely auto-start tmux if not already inside tmux
if [ -z "$TMUX" ] && [ -n "$PS1" ] && command -v tmux >/dev/null 2>&1; then
    # Only start tmux if no server exists
    if ! pgrep -x tmux >/dev/null 2>&1; then
        tmux start-server >/dev/null 2>&1
        tmux new-session -A -s main >/dev/null 2>&1 || tmux new -s main
    else
        tmux attach -t $(tmux list-sessions -F '#S' | head -n1)
    fi
fi

# --- Persistent SSH agent setup ---
SSH_ENV="$HOME/.ssh/environment"

start_agent() {
    echo "Starting new ssh-agent..."
    (umask 066; ssh-agent > "$SSH_ENV")
    . "$SSH_ENV" > /dev/null
    # Auto-add key if available
    ssh-add ~/.ssh/id_rsa 2>/dev/null
}

# Reuse existing agent if possible
if [ -f "$SSH_ENV" ]; then
    . "$SSH_ENV" > /dev/null
    if ! ssh-add -l &>/dev/null; then
        start_agent
    fi
else
    start_agent
fi

if grep -qi microsoft /proc/version; then
    # WSL detected
    alias projects="cd /mnt/e/Projects/"
else
    # Native Linux
    alias projects="cd ~/Projects"
fi

# Use fzf to search command history (CTRL-R)
if [[ -n $BASH_VERSION ]]; then
    source /usr/share/doc/fzf/examples/key-bindings.bash
fi

eval "$(starship init bash)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# opencode
export PATH=/home/sayat/.opencode/bin:$PATH
export PATH="$HOME/minio-binaries:$PATH"
