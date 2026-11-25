#!/usr/bin/env zsh
#
# PowerShell upgrade and WSMan module installation helpers.
#
# Provides upgradepwsh function to refresh PowerShell to the latest version
# and install required WSMan dependencies via Homebrew.
#

#+++++++++++++++++++++++++++++++++++++
# Powershell updater
#+++++++++++++++++++++++++++++++++++++

# Only load if tool is present
command -v pwsh > /dev/null 2>&1 || return
command -v brew > /dev/null 2>&1 || return

function upgradepwsh() {
  brew upgrade powershell
  pwsh -Command 'Install-Module -Name PSWSMan -Force'
  sudo pwsh -Command 'Install-WSMan'
}
