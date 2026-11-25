#!/usr/bin/env bash

#
# Update shell configuration documentation from source files using shdoc.
#
# This script:
# 1. Clones or updates the shdoc repository if needed
# 2. Validates the shdoc revision matches expectations
# 3. Generates documentation for bash and zsh rc.d files
# 4. Updates README files with generated docs between marker comments
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
SHDOC_DIR="${PROJECT_DIR}/.devbox/shdoc"
SHDOC_REVISION="b3436134f08428f8bbe2e54bc4dc20da85cd300b"
SHDOC_VERSION="v1.4"
SHDOC_REPO="https://github.com/reconquest/shdoc.git"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

#
# Log messages to stderr
#
log_error() {
  echo -e "${RED}error:${NC} $*" >&2
}

log_success() {
  echo -e "${GREEN}✓${NC} $*" >&2
}

log_info() {
  echo -e "${YELLOW}»${NC} $*" >&2
}

#
# Ensure shdoc is cloned and at the correct revision
#
setup_shdoc() {
  if [[ ! -d "$SHDOC_DIR" ]]; then
    log_info "Cloning shdoc ${SHDOC_VERSION}..."
    if ! git clone --depth 1 --branch "$SHDOC_VERSION" "$SHDOC_REPO" "$SHDOC_DIR"; then
      log_error "Failed to clone shdoc repository"
      return 1
    fi
  else
    log_info "shdoc directory exists, checking revision..."
  fi

  local current_revision
  current_revision=$(git -C "$SHDOC_DIR" rev-parse --verify HEAD) || {
    log_error "Failed to get shdoc revision"
    return 1
  }

  if [[ "$current_revision" != "$SHDOC_REVISION" ]]; then
    log_error "shdoc is not at expected revision"
    log_info "Expected: $SHDOC_REVISION"
    log_info "Got:      $current_revision"
    return 1
  fi

  log_success "shdoc ${SHDOC_VERSION} is ready"
}

#
# Extract the file-level docstring from a shell script
#
# Arguments:
#   $1: Path to shell script
#
# Outputs: The docstring content (file description)
#
extract_file_docstring() {
  local script_file="$1"
  
  # Extract lines between the shebang and first non-comment line
  # that starts with # and is not #+++ or similar decorations
  gawk '
    NR == 1 { next }  # Skip shebang
    /^#/ {
      # Skip decorator lines like #+++ and empty comment lines
      if ($0 !~ /^#+[+=-]/ && $0 !~ /^#[[:space:]]*$/) {
        # Remove leading # and spaces, collect as description
        gsub(/^#[[:space:]]*/, "")
        if (NF > 0) print
      }
    }
    /^[^#]/ { exit }  # Stop at first non-comment line
  ' "$script_file"
}

#
# Update documentation in a file between BEGIN_SH_DOCS and END_SH_DOCS markers
#
# Arguments:
#   $1: Path to README file to update
#   $2: Generated documentation content
#
update_readme_docs() {
  local readme_path="$1"
  local generated_docs="$2"

  if [[ ! -f "$readme_path" ]]; then
    log_error "README not found: $readme_path"
    return 1
  fi

  # Create temporary files
  local temp_in temp_out
  temp_in=$(mktemp) || {
    log_error "Failed to create temporary file"
    return 1
  }
  temp_out=$(mktemp) || {
    rm -f "$temp_in"
    log_error "Failed to create temporary file"
    return 1
  }

  # Copy generated docs to temp file for safe sed usage
  echo "$generated_docs" > "$temp_in"

  # Use awk to do the replacement properly
  if awk -v docfile="$temp_in" '
    BEGIN { 
      while ((getline line < docfile) > 0) {
        docs = docs line "\n"
      }
      close(docfile)
    }
    /<!-- BEGIN_SH_DOCS -->/ {
      print $0
      print docs
      in_section = 1
      next
    }
    /<!-- END_SH_DOCS -->/ {
      in_section = 0
      print $0
      next
    }
    !in_section { print }
  ' "$readme_path" > "$temp_out"; then
    mv "$temp_out" "$readme_path"
    rm -f "$temp_in"
    log_success "Updated $readme_path"
  else
    rm -f "$temp_in" "$temp_out"
    log_error "Failed to update $readme_path"
    return 1
  fi
}

#
# Generate documentation for a directory of shell scripts
#
# Arguments:
#   $1: Path to rc.d directory (e.g., bash/.bashrc.d)
#   $2: Path to README file to update
#
generate_docs_for_shell() {
  local rc_dir="$1"
  local readme_path="$2"
  local shell_name
  shell_name=$(basename "$(dirname "$rc_dir")")

  log_info "Generating documentation for $shell_name..."

  if [[ ! -d "$rc_dir" ]]; then
    log_error "$shell_name rc.d directory not found: $rc_dir"
    return 1
  fi

  # Collect documentation from all scripts in sorted order
  local all_docs=""
  local script_count=0

  # Read all shell scripts in sorted order
  while IFS= read -r script_file; do
    if [[ -f "$script_file" ]]; then
      local script_name
      script_name=$(basename "$script_file")
      log_info "  processing $script_name..."

      # Extract the file-level docstring
      local doc_output
      doc_output=$(extract_file_docstring "$script_file")

      if [[ -n "$doc_output" ]]; then
        all_docs+="### $script_name"$'\n\n'
        all_docs+="$doc_output"$'\n\n'
        ((script_count++))
      fi
    fi
  done < <(find "$rc_dir" -maxdepth 1 \( -name "*.sh" -o -name "*.zsh" \) | sort)

  if [[ $script_count -eq 0 ]]; then
    log_error "No shell scripts found in $rc_dir"
    return 1
  fi

  update_readme_docs "$readme_path" "$all_docs"
}

#
# Main entry point
#
main() {
  cd "$PROJECT_DIR" || {
    log_error "Failed to change to project directory: $PROJECT_DIR"
    return 1
  }

  log_info "Updating shell configuration documentation..."

  # Setup shdoc
  if ! setup_shdoc; then
    log_error "Failed to set up shdoc"
    return 1
  fi

  # Generate and update docs for bash
  if ! generate_docs_for_shell "bash/.bashrc.d" "bash/README.md"; then
    log_error "Failed to generate bash documentation"
    return 1
  fi

  # Generate and update docs for zsh
  if ! generate_docs_for_shell "zsh/.zshrc.d" "zsh/README.md"; then
    log_error "Failed to generate zsh documentation"
    return 1
  fi

  log_success "Documentation updated successfully"
}

main "$@"


