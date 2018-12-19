# From the zsh docs:
#
# `.zshenv' is sourced on all invocations of the shell, unless the -f option is
# set. It should contain commands to set the command search path, plus other
# important environment variables. `.zshenv' should not contain commands that
# produce output or assume the shell is attached to a tty.

# Add dotfiles executables
PATH="$PATH:$HOME/dotfiles/bin"

# Add globally-installed npm binaries to path
PATH="$PATH:$HOME/.npm_global/bin"

# Enable linuxbrew if present
test -d ~/.linuxbrew && \
  PATH="$HOME/.linuxbrew/bin:$HOME/.linuxbrew/sbin:$PATH"
test -d /home/linuxbrew/.linuxbrew && \
  PATH="/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH"

# Enable chruby if present
test -r /usr/local/share/chruby/chruby.sh && \
  source /usr/local/share/chruby/chruby.sh
test -r /usr/local/share/chruby/auto.sh && \
  source /usr/local/share/chruby/auto.sh

# Add ~/bin and ~/Dropbox/bin to PATH
PATH="$PATH":~/bin:~/Dropbox/bin

# Add rust/cargo dir
PATH="$PATH":~/.cargo/bin

# Load personalized zshenv file if it exists.
[[ -e "$HOME/.zshenv_private" ]] && source "$HOME/.zshenv_private"
