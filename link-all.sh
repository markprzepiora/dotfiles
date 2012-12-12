#!/bin/bash
set -e

# Define files to copy
FILES=".vim .vimrc .gitconfig .githelpers .tmux.conf .zshrc .oh-my-zsh"

# Current directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# On OSX, make sure we use gnutar
if [ "`which gnutar`" != "" ]; then
  TAR="`which gnutar`"
  echo using gnutar
else
  TAR="`which tar`"
  echo using tar
fi

# Backup existing dotfiles
mkdir -p ~/backups
"$TAR" --ignore-failed-read -C ~/ -zcf ~/backups/dotfiles-`date +%Y-%m-%d--%T`.tar.gz $FILES

# Delete existing dotfiles
(cd ~ && rm -rf $FILES)

# Link new dotfiles
echo "$FILES" |
tr ' ' "\n" |
while read file; do
  ln -s "$DIR"/"$file" ~/
done


