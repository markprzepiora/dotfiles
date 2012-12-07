#!/bin/bash

set -e

# Make sure full vim is installed
sudo apt-get install vim vim-nox

# Ensure system ruby is installed
sudo apt-get install ruby rubygems rake

# Use system ruby to compile command-t, if rvm is installed
if [ "`type rvm`" != "" ]; then
  echo "You appear to be using RVM. Running 'rvm use system'."
  rvm use system
fi

# Compile command-t
cd ~/.vim/bundle/command-t/ruby/command-t && rake make

echo "Done"
