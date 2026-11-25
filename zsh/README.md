# About

This folder contains user-specific customizations that
are loaded by zsh. On my Mac, I've installed Gnu tools,
since they provide more functionality. Use if you like.

# Loading files

To load these files on login, add this snippet to your .zshrc file:

```zsh

########################
# Set Git repo root folder
########################
export GIT_REPO_HOME="${HOME}/git"

########################
# Load .zshrc.d folder
########################
export ZSHRCD="${HOME}/.zshrc.d"

# Cache completions for 24 hours
if [[ -n ${HOME}/.zcompdump(#qN.mh+24) ]]; then
  compinit -C   # Right: skip checks when cache exists
else
  compinit      # Right: full init when no cache
fi

if [[ -d "$ZSHRCD" ]]; then
  for f in "$ZSHRCD"/*.{sh,zsh}(N); do
    [[ ${f:t} != ~* ]] && source "$f"
  done
fi

```

# Load order

Files are sorted alphabetically when loaded. The standard convention here is to prefix files numerically to ensure load order, if needed: 10-*, 20-*, etc.

# Configuration files

<!-- BEGIN_SH_DOCS -->
### 00-paths.zsh

Configure XDG Base Directory Specification paths.

### 10-direnv.zsh

Initialize and configure direnv for shell integration.

### 10-security.zsh

Configure shell settings for enhanced security and privacy.

### 20-aliases.zsh

Define common shell aliases and shortcut functions.

### 30-aws.zsh

AWS CLI profile management and integration.

### 30-azure.zsh

Azure CLI profile management and integration.

### 30-devbox.zsh

Initialize and configure devbox for shell integration.

### 30-docker.zsh

Docker Compose convenience aliases.

### 30-git.zsh

Git aliases and helpers for common workflows.

### 30-nodejs.zsh

Node.js and npm XDG Base Directory configuration.

### 30-pwsh.zsh

PowerShell upgrade and WSMan module installation helpers.

### 30-terraform-docs.zsh

Terraform documentation generation with automated README injection.

### 30-tofu.zsh

OpenTofu and Terraform configuration management.



<!-- END_SH_DOCS -->

# Git branch cleanup

`gfap` fetches all remotes and prunes stale remote-tracking refs, then asks
whether to force-delete each local branch whose configured upstream ref is
missing locally. This includes squash-merged branches, but a missing upstream
does not guarantee that the remote branch was deleted or that local commits
were merged. Review each branch before confirming; Git will refuse to delete a
branch checked out in a worktree.
