#!/usr/bin/env zsh
#
# Docker Compose convenience aliases.
#
# Provides short aliases for common Docker Compose workflows: up, down, and run.
#

#+++++++++++++++++++++++++++++++++++++
# Docker-specific setup
#+++++++++++++++++++++++++++++++++++++

# Only load if tool is present
_clicmd="$(command -v docker)" || return

alias dcup='docker-compose up -d'
alias dcdown='docker-compose down'
alias dcrun='docker-compose run -it --rm'
