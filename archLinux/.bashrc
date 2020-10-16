#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -la'
alias vv='vim ~/.vimrc'
alias work='~/dotfiles/work_config.sh'
alias rust='cd ~/leetcode/leetcode_rust/src'
alias dots='cd ~/dotfiles'
alias leet='cd ~/leetcode/easy_topInterview'
parse_git_branch() {
	git branch 2> /dev/null | sed -e '/&[&*]/d' -e 's/* \(.*\)/ (\1)/'
}
PS1="\u@\h \[\033[32m\]\w\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "

# change this so that exiting vim in alacritty will clear the screen...
export TERM=xterm-256color
# this is necessary for fzf keybindings to take effect, like ctrl-r 
[ -f /usr/share/fzf/key-bindings.bash ] && source /usr/share/fzf/key-bindings.bash

