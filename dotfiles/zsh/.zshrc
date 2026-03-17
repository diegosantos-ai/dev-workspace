#!/usr/bin/env zsh
# shellcheck shell=zsh
# ~/.zshrc (Gerenciado via GNU Stow)

# Habilitar autocompletar
autoload -Uz compinit
compinit

# Configurações de Histórico
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt sharehistory
setopt incappendhistory

# Cores no ls
alias ls='ls --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Prompt simples
PROMPT='%F{green}%n@%m%f:%F{blue}%~%f$ '

