#
# ~/.bashrc
#
export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
export ROCM_PATH=/opt/rocm
export HSA_OVERRIDE_GFX_VERSION=10.3.0
# If not running interactively, don't do anything
[[ $- != *i* ]] && return
#
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Change the window title of X terminals
case ${TERM} in
	xterm*|rxvt*|Eterm*|aterm|kterm|gnome*|interix|konsole*)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\007"'
		;;
	screen*)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/\~}\033\\"'
		;;
esac

use_color=true

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\][\h\[\033[01;36m\] \W\[\033[01;31m\]]\$\[\033[00m\] '
	else
		PS1='\[\033[01;32m\][\u@\h\[\033[01;37m\] \W\[\033[01;32m\]]\$\[\033[00m\] '
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
	alias egrep='egrep --colour=auto'
	alias fgrep='fgrep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we dont have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

unset use_color safe_term match_lhs sh

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB

#xfce alias
alias dnd='xfconf-query -c xfce4-notifyd -p /do-not-disturb -T'

# config aliases
alias editbrc='nvim ~/.bashrc'
alias editpy='nvim ~/.python_bash_aliases'
alias editqtile='nvim ~/.config/qtile/config.py'
alias editvim='python ~/.config/nvim/init.lua'

#Coding Aliases 
alias tosaas='cd /home/jerry/Code/mud_stuff/saas/evennia/'
alias tocode='cd /home/jerry/Code/'

# Some Python Ease of use Aliases. 
#alias py='python'
#alias dec='deactivate'
#alias pvn='python -m venv venv'
#alias pup='pip install --upgrade pip'
#vba() {
#    current_dir=$(pwd)
#    venv_activate="$current_dir/venv/bin/activate"
#    if [ -f "$venv_activate" ]; then
#        # Source the activate script
#        source "$venv_activate"
#        echo "Activated virtual environment in $current_dir/venv"
#    else
#        echo "No virtual environment found at $venv_activate "
#    fi
#}

if [ -f ~/.python_bash_aliases ]; then
    source ~/.python_bash_aliases
fi

xhost +local:root > /dev/null 2>&1

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

shopt -s expand_aliases

# Dog colors
# Define color variables
BRN='\[\033[38;5;94m\]'     # Brown (256-color)
GRY='\[\033[38;5;250m\]'    # Light gray
MAG='\[\033[0;35m\]'        # Magenta
BLU='\[\033[38;5;33m\]'     # Blue
RST='\[\033[0m\]'           # Reset
#alias clrs='printf "${BRN}brown${GRY}gray${MAG}magenta${BLU}blue${RST}reset"'
export PS1="${MAG}[${BRN}K${GRY}o${BRN}o${GRY}k${BRN}i${GRY}e${BRN}r${GRY}h${BRN}o${GRY}n${BRN}d${GRY}j${BRN}e ${RST}in ${BLU}\W ${MAG}]\$${RST} "
# export QT_SELECT=4
# Enable history appending instead of overwriting.  #139609
shopt -s histappend
# For the better man exp!
export MANPAGER='nvim +Man!'
set -o vi

