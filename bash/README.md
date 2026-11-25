# About

This folder contains user-specific customizations that
are loaded by bash.

# Loading files

To load these files on login, add this snippet to your .bash_aliases or .bashrc file:

```
########################
# Cache completions for 24 hours
########################
_comp_cache="${HOME}/.bash_completion_cache"
if [[ -f "$_comp_cache" && $(find "$_comp_cache" -mtime -1 2>/dev/null) ]]; then
  source "$_comp_cache"
else
  # Rebuild completion cache
  {
    complete -p 2>/dev/null
    # Add any custom completions here
  } > "$_comp_cache" 2>/dev/null
fi

########################
# Load .bashrc.d folder
########################
export BASHRCD="${HOME}/.bashrc.d"

if [[ -d "$BASHRCD" ]]; then
  for f in "$BASHRCD"/*.sh; do
    [[ -f "$f" && ! "${f##*/}" =~ ^~ ]] && source "$f"
  done
fi

```

# Load order

Files are sorted alphabetically when loaded. The standard convention here is to
prefix files numerically to ensure load order, if needed: 10-*, 20-*, etc.

# Configuration files

<!-- BEGIN_SH_DOCS -->
### 00-paths.sh

Configure XDG Base Directory Specification paths.

### 10-direnv.sh

Initialize and configure direnv for shell integration.

### 10-security.sh

Configure shell settings for enhanced security and privacy.

### 20-aliases.sh

Define common shell aliases and shortcut functions.

### 20-prompt.sh

Configure the bash shell prompt.

### 30-aws.sh

AWS CLI profile management and integration.

### 30-docker.sh

Docker Compose convenience aliases.

### 30-git.sh

Git aliases and helpers for common workflows.

### 30-grep.sh

Configure grep with colorized output and VCS directory exclusion.

### 30-pwsh.sh

PowerShell upgrade and WSMan module installation helpers.

### 30-tofu.sh

OpenTofu and Terraform configuration management.



<!-- END_SH_DOCS -->

# Git branch cleanup

`gfap` fetches all remotes and prunes stale remote-tracking refs, then asks
whether to force-delete each local branch whose configured upstream ref is
missing locally. This includes squash-merged branches, but a missing upstream
does not guarantee that the remote branch was deleted or that local commits
were merged. Review each branch before confirming; Git will refuse to delete a
branch checked out in a worktree.

