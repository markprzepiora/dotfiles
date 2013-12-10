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

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git rails ruby)

source $ZSH/oh-my-zsh.sh

# !@^&**#*@^&% autopushd and autocorrect
unsetopt autopushd
unsetopt correct_all

PROMPT='%{$fg_bold[red]%}╭─%n@%m:%{$fg_bold[green]%}%p%{$fg[cyan]%}${PWD/#$HOME/~} %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%}
%{$fg_bold[red]%}╰─→ %{$reset_color%}'

# C-x e to edit the current line in the editor
autoload edit-command-line
zle -N edit-command-line
bindkey '^X^e' edit-command-line

# Load personalized zshrc files if they exist.
[[ -e "$HOME/.zshrc_private" ]] && source "$HOME/.zshrc_private"
