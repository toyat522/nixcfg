#!/bin/bash
set -euo pipefail

native_path=""
IFS=: read -r -a path_entries <<< "$PATH"
for entry in "${path_entries[@]}"; do
  case "$entry" in
    /nix/*|*/.nix-profile/*|*/.local/state/nix/*) continue ;;
  esac
  native_path="${native_path:+$native_path:}$entry"
done
export PATH="${native_path:-/usr/local/bin:/usr/bin:/bin}"

for variable in LD_LIBRARY_PATH PYTHONPATH QT_PLUGIN_PATH QT_QPA_PLATFORM_PLUGIN_PATH QML2_IMPORT_PATH; do
  if [[ ! -v "$variable" ]]; then
    continue
  fi
  filtered=""
  IFS=: read -r -a entries <<< "${!variable}"
  for entry in "${entries[@]}"; do
    case "$entry" in
      /nix/*|*/.nix-profile/*|*/.local/state/nix/*) continue ;;
    esac
    filtered="${filtered:+$filtered:}$entry"
  done
  if [[ -n "$filtered" ]]; then
    export "$variable=$filtered"
  else
    unset "$variable"
  fi
done

exec bazel "$@"
