# From the zsh docs:
#
# `.zshenv' is sourced on all invocations of the shell, unless the -f option is
# set. It should contain commands to set the command search path, plus other
# important environment variables. `.zshenv' should not contain commands that
# produce output or assume the shell is attached to a tty.

# Load personalized zshenv file if it exists.
[[ -e "$HOME/.zshenv_private" ]] && source "$HOME/.zshenv_private"

# Load RVM if we have it.
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Load autojump if homebrew is installed.
[ -n "`command -v brew`" -a -s `brew --prefix`/etc/autojump.sh ] && . `brew --prefix`/etc/autojump.sh
