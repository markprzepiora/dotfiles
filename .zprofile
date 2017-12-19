# Load chruby if we have it.
if [[ -e /usr/local/share/chruby ]]; then
  source /usr/local/share/chruby/chruby.sh
  source /usr/local/share/chruby/auto.sh
fi

# Make our ~/bin directory override everything else
export PATH="$HOME/bin":"$PATH"
