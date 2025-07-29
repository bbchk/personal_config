# Source configuration files
for config_file in ~/.zsh/*.zsh; do
  source "$config_file"
done

# Function to run on Kitty startup only
kitty_startup_hook() {
    if [[ "$TERM" == "xterm-kitty" && -z "$KITTY_STARTUP_DONE" ]]; then
        export KITTY_STARTUP_DONE=1
        /home/bchk/pers/scripts/tmux-sessionizer
    fi
}

# Run the hook when zsh starts
kitty_startup_hook

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('/home/bchk/.juliaup/bin' $path)
export PATH

# <<< juliaup initialize <<<
