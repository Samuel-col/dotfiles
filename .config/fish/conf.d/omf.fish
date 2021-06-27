# Path to Oh My Fish install.
set -q XDG_DATA_HOME
  and set -gx OMF_PATH "$XDG_DATA_HOME/omf"
  or set -gx OMF_PATH "$HOME/.local/share/omf"

# Load Oh My Fish configuration.
source $OMF_PATH/init.fish

#Aliases
alias la="ls -lah"
alias p="sudo"
alias please="sudo"
alias e="exit"
alias cmatrix="cmatrix -C yellow"
alias android="jmtpfs"
alias uandroid="fusermount -u"
alias cl="clear"
alias uni="cd /Archivos/A/Universidad/"
alias lua="lua -i -e \"st=require'stats';mat=require'matrix'\""
alias ZZ="cd .."

#Variables
set EDITOR "vim"
set BROWSER "firefox-esr"
set PATH /home/samuel/julia-1.5.3/bin:$PATH:/home/samuel/.local/bin:/Archivos/A/R/R-3.6.3/bin/gen
# sourc "$HOME/.cargo/env"

#Arranque
neofetch

