# From the zsh docs:
#
# `.zlogin' is sourced in login shells. It should contain commands that should
# be executed only in login shells. `.zlogout' is sourced when login shells
# exit.  `.zprofile' is similar to `.zlogin', except that it is sourced before
# `.zshrc'.  `.zprofile' is meant as an alternative to `.zlogin' for ksh fans;
# the two are not intended to be used together, although this could certainly
# be done if desired. `.zlogin' is not the place for alias definitions,
# options, environment variable settings, etc.; as a general rule, it should
# not change the shell environment at all. Rather, it should be used to set the
# terminal type and run a series of external commands (fortune, msgs, etc).

# Load chruby if we have it.
if [[ -e /usr/local/share/chruby ]]; then
  source /usr/local/share/chruby/chruby.sh
  source /usr/local/share/chruby/auto.sh
fi

# Make our ~/bin directory override everything else
export PATH="$HOME/bin":"$PATH"
