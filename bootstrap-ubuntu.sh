#!/bin/bash

# Stop on errors
set -e

# Clone repo if it does not exist
if [ ! -d "$HOME/dotfiles" ]; then
  cd ~ && git clone https://github.com/markprzepiora/dotfiles.git
fi

# Chdir to it
cd ~/dotfiles

# Link files
./link-all.sh

# Install apt-get packages, update submodules, and compile Command-T
./setup-ubuntu.sh

# Setup zsh as default shell
echo "Done! If you wish to enable zsh as your defualt shell, please run the following:"
echo "  chsh -s `which zsh`"
echo "Otherwise, you may give it a test run simply by running 'zsh' from the terminal."