#!/usr/bin/env zsh
#
# Terraform documentation generation with automated README injection.
#
# Provides tfdocs alias for terraform-docs to automatically generate and
# inject Markdown-formatted documentation into README files.
#

#+++++++++++++++++++++++++++++++++++++
# Terraform-docs config
#+++++++++++++++++++++++++++++++++++++

# Only load if tool is present
command -v terraform-docs 2>&1 > /dev/null || return

alias tfdocs='terraform-docs markdown table --output-file README.md --output-mode inject'
