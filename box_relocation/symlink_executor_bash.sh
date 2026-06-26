#!/usr/bin/env bash
set -euo pipefail

LOCAL_FILE="$1"
BOX_FILE="$2"

# Expand leading ~ in arguments
LOCAL_FILE="${LOCAL_FILE/#\~/$HOME}"
BOX_FILE="${BOX_FILE/#\~/$HOME}"

# Confirm the Box file exists
if [[ ! -f "$BOX_FILE" ]]; then
  echo "ERROR: Box file does not exist:"
  echo "$BOX_FILE"
  exit 1
fi

# If local path is already a symlink, show where it points and stop
if [[ -L "$LOCAL_FILE" ]]; then
  echo "Local path is already a symlink:"
  ls -l "$LOCAL_FILE"
  exit 0
fi

# If local file exists, make sure it is identical to the Box file before replacing
if [[ -f "$LOCAL_FILE" ]]; then
  if ! cmp -s "$LOCAL_FILE" "$BOX_FILE"; then
    echo "ERROR: Local and Box files are not identical. Not replacing."
    exit 1
  fi

  mv "$LOCAL_FILE" "$LOCAL_FILE.local_backup"
  ln -s "$BOX_FILE" "$LOCAL_FILE"
  rm "$LOCAL_FILE.local_backup"

  echo "Done. Replaced local file with symlink:"
  ls -l "$LOCAL_FILE"
  exit 0
fi

# If nothing exists at the local path, create the symlink
if [[ ! -e "$LOCAL_FILE" ]]; then
  ln -s "$BOX_FILE" "$LOCAL_FILE"

  echo "Done. Created symlink:"
  ls -l "$LOCAL_FILE"
  exit 0
fi

# Catch unusual cases, e.g. local path is a directory
echo "ERROR: Something exists at the local path, but it is not a regular file or symlink:"
ls -ld "$LOCAL_FILE"
exit 1