# From the zsh docs:
#
# `.zshrc' is sourced in interactive shells. It should contain commands to set
# up aliases, functions, options, key bindings, etc.

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Shorter history plox
HISTSIZE=5000
SAVEHIST=5000

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"
DISABLE_AUTO_UPDATE="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/

# super dirty OS check so we don't have to execute uname
if [ -e /Library ]; then
  plugins=(git ruby osx sublime sudo web-search dirhistory dircycle autojump)
else
  plugins=(git ruby sublime sudo web-search dirhistory dircycle autojump)
fi

# In WSL, disable BG_NICE because it fails with errors
if [ -e /mnt/c ]; then
  unsetopt BG_NICE
fi

source $ZSH/oh-my-zsh.sh

# !@^&**#*@^&% autopushd and autocorrect
unsetopt autopushd
unsetopt correct_all

PROMPT='%{$fg_bold[blue]%}%n%{$fg_bold[blue]%}@%{$fg_bold[blue]%}%m:%{$fg_bold[green]%}%p%{$fg[cyan]%}${PWD/#$HOME/~} %{$fg_bold[red]%}$(git_prompt_info)%{$fg_bold[red]%}
%{$fg_bold[blue]%}◈ %{$reset_color%}'

# C-x e to edit the current line in the editor
autoload edit-command-line
zle -N edit-command-line
bindkey '^X^e' edit-command-line

# Highlight Ctrl+R (isearch)
zle_highlight=(
  region:standout
  special:standout
  suffix:bold
  isearch:fg=blue,standout
  paste:standout
)

function extract_numbers() {
  cat "$@" | grep -Eo '(\d+(\.\d+)?)'
}

function add() {
  cat "$@" | extract_numbers | grep -E '^\s*(\d+(\.\d+)?)\s*$' | paste -sd '+' - | bc
}

# The two settings below taken from
# http://chneukirchen.org/blog/archive/2013/03/10-fresh-zsh-tricks-you-may-not-know.html

# Use M-= to delete backwards in a flag-friendly way. Example:
# $ git push origin master --force
# Above, M-del would delete only to --.
# M-= will delete to the space.
function _backward_kill_default_word() {
  WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>' zle backward-kill-word
}
zle -N backward-kill-default-word _backward_kill_default_word
bindkey '\e=' backward-kill-default-word   # = is next to backspace

# Interactive move.
# Example: imv "some long filename that's annoying to move manually"
imv() {
  local src dst
  for src; do
    [[ -e $src ]] || { print -u2 "$src does not exist"; continue }
    dst=$src
    vared dst
    [[ $src != $dst ]] && mkdir -p $dst:h && mv -n $src $dst
  done
}

try_until() {
  while ! "$@"; do
    sleep 1
  done
}

# Use Selecta to interactively select a branch to check out.
alias cbranch='git branch | cut -c 3- | selecta | xargs git checkout'

# An ISO8601-esque timestamp in the format 2016-01-10_10-53-17, usable in filenames!
alias timestamp='date +"%Y-%m-%d_%H-%M-%S"'

# An alias to download YouTube videos with the best quality audio and video
alias youtube-dl-mp4='youtube-dl -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"'
alias youtube-dl-mp3='youtube-dl -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" -x --audio-format mp3'

# Fast traceroute by default
alias traceroute='traceroute -q1 -w1'

# e.g. 2018-04-17
alias today='date +%Y-%m-%d'
alias now='date +%Y-%m-%d--%H-%M-%S'

# Check out a remote branch and rebase it on top of master.
checkout_remote() {
  local master=${2:-master}
  git checkout $master &&
  git pull --ff-only &&
  git fetch origin &&
  git branch -f "$1" "origin/$1" &&
  git checkout "$1" &&
  git rebase $master --autostash --preserve-merge
}

checkout_remote_merge() {
  local master=${2:-master}
  git checkout $master &&
  git pull --ff-only &&
  git fetch origin &&
  git branch -f "$1" "origin/$1" &&
  git checkout "$1" &&
  git merge $master
}

# Merge the current branch into master or the given branch.
merge_current() {
  local master=${1:-master}
  local current_branch=$(git rev-parse --abbrev-ref HEAD)
  git checkout "$master" &&
  git pull --ff-only &&
  git checkout "$current_branch" &&
  git rebase --autostash "$master" &&
  git checkout "$master" &&
  git merge --no-ff "$current_branch"
}

git-modified() {
  git status --short | grep -E '^( M| M )' | cut -c4-
}

test -e ${HOME}/.iterm2_shell_integration.zsh && source ${HOME}/.iterm2_shell_integration.zsh

# Load personalized zshrc files if they exist.
[[ -e "$HOME/.zshrc_private" ]] && source "$HOME/.zshrc_private"
