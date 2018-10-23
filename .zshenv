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

# Load personalized zshenv file if it exists.
[[ -e "$HOME/.zshenv_private" ]] && source "$HOME/.zshenv_private"

# Load autojump if homebrew is installed.
(command -v brew > /dev/null 2>&1) &&
test -s "$(brew --prefix)/etc/autojump.sh" &&
. "$(brew --prefix)/etc/autojump.sh"
