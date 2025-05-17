if [ "$ZSH_PROFILE" = "true" ]; then
  zmodload zsh/zprof
fi

# From the zsh docs:
#
# `.zshrc' is sourced in interactive shells. It should contain commands to set
# up aliases, functions, options, key bindings, etc.

# Alt+z <char> delete until (not including) the next <char>
zmodload zsh/deltochar
bindkey "\ez" zap-to-char

# Path to your oh-my-zsh configuration.
ZSH="$HOME"/.oh-my-zsh
ZSH_CUSTOM="$HOME"/dotfiles/zsh_custom
ZSH_DISABLE_COMPFIX=true

# Shorter history plox
HISTSIZE=5000
SAVEHIST=5000

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"
DISABLE_AUTO_UPDATE="true"

# Set TERM to 256 color mode, unless we're in tmux. Tmux sets its TERM to
# screen-256color since that fixes some keycode weirdness over SSH, but setting
# the TERM to screen-256color globally does weird things to the local terminal...
if [ -z "$TMUX" ]; then
  # TERM=xterm-256color
fi

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/

plugins=(git fzf)

# In OSX...
if [ -e /Library ]; then
  # Enable the osx plugin
  plugins+=(osx)
fi

# In WSL...
if [ -e /mnt/c ]; then
  # Disable BG_NICE because it fails with errors
  unsetopt BG_NICE

  # Set umask since it's $&#*ed up by default in WSL
  umask 022

  # Add `wcd` command for changing into a Windows directory
  wcd() {
    cd "$(~/Dropbox/bin/windows-to-wsl-path "$1")"
  }

  PATH="$PATH":~/dotfiles/bin/wsl
fi

source $ZSH/oh-my-zsh.sh

# !@^&**#*@^&% autopushd and autocorrect
unsetopt autopushd
unsetopt correct_all

# turn off this awful feature
unsetopt AUTO_CD

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

fpath+=( ~/dotfiles/zsh_functions )
autoload -Uz imv try_until extract_numbers add checkout_remote checkout_remote_merge merge_current findf findd git-checkout-github vim-last-modified update-branch gcob

# The two settings below taken from
# http://chneukirchen.org/blog/archive/2013/03/10-fresh-zsh-tricks-you-may-not-know.html

# Use alt= to delete backwards in a flag-friendly way. Example:
# $ git push origin master --force
# Above, alt-del would delete only to --.
# alt= will delete to the space.
function _backward_kill_default_word() {
  WORDCHARS='*?_-.[]~=/&;!#$%^(){}<>' zle backward-kill-word
}
zle -N backward-kill-default-word _backward_kill_default_word
bindkey '\e=' backward-kill-default-word   # = is next to backspace

# An ISO8601-esque timestamp in the format 2016-01-10_10-53-17, usable in filenames!
alias timestamp='date +"%Y-%m-%d_%H-%M-%S"'

# An alias to download YouTube videos with the best quality audio and video
alias youtube-dl-mp4='youtube-dl -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"'
alias youtube-dl-mp3='youtube-dl -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" -x --audio-format mp3'
alias yt-dlp-mp4='yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best"'
alias yt-dlp-mp3='yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best" -x --audio-format mp3'

# Fast traceroute by default
alias traceroute='traceroute -q1 -w1'

# e.g. 2018-04-17
alias today='date +%Y-%m-%d'
alias now='date +%Y-%m-%d--%H-%M-%S'

# == GIT ALIASES ==
# Use Selecta to interactively select a branch to check out.
alias cbranch='git branch | cut -c 3- | selecta | xargs git checkout'
alias st='git status --short'
# What commits are in the current branch
alias gbc='git branch-commits HEAD develop'
alias p='git pull --ff-only'
alias co='git checkout'
alias gdc='git diff --cached'

# Quick ls, useful for when you're in a directory with a lot of files on e.g. a
# Windows directory in WSL.
alias ql='ls -1 --color=never'

# Use eza for ll and l if it's available
if command -v eza >/dev/null 2>&1; then
  alias ll='eza -l --group-directories-first'
  alias l='eza -la --group-directories-first'
fi

alias tat='tmux at'

# Less annoying pager in psql
PSQL_PAGER="less -iMSx4 -FX"

# Load iterm2 shell integrations if present
test -e ${HOME}/.iterm2_shell_integration.zsh &&
  source ${HOME}/.iterm2_shell_integration.zsh

# Load patched, vendored autojump
source ~/dotfiles/autojump/autojump.zsh

# Load direnv
if [ -f /home/linuxbrew/.linuxbrew/bin/direnv ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/direnv hook zsh)"
elif [ -f /usr/local/bin/direnv ]; then
  eval "$(/usr/local/bin/direnv hook zsh)"
elif [ -f /usr/bin/direnv ]; then
  eval "$(/usr/bin/direnv hook zsh)"
fi

# Enable chruby/auto if present
test -r /usr/local/share/chruby/auto.sh && \
  source /usr/local/share/chruby/auto.sh

# Load asdf if present
export ASDF_DATA_DIR=/home/mark/.asdf
export PATH="$ASDF_DATA_DIR/shims:$PATH"

# Load personalized zshrc files if they exist.
[[ -e "$HOME/.zshrc_private" ]] && source "$HOME/.zshrc_private"

if [ "$ZSH_PROFILE" = "true" ]; then
  zprof
fi

# fnm
FNM_PATH="/home/mark/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi

if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi
