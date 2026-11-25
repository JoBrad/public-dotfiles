#!/usr/bin/env bash
#
# Docker Compose convenience aliases.
#
# Provides short aliases for common Docker Compose workflows: up, down, and run.
#

#+++++++++++++++++++++++++++++++++++++
# Docker aliases
#+++++++++++++++++++++++++++++++++++++

# Only load if tool is present
command -v docker > /dev/null 2>&1 || return

alias dcup='docker compose up -d'
alias dcdown='docker compose down'
alias dcrun='docker compose run -it --rm'
