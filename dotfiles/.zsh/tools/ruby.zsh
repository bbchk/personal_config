# Ruby config 
# ------------------------------

eval "$(rbenv init -)"

# Load RVM if available
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
  source "$HOME/.rvm/scripts/rvm"
fi

# Update PATH to include Ruby gems and RVM binaries
export PATH="$HOME/.local/share/gem/ruby/3.2.0/bin:$PATH:$HOME/.rvm/bin"

# ------------------------------
# End Ruby config 
# ------------------------------
