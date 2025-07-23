# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoredups:erasedups:ignorespace

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

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

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

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

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Nvim
alias v="nvim"
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

if [[ -z "$TMUX" ]]; then
    tmux attach -t mysession || tmux new -s mysession
fi

if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa
    ssh-add ~/.ssh/etl-work-pc
fi

alias projects="cd ~/Documents/Projects"
alias reload="source ~/.bashrc"

# Use fzf to search command history (CTRL-R)
if [[ -n $BASH_VERSION ]]; then
    source /usr/share/doc/fzf/examples/key-bindings.bash
fi

# --- Per-tmux-pane history ---
#if [[ -n "$TMUX" ]]; then
#  export HISTFILE="$HOME/.bash_history_tmux_$(tmux display-message -p '#{session_name}_#{window_index}_#{pane_index}')"
#else
#  export HISTFILE="$HOME/.bash_history"
#fi

# ChatGPT session token
export TOKEN="eyJhbGciOiJkaXIiLCJlbmMiOiJBMjU2R0NNIn0..9uIYkn77NwiwiscU.mRkzha5y-cXyv4bWvE5L982svjYXlDYdj1I1X5w2URCTEm212AtP-Hx9eZ8JibssNQ9nS7Ye-SzgcGvuCDntoWBDcY3xHINzNzMjhckfckNCiQyVISTXk5YZG7K8y3a10-j4IQDzrfvnWF_Bp5o7ucX3qfi3FqgNuZBzkXyavB_orWT0PoWUBiyUIhbizBWbsppd6iBDCAoyUsPit4MVOJiP00HfiXFwhf-vWw-XPNwuQ8Rn4KuLjHy8J5KlBRIAxz2Xg8We-IJWNYj86bXFI1dkAWNNkzpe7khOEM_IElFOsqeR-cya0E21XR_u1TsBJOXRCDFq9c6LQkhMCuXCCJXgIyqzwWGI9XQ2vTtPV3JY39r9VLpCsmZ7ZNgfg137cc7lxV0tJeKMgtcjJeMd6boj9plyBuJdHBOB8…Gdqy8KsoX0JFK6E9_O5oLUcZotipZ7sfkT3FfucFrk9_TpGJBWi_hc9N0agBsBtgRLRzJsjc0fbWGwBFcdoa0a6iATSSjsBIxyi81rtHgmY16mE-HN2mgUOKeanjEiyXjO7iObAMLdcgAUvrZgldhFL3v0-M6TR6dWWm8g6Cg-HFeyVa2zMMkJgsqxDeyKR4fma2nibt-3xkYT4FHeCo1PPSXiHQlAXAA8MNCOPFdv_sM1fbW1OD5dXr8pc_spL8BchljHNWzSvkzscwhXuOjyKZxik5EiIjeAI0THjqMXQL87BRY3UQ2gHtlsYQcYjse5uG6eM5KAfIJr-bEmbybybg0aciZiw6p_-erqAT0nBsOJfvTJg.-nBDe9cZ7iSp_h-PxYVKew"

# Force immediate save/load of history
#PROMPT_COMMAND="history -a; history -n; $PROMPT_COMMAND"

eval "$(starship init bash)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# opencode
export PATH=/home/sayat/.opencode/bin:$PATH
