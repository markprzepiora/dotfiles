#!/bin/bash

# Stop on errors
set -e

# Clone repo
cd ~ && git clone https://github.com/markprzepiora/dotfiles.git
cd ~/dotfiles

# Link files
./link-all.sh

# Install apt-get packages, update submodules, and compile Command-T
./setup-ubuntu.sh

# Setup zsh as default shell
chsh -s `which zsh`

echo "Should be ready to go!"
