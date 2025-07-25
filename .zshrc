ZSH_PROFILE=false
if [ "$ZSH_PROFILE" = "true" ]; then
  zmodload zsh/zprof
fi

# From the zsh docs:
#
# `.zshrc' is sourced in interactive shells. It should contain commands to set
# up aliases, functions, options, key bindings, etc.

# Path to your oh-my-zsh configuration.
ZSH="$HOME"/.oh-my-zsh
ZSH_CUSTOM="$HOME"/dotfiles/zsh_custom
ZSH_DISABLE_COMPFIX=true

# Shorter history plox
HISTSIZE=5000
SAVEHIST=5000

# Readable manpages
export MANWIDTH=100

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
plugins=(git)

# MacOS
if [ -e /Library ]; then
  plugins+=(osx)
fi

# WSL
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

source "$ZSH/oh-my-zsh.sh"

# ---------------------------------------------------
# Override ZSH Options
# https://zsh.sourceforge.io/Doc/Release/Options.html
# ---------------------------------------------------

## Changing Directories:
## https://zsh.sourceforge.io/Doc/Release/Options.html#Changing-Directories

unsetopt auto_pushd
unsetopt auto_cd

## Input/Output options:
## https://zsh.sourceforge.io/Doc/Release/Options.html#Input_002fOutput

# (Don't) Try to correct the spelling of commands and arguments.
unsetopt correct
unsetopt correct_all

## Completion options:
## https://zsh.sourceforge.io/Doc/Release/Options.html#Completion-4

# On an ambiguous completion, instead of listing possibilities or beeping,
# insert the first match immediately. Then when completion is requested again,
# remove the first match and insert the second match, etc. When there are no
# more matches, go back to the first one again.
setopt menu_complete

# (Don't) beep on an ambiguous completion.
unsetopt list_beep

## History options:
## https://zsh.sourceforge.io/Doc/Release/Options.html#History

# (Don't) beep when a widget attempts to access a history entry which isn’t there.
unsetopt hist_beep

PROMPT='%{$fg_bold[blue]%}%n%{$fg_bold[blue]%}@%{$fg_bold[blue]%}%m:%{$fg_bold[green]%}%p%{$fg[cyan]%}${PWD/#$HOME/~} %{$fg_bold[red]%}$(git_prompt_info)%{$fg_bold[red]%}
%{$fg_bold[blue]%}❯ %{$reset_color%}'

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

# Launch tmux-sessionizer with ^g
bindkey -s '^g' "^Qtmux-sessionizer^M"

fzf-commands-widget () {
    LBUFFER="${LBUFFER}$(compgen -c | fzf --height=20%)"
    local ret=$?
    zle reset-prompt
    return $ret
}
zle -N fzf-commands-widget
bindkey "^[r" fzf-commands-widget

source ~/dotfiles/zsh_aliases

f() {
    if command -v yazi >/dev/null 2>&1; then
      mkdir -p "${XDG_CACHE_HOME}/yazi"
      yazi "$@" --cwd-file="${XDG_CACHE_HOME}/yazi/.yazi_d"
      cd "$(cat "${XDG_CACHE_HOME}/yazi/.yazi_d")"
    else
      fff "$@"
      cd "$(cat "${XDG_CACHE_HOME}/fff/.fff_d")"
    fi
}

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

# Load mise
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate "$(ps -o comm= -p$$)")"
fi

if [ -f "$HOME/.cargo/env" ]; then
  . "$HOME/.cargo/env"
fi

if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

# Add a newline before every prompt, except the first
PROMPT_NEEDS_NEWLINE=false
precmd() {
  [[ "$PROMPT_NEEDS_NEWLINE" == true ]] && echo
  PROMPT_NEEDS_NEWLINE=true
}
clear() {
  PROMPT_NEEDS_NEWLINE=false
  command clear
}

if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
fi

# Alt+z <char> delete until (not including) the next <char>
zmodload zsh/deltochar
bindkey "\ez" zap-to-char

# Load personalized zshrc files if they exist.
[[ -e "$HOME/.zshrc_private" ]] && source "$HOME/.zshrc_private"

if [ "$ZSH_PROFILE" = "true" ]; then
  zprof
fi
