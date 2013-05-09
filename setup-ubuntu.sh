#!/bin/bash

set -e

# Make sure full vim is installed
sudo apt-get install vim vim-nox

# Ensure system ruby 1.8 is installed
sudo apt-get install ruby rubygems rake

# Ensure submodules are loaded
git submodule init
git submodule update

# Use system ruby to compile command-t, if rvm is installed
if [ "`which rvm`" != "" ]; then
  echo "You appear to be using RVM. Running 'rvm use system'."
  rvm use system
fi

# Compile command-t using system Ruby 1.8
cd ~/.vim/bundle/command-t/ruby/command-t 
ruby1.8 extconf.rb
make

echo "Done"
