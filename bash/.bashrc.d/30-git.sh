#!/usr/bin/env bash

#+++++++++++++++++++++++++++++++++++++
# Git aliases
#+++++++++++++++++++++++++++++++++++++

# Only load if tool is present
_gitcmd="$(command -v git)" || return

export GIT_REPO_HOME="${HOME}/git"

if [[ -s "${_gitcmd}" ]]; then
  if [[ -s "${GIT_REPO_HOME}" && -d "${GIT_REPO_HOME}" ]]; then
    # shellcheck disable=SC2139
    alias cdgit="cd ${GIT_REPO_HOME}"
  fi

  function GitCheckoutAndPull() {
    local _branch="${1}"
    git checkout "${_branch}" && git pull
  }

  if alias gfap >/dev/null 2>&1; then
    unalias gfap
  fi

  function gfap() {
    git fetch --all --prune || return

    local branches branch answer
    branches=$(LC_ALL=C git for-each-ref \
      --format='%(if:equals=[gone])%(upstream:track)%(then)%(refname:short)%(end)' \
      refs/heads) || return
    [[ -n "${branches}" ]] || return 0

    while IFS= read -r branch <&3; do
      [[ -n "${branch}" ]] || continue
      printf "Force-delete local branch '%s' (upstream gone)? [y/N] " "${branch}" >&2
      if ! IFS= read -r answer; then
        printf '\ngfap: could not read confirmation; stopped without deleting %s\n' "${branch}" >&2
        return 1
      fi
      if [[ "${answer}" == [yY] ]]; then
        git branch -D -- "${branch}" || return
      fi
    done 3<<< "${branches}"
  }

  alias gchm="git checkout main || git checkout master"
  alias ga="git add"
  alias gb="git branch"
  alias gc="git commit -m "
  alias gch="git checkout"
  alias gchp="GitCheckoutAndPull"
  alias gcll="git config --local --list"
  alias gcl="git config --list"
  alias gf="git fetch"
  alias gfa="git fetch --all"
  alias gll="git status"
  alias gm="git merge"
  alias gp="git pull"

  # clone a repo, then open the directory in VSCode
  function gco() {
    local _repo=$1
    local helpmsg="
    Clone a repo then open the directory in VSCode

    Usage: gco REPO_URL
    "

    if [[ -z "${_repo}" ]]; then
      echo "Missing repo URL argument."
      echo "${helpmsg}"
      exit 1
    fi

    if [[ "${_repo}" == "-h" || "${_repo}" == "--help" ]]; then
      echo "${helpmsg}"
      exit 0
    fi

    # Make sure the repo URL ends with .git
    if [[ "${_repo}" != *.git ]]; then
      echo "Error: Repo URL must end with .git"
      exit 1
    fi

    local _path="${_repo##*/}"
    _path="${_path%.git}"
    git clone "${_repo}"
    echo "Opening the repo in VSCode"
    code "${_path}"
  }

  function gfd() {
    # For every subdirectory with a provisioned git repo, run git fetch --all && git pull
    while IFS= read -r -d '' d; do
      local _dirname=$(basename "$(dirname "$d")")
      echo -e "--------------------------------------\nFetching remote updates for ${_dirname}\n--------------------------------------"
      (cd "${_dirname}" && git fetch --all && git pull)
      echo -e "\n\n"
    done < <(find ./ -depth 2 -type d -name .git -print0)
  }
fi
unset _gitcmd
