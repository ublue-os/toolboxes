# shellcheck shell=sh
if [ -z "$PROFILESOURCED" ] && [ "$PS1" ]; then
  PROFILESOURCED="Y"
fi
