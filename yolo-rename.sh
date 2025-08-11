#!/usr/bin/env bash
set -euo pipefail

VERSION="0.1.0"

usage(){
  cat <<EOF
yolo-rename $VERSION
rename files and folders recursively to cursed names.

Usage:
  yolo-rename <folder> [--dry-run] [--max-depth N]

Options:
  -h, --help      Show this help
  -v, --version   Show version
  --dry-run       Print actions without renaming
  --max-depth N   Limit recursion depth (1 = no subfolders)
EOF
}

random_string() {
  local min_len=$1 max_len=$2
  (( max_len >= min_len && min_len >= 1 )) || { echo "INVALID RANGE" >&2; exit 2; }
  local length=$((RANDOM % (max_len - min_len + 1) + min_len))
  tr -dc 'a-z0-9' < /dev/urandom | head -c "$length"
  echo
}

dry_run=false
max_depth=""
folder=""

while (( $# > 0 )); do
  case "${1-}" in
    -h|--help) usage; exit 0;;
    -v|--version) echo "yolo-rename $VERSION"; exit 0;;
    --dry-run) dry_run=true; shift;;
    --max-depth)
      [[ $# -ge 2 ]] || { echo "ERROR: --max-depth needs a number" >&2; exit 1; }
      [[ "$2" =~ ^[0-9]+$ ]] || { echo "ERROR: --max-depth must be integer" >&2; exit 1; }
      max_depth="$2"; shift 2;;
    -*)
      echo "ERROR: unknown option '$1'" >&2; usage; exit 1;;
    *)
      if [[ -z "$folder" ]]; then folder="$1"; shift; else
        echo "ERROR: multiple folders specified" >&2; usage; exit 1
      fi;;
  esac
done

[[ -n "${folder:-}" ]] || { echo "ERROR: missing <folder>" >&2; usage; exit 1; }
[[ -d "$folder" ]] || { echo "ERROR: folder does not exist: $folder" >&2; exit 1; }
folder="$(realpath "$folder")"

cmd=(find "$folder" -depth)
if [[ -n "$max_depth" ]]; then
  cmd=(find "$folder" -maxdepth "$max_depth" -depth)
fi

is_root() { [[ "$1" == "$folder" ]]; }

"${cmd[@]}" \( -type f -o -type d \) -print0 | while IFS= read -r -d '' path; do
  is_root "$path" && continue
  dir="$(dirname "$path")"
  base="$(basename "$path")"

  if [[ -f "$path" ]]; then
    new_ending="$(random_string 2 3)"

    tries=0
    while :; do
      new_base="$(random_string 5 15)"
      target="$dir/$new_base.$new_ending"
      [[ ! -e "$target" ]] && break
      ((tries++)); ((tries>20)) && { echo "ERROR: collisions for $path" >&2; exit 3; }
    done

    if $dry_run; then
      echo "[DRY] file : $path -> $target"
    else
      mv -- "$path" "$target"
      echo "Renamed file : $base -> $(basename "$target")"
    fi

  elif [[ -d "$path" ]]; then
    tries=0
    while :; do
      new_base="$(random_string 5 15)"
      target="$dir/$new_base"
      [[ ! -e "$target" ]] && break
      ((tries++)); ((tries>20)) && { echo "ERROR: collisions for dir $path" >&2; exit 3; }
    done

    if $dry_run; then
      echo "[DRY] dir  : $path -> $target"
    else
      mv -- "$path" "$target"
      echo "Renamed dir  : $base -> $(basename "$target")"
    fi
  fi
done
