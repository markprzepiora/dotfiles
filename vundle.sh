#!/usr/bin/env bash

set -eu
set -o pipefail

vim +PlugUpdate +PlugClean +qall

echo "Vim plugins installed"
