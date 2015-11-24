# Load chruby if we have it.
if [[ -e /usr/local/share/chruby ]]; then
  source /usr/local/share/chruby/chruby.sh
  source /usr/local/share/chruby/auto.sh

# Otherwise, load rbenv if we have it.
elif [[ -e "$HOME/.rbenv" ]]; then
  export PATH="$HOME/.rbenv/bin:$PATH" && eval "$(rbenv init -)"
fi

# Make our ~/bin directory override everything else
export PATH="$HOME/bin":"$PATH"
