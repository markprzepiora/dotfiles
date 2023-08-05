#!/usr/bin/env bash

set -eu
set -o pipefail

readonly PROGDIR=$(cd "${0%/*}" && pwd)

has_executable() {
    command -v "$1" >/dev/null 2>&1
}

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

has_homebrew_package() {
    has_package "brew list" "$1" "$2"
}

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
FILES=".vim .vimrc .gitconfig .githelpers .tmux.conf .zshrc .zshenv .oh-my-zsh .zprofile .irbrc .psqlrc .npmrc .dir_colors .direnvrc .pryrc .ExifTool_config .config/nvim/init.vim"

# Backup existing dotfiles
mkdir -p ~/backups
$TAR --ignore-failed-read -C ~/ -zcf ~/backups/dotfiles-`date +%Y-%m-%d--%T`.tar.gz $FILES

# Delete existing dotfiles
(cd ~ && rm -rf $FILES)

# Link new dotfiles
for file in $FILES; do
  ln -s "$PROGDIR"/"$file" ~/"$file"
done
