#!/usr/bin/env bash

set -eu
set -o pipefail

vi +PlugUpdate +PlugClean +qall

echo "Vim plugins installed"
