#!/bin/bash
# clone-tools — clone every MacHelpdesk tool repo into tools/.
#
# tools/ is ignored by this repo: each tool is its own git repository with its own
# history, issues and releases. This script only clones what is missing; it never
# pulls, resets or touches a directory (or symlink) that already exists.
#
# Usage: scripts/clone-tools.sh

set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ORG="MacHelpdesk"

# One tool per line. Add a line when a new tool repo is created.
TOOLS="
mac-printer-setup
mac-dropbox-fix
mac-network-test
mac-trackpad-test
"

mkdir -p "$ROOT/tools" || exit 1
failed=0
for tool in $TOOLS; do
  dest="$ROOT/tools/$tool"
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    echo "exists, left alone: tools/$tool"
    continue
  fi
  if git clone "https://github.com/$ORG/$tool.git" "$dest"; then
    echo "cloned: tools/$tool"
  else
    echo "could not clone $ORG/$tool" >&2
    failed=1
  fi
done
exit "$failed"
