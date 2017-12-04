#!/usr/bin/env bash

set -eu
set -o pipefail

# Generate absolute path from relative path. Portable! Requires only  and
# /Users/mark/dotfiles, unlike solutions that use readlink, etc.
#
# $1     : relative filename
# output : absolute path
abspath() {
    if [ -d "$1" ]; then
        (cd "$1"; pwd)
    elif [ -f "$1" ]; then
        if [[ $1 = /* ]]; then
            echo "$1"
        elif [[ $1 == */* ]]; then
            echo "$(cd "${1%/*}"; pwd)/${1##*/}"
        else
            echo "$(pwd)/$1"
        fi
    fi
}

# $1 : (required) the executable required
has_executable() {
    command -v "$1" >/dev/null 2>&1
}

# $1 : (required) the name of the executable
# $2 : (optional) the error message to print if not present
require_executable() {
    ( set +ux; set -e

      local name="$1"
      local error_message="$2"

      if [ -z "$error_message" ]; then
          local error_message="ERROR: You do not have $name installed."
      fi

      if ! has_executable "$name"; then
          echo "$error_message" >&2
          exit 1
      fi
    )
}

# $1 : (required) the command to check if a package is installed
# $2 : (required) the package name
# $3 : (optional) the executable to test first
has_package() {
    (   set +u
        local test_command="$1"
        local package_name="$2"
        local executable="$3"

        if [ ! -z "$executable" ]; then
            has_executable "$executable"
        else
            "$test_command" "$package_name" > /dev/null 2>&1
        fi
    )
}

# $1 : (required) the package name
# $2 : (optional) the executable to test first
has_homebrew_package() {
    has_package "brew list" "$1" "$2"
}

# Example usage:
#
#     ensure_homebrew_packages_installed "the_silver_searcher ag" "mysql mysql" "jq jq"
#
# Each first string is the package name, the second is the executable to test
# first before running expensive  commands.
ensure_homebrew_packages_installed() {
    local to_install=""
    for package_and_executable in "$@"; do
        if ! has_homebrew_package $package_and_executable; then
            local to_install="$to_install ${package_and_executable% *}"
        fi
    done

    if [ ! -z "$to_install" ]; then
        echo "Installing packages: $to_install"
        brew install $to_install
    fi
}

operating_system() {
  local uname=$(uname)
  if [ "$uname" = Darwin ]; then echo osx; return; fi
  if [ ! -f /etc/os-release ]; then echo unknown; return; fi

  local name_line=$(cat /etc/os-release | grep ^NAME=)
  if [ "$name_line" = 'NAME="Ubuntu"' ]; then echo ubuntu; return; fi

  echo unknown
}

readonly ARGS="$@"
readonly LONGPROGNAME=$(abspath "$0")
readonly PROGDIR="${LONGPROGNAME%/*}"     # get directory component (remove short match)
readonly PROGNAME="${LONGPROGNAME##*/}"   # get basename component (remove long match)

case $(operating_system) in
    osx)
        ensure_homebrew_packages_installed "gnu-tar gtar"
        TAR=gtar
        ;;

    *)
        TAR=tar
        ;;
esac

# Define files to copy
FILES=".vim .vimrc .gitconfig .githelpers .tmux.conf .zshrc .zshenv .oh-my-zsh .zprofile .irbrc"

# Backup existing dotfiles
mkdir -p ~/backups
$TAR --ignore-failed-read -C ~/ -zcf ~/backups/dotfiles-`date +%Y-%m-%d--%T`.tar.gz $FILES

# Delete existing dotfiles
(cd ~ && rm -rf $FILES)

for file in $FILES; do
  ln -s "$PROGDIR"/"$file" ~/
done
