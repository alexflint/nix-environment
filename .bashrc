# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
    xterm-256color) color_prompt=yes;;
esac

# ls colors for OSX
export CLICOLOR=true
export LSCOLORS=exfxcxdxbxegedabagacad
export TERM=xterm-color

# Add git branch to prompt
function parse_git_branch {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo " ("${ref#refs/heads/}")"
}

# Enable git auto completion - for some reason stuff in
# git-completions.d is not being auto-loaded
if [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
		source /usr/local/etc/bash_completion.d/git-completion.bash
fi


# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x `which tput` ] && tput setaf 1 >&/dev/null; then
				color_prompt=yes
    else
				color_prompt=
    fi
fi

RED="\[\033[0;31m\]"
GREEN="\[\033[01;32m\]"
BLACK="\[\033[00m\]"
BLUE="\[\033[01;34m\]"

if [ "$color_prompt" = yes ]; then
    PS1="${debian_chroot:+($debian_chroot)}${GREEN}Mac${BLACK}:${BLUE}\w${RED}\$(parse_git_branch)${BLACK}\$ "
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# Alias definitions
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
