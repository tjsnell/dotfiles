
export TERM=vt100

# by default, we want this to get set.
# Even for non-interactive, non-login shells.
#if [ "`id -gn`" = "`id -un`" -a `id -u` -gt 99 ]; then
#    umask 002
#else
    umask 022
#fi
 
if [[ $- != *i* ]]; then
    # Shell is non-interactive.  Be done now
    return
fi

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

#-----------------------------------------------------------
# zsh options
#-----------------------------------------------------------
setopt append_history		# append vs overwrite history file
setopt share_history    	# share between sessions
setopt HIST_IGNORE_ALL_DUPS	# yep as it says

setopt EXTENDED_GLOB


setopt no_check_jobs   		# don't warn me about bg processes when exiting
setopt no_hup          		# and don't kill them, either

setopt AUTO_CD 			# if a command is not a command but a directory, cd into it
setopt AUTO_LIST 		# Automatically list choices on an ambiguous completion. 

setopt AUTO_PARAM_SLASH
setopt AUTO_REMOVE_SLASH
setopt GLOB 			# Perform filename generation


setopt NOTIFY 			# This makes the shell give immediate notice of changes in job status

set -A watch $USER root
export WATCHFMT='%n has %a %l %(M:from %M :)at %T.'

bindkey -e 			# Emacs keybindings.

#-----------------------------------------------------------
# Path fun
#-----------------------------------------------------------

# Add some directory to PATH if it really exists
# and if it really is directory and if it is not
# yet in PATH
pathmunge ()
{
    if ! echo $PATH | /bin/egrep "(^|:)$1($|:)" > /dev/null 2>&1
    then
        if test -d $1
        then
            if [ "$2" = "after" ] ; then
                PATH=$PATH:$1
            else
                PATH=$1:$PATH
            fi
        fi
    fi
}



PATH=$PATH

pathmunge ${HOME}/bin

# Solaris fun
pathmunge /usr/ucb 

pathmunge /usr/local/bin 
pathmunge /usr/local/sbin 
pathmunge /opt/bin after
pathmunge /opt/local/bin after
pathmunge /opt/local/sbin after

# Find java
pathmunge /usr/local/java/jdk/bin after
pathmunge /usr/jdk/latest/bin after


pathmunge /bin after
pathmunge /sbin after
pathmunge /usr/bin after
pathmunge /usr/sbin after

export path




#-----------------------------------------------------------
# Set my default editer
#-----------------------------------------------------------
export EDITOR=vi

function ff {
if [ $# = 1 ]; then
    find . | grep -i $*
else
    find $1 | grep -i $2
fi
}

function fff {
    find . | grep -i $1 | grep -i $2
}

#-----------------------------------------------------------
# OS Fun
#-----------------------------------------------------------
case $OSTYPE in
    darwin*)
	export GREP_OPTIONS='--color=auto '
        export LS_OPTIONS='-CFG '
        export PSG_OPTIONS='auxx '
	;;
    solaris*)
	export GREP_OPTIONS=''
        export LS_OPTIONS='-CF '
        export PSG_OPTIONS='-auxx '
	;;
    linux*)
	export GREP_OPTIONS='--color=auto '
        export LS_OPTIONS='-CF --color=auto '
        export PSG_OPTIONS='-auxx '
	;;
esac
alias grep="grep $GREP_OPTIONS"

alias ls="ls $LS_OPTIONS "
alias ll='ls $LS_OPTIONS -l'
alias l="ls $LS_OPTIONS -lA"
alias l.="ls -d $LS_OPTIONS .[0-9a-zA-Z]*"

alias psg="ps $PSG_OPTIONS | grep -i"

alias find='noglob find'

#-----------------------------------------------------------
# cd fun
#-----------------------------------------------------------
alias cd-='cd -'
alias cd..='cd ..'
alias cd...='cd ../..'
alias cd....='cd ../../..'
alias cd.....='cd ../../../..'
alias cd......='cd ../../../../..'
alias cd.......='cd ../../../../../..'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'



#-----------------------------------------------------------
# Colored filename-completion!!11!!!
#-----------------------------------------------------------

ZLS_COLORS="$LS_COLORS"
export ZLS_COLORS
zmodload zsh/complist 2> /dev/null


#-----------------------------------------------------------
# Colors!
#-----------------------------------------------------------


#/usr/share/zsh/4.0.2/functions/Misc/colors
# Attribute codes:
#  00 none
#  01 bold
#  02 faint                  22 normal
#  03 standout               23 no-standout
#  04 underline              24 no-underline
#  05 blink                  25 no-blink#  07 reverse                27 no-reverse
#  08 conceal

# Text color codes:
#  30 black                  40 bg-black
#  31 red                    41 bg-red
#  32 green                  42 bg-green
#  33 yellow                 43 bg-yellow
#  34 blue                   44 bg-blue
#  35 magenta                45 bg-magenta#  36 cyan                   46 bg-cyan
#  37 white                  47 bg-white
#  39 default                49 bg-default

#PS1="%{"$'\e[01;31m'"%}$PS1%{"$'\e[00m'"%}"
#             ^^ ^^                 ^^
#             |  |                  |
#          bold  red                reset

#export FOO="%{"$'\e[31m'"%}"#PS1="${FOO}$PS1%{"$'\e[0m'"%}"

# DEFINE ALL COLORS IN THIS PLACE
# for example color for "%h" is in variable "COLOR_p_h"
# except
# color for "%#" is in variable "COLOR_p_hash"
# color for "%/" is in variable "COLOR_p_slash"
# color for "%*" is in variable "COLOR_p_star"
# color for "@" is in variable "COLOR_at"

#COLOR="%{"$'\e[31m'"%}"

if (( EUID == 0 ))
then
    COLOR_ROOT_BOLD="%{"$'\e[01m'"%}"
    COLOR_RESET="%{"$'\e[39;49;01m'"%}"
else
    COLOR_ROOT_BOLD=""
    COLOR_RESET="%{"$'\e[39;49;00m'"%}"
fi

COLOR_REAL_RESET="%{"$'\e[39;49;00m'"%}"

colorize()
{
    COLOR_p_h="%{"$'\e[32;44m'"%}"
    COLOR_p_l="%{"$'\e[32;44m'"%}"
    COLOR_p_y="%{"$'\e[32;44m'"%}"

    COLOR_p_n="%{"$'\e[35;43m'"%}"
    COLOR_at="%{"$'\e[35;43m'"%}"
    COLOR_p_m="%{"$'\e[35;43m'"%}"

    COLOR_WHOLEHOST="%{"$'\e[35;43m'"%}"
    COLOR_SHORTHOST="%{"$'\e[35;43m'"%}"
    COLOR_DOMAINHOST="%{"$'\e[35;43m'"%}"

    COLOR_p_D="%{"$'\e[31;46m'"%}"
    COLOR_MY_DATE="%{"$'\e[31;46m'"%}"
    COLOR_p_star="%{"$'\e[31;46m'"%}"
    COLOR_MY_TIME="%{"$'\e[31;46m'"%}"

    COLOR_ROOT="%{"$'\e[01;31;43m'"%}"

    if (( EUID == 0 ))
    then
        COLOR_p_hash="${COLOR_ROOT}"
        COLOR_p_slash="${COLOR_ROOT}"
    else
        COLOR_p_hash="%{"$'\e[01;03;33;44m'"%}"
        COLOR_p_slash="%{"$'\e[31;43m'"%}"
    fi

    $LATEST_PROMPT
}

uncolorize()
{
    COLOR_p_h="${COLOR_RESET}"
    COLOR_p_l="${COLOR_RESET}"
    COLOR_p_y="${COLOR_RESET}"

    COLOR_p_n="${COLOR_RESET}"
    COLOR_at="${COLOR_RESET}"
    COLOR_p_m="${COLOR_RESET}"

    COLOR_WHOLEHOST="${COLOR_RESET}"
    COLOR_SHORTHOST="${COLOR_RESET}"
    COLOR_DOMAINHOST="${COLOR_RESET}"

    COLOR_p_D="${COLOR_RESET}"
    COLOR_MY_DATE="${COLOR_RESET}"
    COLOR_p_star="${COLOR_RESET}"
    COLOR_MY_TIME="${COLOR_RESET}"

    COLOR_ROOT="%{"$'\e[39;49;01m'"%}"

    if (( EUID == 0 ))
    then
        COLOR_p_hash="%s${COLOR_ROOT}"
        COLOR_p_slash="%s${COLOR_ROOT}"
    else
        COLOR_p_hash="${COLOR_RESET}"
        COLOR_p_slash="${COLOR_RESET}"
    fi

    $LATEST_PROMPT
}

#colorize
uncolorize


#-----------------------------------------------------------
# Prompts
#-----------------------------------------------------------
cuttwolineprompt()
{
export PS1="${COLOR_ROOT_BOLD}${COLOR_ROOT}%S${ROOTTEXT}%s${COLOR_RESET}$ROOTPROMPTADD${COLOR_p_n}%n${COLOR_RESET}${COLOR_at}@${COLOR_RESET}${COLOR_p_m}%m${COLOR_RESET} : ${COLOR_p_slash}%/${COLOR_RESET}
${COLOR_p_hash}%#${COLOR_REAL_RESET} "
#export RPROMPT="${COLOR_ROOT_BOLD}${COLOR_p_h}%h${COLOR_RESET} | ${COLOR_p_y}%y${WINDOW:+.${WINDOW}}${COLOR_REAL_RESET}"
LATEST_PROMPT="cuttwolineprompt"
}

defaultprompt()
{
    # CHOOSE ONE PROMPT

    #longprompt
    #twolineprompt
    cuttwolineprompt
    #threelinetimeprompt
    #cutthreelinetimeprompt
}

defaultprompt



#-----------------------------------------------------------
# Watching for other users
#-----------------------------------------------------------

LOGCHECK=60
WATCHFMT="[%B%t%b] %B%n%b has %a %B%l%b from %B%M%b"

ROOTTEXT=%(!.-=*[ROOT ZSH]*=-.)
ROOTPROMPTADD=%(!. .)
ROOTTITLEADD=%(!. | .)

