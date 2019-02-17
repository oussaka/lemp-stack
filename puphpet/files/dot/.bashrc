[ -r /etc/bashrc ] && source /etc/bashrc
[ -r /etc/bash_completion ] && source /etc/bash_completion
[ -r ~/.git-completion.bash ] && source ~/.git-completion.bash
[ -r ~/.git-prompt.sh ] && source ~/.git-prompt.sh
[ -r /usr/local/rvm/scripts/rvm ] && source /usr/local/rvm/scripts/rvm
[ -r ~/.bash_aliases ] && source ~/.bash_aliases

__has_parent_dir () {
    # Utility function so we can test for things like .git/.hg without firing up a
    # separate process
    test -d "$1" && return 0;

    current="."
    while [ ! "$current" -ef "$current/.." ]; do
        if [ -d "$current/$1" ]; then
            return 0;
        fi
        current="$current/..";
    done

    return 1;
}

__vcs_name() {
    if [ -d .svn ]; then
        echo "-[svn]";
    elif __has_parent_dir ".git"; then
        echo "-[$(__git_ps1 'git %s')]";
    elif __has_parent_dir ".hg"; then
        echo "-[hg $(hg branch)]"
    fi
}

# ANSI colors: http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/x329.html
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[34m"
PURPLE="\033[0;35m"
DARK_GREY="\033[1;30m"
LIGHT_GREY="\033[0;37m"
NOCOLOR="\033[0m" # No Color

black=$(tput -Txterm setaf 0)
red=$(tput -Txterm setaf 1)
green=$(tput -Txterm setaf 2)
yellow=$(tput -Txterm setaf 3)
dk_blue=$(tput -Txterm setaf 4)
pink=$(tput -Txterm setaf 5)
lt_blue=$(tput -Txterm setaf 6)
bold=$(tput -Txterm bold)
reset=$(tput -Txterm sgr0)

# Background Colors
BRed='\033[0;41m'
BGreen='\033[1;42m'       # Green
BYellow='\033[1;43m'      # Yellow
BBlue='\033[1;44m'        # Blue
BPurple='\033[1;45m'      # Purple
BCyan='\033[1;46m'        # Cyan
BWhite='\033[1;47m'       # White
BLightGrey="\033[0;47m"

# Nicely formatted terminal prompt
export PS1='\n\[$bold\]\[$black\][\[$dk_blue\]\@\[$black\]]-[\[$green\]\u\[$yellow\]@\[$green\]\h\[$black\]]-[\[$pink\]\w\[$black\]]\[\033[0;33m\]$(__vcs_name) \[\033[00m\]\[$reset\]\n\[$reset\]\$ '
