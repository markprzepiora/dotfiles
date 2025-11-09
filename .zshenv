# From the zsh docs:
#
# `.zshenv' is sourced on all invocations of the shell, unless the -f option is
# set. It should contain commands to set the command search path, plus other
# important environment variables. `.zshenv' should not contain commands that
# produce output or assume the shell is attached to a tty.

XDG_CACHE_HOME="${HOME}/.cache"

# Add dotfiles executables
PATH="$PATH:$HOME/dotfiles/bin"

# Add x86_64 dotfiles binaries to path
if [[ $(uname -sp) =~ x86_64 ]]; then
  PATH="$PATH:$HOME/dotfiles/bin/linux"
fi

# Add globally-installed npm binaries to path
PATH="$PATH:$HOME/.npm_global/bin"

# Enable linuxbrew if present
if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [ -f ~/.linuxbrew/bin/brew ]; then
  eval "$(~/.linuxbrew/bin/brew shellenv)"
fi

# Add ~/bin and ~/Dropbox/bin and ~/.local/bin to PATH
PATH="$PATH":~/bin:~/Dropbox/bin:~/.local/bin

# Add rust/cargo dir
PATH="$PATH":~/.cargo/bin

# Add snap bin dir
PATH="$PATH":/snap/bin

# Add omarchy bin directory to path if it exists
[[ -d ~/.local/share/omarchy/bin ]] && PATH="$PATH":~/.local/share/omarchy/bin

# Load personalized zshenv file if it exists.
[[ -e "$HOME/.zshenv_private" ]] && source "$HOME/.zshenv_private"
