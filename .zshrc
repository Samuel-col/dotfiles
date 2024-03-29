# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=1000
setopt autocd extendedglob nomatch notify
unsetopt beep
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/samuel/.zshrc'

autoload -U compinit
# autoload -Uz compinit
compinit
# End of lines added by compinstall

# https://wiki.archlinux.org/title/Zsh_(Espa%C3%B1ol)#Configuraci%C3%B3n_Inicial
# Prompts
autoload -U promptinit
promptinit
prompt fade


# Resaltar sintaxis
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# PATH
export PATH=/home/samuel/julia-1.9.0/bin:$PATH

# aliases
alias ZZ="cd .."
alias la="exa -alh -s type"
alias ls="exa -s type"
alias tree="exa -T"
alias uni="cd /home/samuel/Documentos/U"
alias p="sudo"
alias cmatrix="cmatrix -C yellow"
alias e="exit"
alias android="jmtpfs"
alias uandroid="fusermount -u"
alias v="nvim"
alias hdmi_l="xrandr --output HDMI1 --auto --brightness 0.1 --left-of eDP1"
alias hdmi_r="xrandr --output HDMI1 --auto --brightness 0.1 --right-of eDP1"
alias hdmi_s="xrandr --output HDMI1 --auto --brightness 0.1 --same-as eDP1"
alias hdmi_off="xrandr --output HDMI1 --off"
alias hdmi_same="xrandr --output HDMI1 --auto --same-as eDP1"
alias hdmi_only="xrandr --output HDMI1 --auto --same-as eDP1 && xrandr --output eDP1 --off"
