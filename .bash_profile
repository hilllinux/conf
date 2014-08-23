alias ls="ls -G"
alias g="gvim"
alias l="ls -l"
alias ll="ls -l"
alias la="ls -al"
alias ck="ping -c 5 114.114.114.114"

# quick create cscope file
alias csfile="find `pwd` -name '*.h' -o -name '*.c' > cscope.files"

##
# Your previous /Users/wsq/.bash_profile file was backed up as /Users/wsq/.bash_profile.macports-saved_2012-09-05_at_23:37:19
##

# MacPorts Installer addition on 2012-09-05_at_23:37:19: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
export PATH=/usr/local/Cellar/ctags/5.8/bin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.

export PATH=/usr/local/bin:$PATH

#define for msf
export MSF_DATABASE_CONFIG=~/workspace/metasploit-framework/config/database.yml
export PS1="\[\e[00;33m\]\u\[\e[0m\]\[\e[00;37m\]@\h:\[\e[0m\]\[\e[00;36m\][\w]:\[\e[0m\]\[\e[00;37m\] \[\e[0m\]"

alias pg_start='pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start'
alias pg_stop='pg_ctl stop'

# define for tmux
# start for new tmux
alias tms="tmux"
# continue
alias tma="tmux a"

# define for quick ssh connect
alias yurtree="ssh yurtree"
alias pi="ssh piServer"
