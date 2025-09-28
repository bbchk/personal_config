# Source configuration files
for config_file in ~/.zsh/*.zsh; do
  source "$config_file"
done

# Function to run on Kitty startup only
# kitty_startup_hook() {
#     if [[ "$TERM" == "xterm-kitty" && -z "$KITTY_STARTUP_DONE" ]]; then
#         export KITTY_STARTUP_DONE=1
#         "$HOME/pers/scripts/tmux-sessionizer"
#     fi
# }
#
# # Run the hook when zsh starts
# kitty_startup_hook

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=("$HOME/.juliaup/bin" $path)
export PATH

# <<< juliaup initialize <<<

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
