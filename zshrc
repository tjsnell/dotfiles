
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
pathmunge /usr/ucb/bin 

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

#-----------------------------------------------------------
# OS Fun
#-----------------------------------------------------------
case $OSTYPE in
    darwin*)
	export GREP_OPTIONS='--color=auto '
        LS_OPTIONS='-CFG '
	;;
    solaris*)
	export GREP_OPTIONS=''
        LS_OPTIONS='-CF '
	;;
    linux*)
	export GREP_OPTIONS='--color=auto '
        LS_OPTIONS='-CF --color=auto '
	;;
esac
alias grep='grep $GREP_OPTIONS'

alias ll="ls $LS_OPTIONS -l"
alias l="ls $LS_OPTIONS -lA"
alias l.="ls -d $LS_OPTIONS .[0-9a-zA-Z]*"

alias psg='ps -auxx | grep -i'			# todo - make sys adj

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
# Watching for other users
#-----------------------------------------------------------

LOGCHECK=60
WATCHFMT="[%B%t%b] %B%n%b has %a %B%l%b from %B%M%b"

ROOTTEXT=%(!.-=*[ROOT ZSH]*=-.)
ROOTPROMPTADD=%(!. .)
ROOTTITLEADD=%(!. | .)

