#!/usr/bin/env bash
#
# Configure shell settings for enhanced security and privacy.
#
# Disables command history persistence to disk after session exit,
# and configures window title behavior for terminal sessions.
#

#+++++++++++++++++++++++++++++++++++++
# Update shell settings to enhance security and privacy
#+++++++++++++++++++++++++++++++++++++

# Don't save command history after logoff
export HISTFILESIZE=0

# Set window title on login
# echo -en "\033]0;${USER}@${HOSTNAME%%.*}\a"

# Reset window title on logout
# export PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}"; echo -ne "\007"'
