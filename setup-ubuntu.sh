#!/usr/bin/env bash

set -eu
set -o pipefail

readonly ARGS="$@"
readonly RELLONGPROGNAME="$(type $0 | awk '{print $3}')"
readonly LONGPROGNAME=$(perl -m'Cwd' -e 'print Cwd::abs_path(@ARGV[0])' "$RELLONGPROGNAME")
readonly PROGDIR="${LONGPROGNAME%/*}"     # get directory component (remove short match)
readonly PROGNAME="${LONGPROGNAME##*/}"   # get basename component (remove long match)

( set -x

  # Make sure full vim is installed,
  # as well as zsh
  # as well as ag
  sudo apt install -y vim vim-nox zsh silversearcher-ag
)

"$PROGDIR"/setup-generic.sh

echo "Dependencies installed"
