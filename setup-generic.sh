#!/usr/bin/env bash

set -eu
set -o pipefail

readonly ARGS="$@"
readonly RELLONGPROGNAME="$(type $0 | awk '{print $3}')"
readonly LONGPROGNAME=$(perl -m'Cwd' -e 'print Cwd::abs_path(@ARGV[0])' "$RELLONGPROGNAME")
readonly PROGDIR="${LONGPROGNAME%/*}"     # get directory component (remove short match)
readonly PROGNAME="${LONGPROGNAME##*/}"   # get basename component (remove long match)

# Ensure submodules are loaded
( set -x
  git submodule init
  git submodule update
)

echo "Submodules updated"

"$PROGDIR"/link-all.sh
"$PROGDIR"/vundle.sh
