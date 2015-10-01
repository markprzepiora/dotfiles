# Load rbenv if we have it.
[[ -e "$HOME/.rbenv" ]] && export PATH="$HOME/.rbenv/bin:$PATH" && eval "$(rbenv init -)"

# Make our ~/bin directory override everything else
export PATH="$HOME/bin":"$PATH"
