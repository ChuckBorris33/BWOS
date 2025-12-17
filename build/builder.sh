#!/usr/bin/env bash
set -eoux pipefail

###############################################################################
# Builder Script: Runs all numbered build scripts in order
###############################################################################
# - Executes all executable scripts in this directory matching the pattern
#   [0-9][0-9]*.sh, in ascending order.
# - Skips scripts with the .disabled extension or that are not executable.
###############################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

find "$SCRIPT_DIR" \
    -maxdepth 1 \
    -type f \
    -regextype posix-egrep \
    -regex '.*/[0-9][0-9]+.*\.sh$' \
    ! -name '*.disabled' \
    -print0 \
| sort -z \
| while IFS= read -r -d '' script; do
    if [[ -x "$script" ]]; then
        echo "==> Running $(basename "$script")"
        "$script"
    else
        echo "==> Skipping $(basename "$script") (not executable)"
    fi
done
