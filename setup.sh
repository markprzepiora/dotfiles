#!/usr/bin/env bash

set -eu
set -o pipefail

# Generate absolute path from relative path.
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

# $1 : (required) the package name
# $2 : (optional) the executable to test first
has_apt_package() {
    has_package "dpkg-query -W" "$1" "$2"
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

# Example usage:
#
#     ensure_apt_packages_installed "the_silver_searcher ag" "mysql mysql" "jq jq"
#
# Each first string is the package name, the second is the executable to test
# first before running expensive  commands.
ensure_apt_packages_installed() {
    local to_install=""
    for package_and_executable in "$@"; do
        if ! has_apt_package $package_and_executable; then
            local to_install="$to_install ${package_and_executable% *}"
        fi
    done

    if [ ! -z "$to_install" ]; then
        echo "Installing packages: $to_install"
        sudo apt install -y $to_install
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
        if ! has_executable brew; then
          /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
        fi

        ensure_homebrew_packages_installed \
          "git /usr/local/bin/git" \
          "vim /usr/local/bin/vim" \
          "zsh /usr/local/bin/zsh" \
          "ag ag" \
          "ripgrep /usr/local/bin/rg"
        ;;

    ubuntu)
        sudo apt update
        sudo apt install -y git vim vim-nox zsh silversearcher-ag
        ;;

    *)
        echo "WARNING: I don't know how to install packages on your operating system." 1>&2
        echo "If you are missing some dependencies you will need to install them yourself." 1>&2

        require_executable git
        require_executable vim
        require_executable zsh
        require_executable ag
        ;;
esac

set -x

# Clone repo if it does not exist
if [ ! -d "$HOME/dotfiles" ]; then
  ( cd ~ && git clone https://github.com/markprzepiora/dotfiles.git )
fi

cd ~/dotfiles

# Make sure we have the latest dotfiles
git pull --ff-only

# Make sure oh-my-zsh is loaded
git submodule init
git submodule update

# In WSL, these directories get pulled in with global-writteable permissions
# sometimes, causing oh-my-zsh to complain.
find .oh-my-zsh -type d -print0 | xargs -0 chmod 755

# Create links to all the directories and files
./link-all.sh

# Install vim plugins
./vundle.sh

set +x

# Tell the user to setup zsh as default shell
echo "Done! If you wish to enable zsh as your defualt shell, please run the following:"
echo "  chsh -s `which zsh`"
echo "Otherwise, you may give it a test run simply by running 'zsh' from the terminal."
