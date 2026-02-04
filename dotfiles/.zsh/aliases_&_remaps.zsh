# ------------------------------
# Aliases
# ------------------------------

# Ruby
alias irb='irb --simple-prompt'

# K8s
alias k='kubectl'

# IDEs
alias code="code --profile main"

# Misc
alias open="xdg-open"
alias gs="git status"

# ------------------------------
# Remaps
# ------------------------------

bindkey -s '^n' '^unvim .\n'
bindkey -s '^p' '^uconnect_vpn\n'

# bindkey -s '^h' '^u. hop_to_worktree\n'
# bindkey -s '^k' '^u. create_worktree\n'

# bindkey -s '^m' '^u. create_new_branch_in_worktree\n'
# bindkey -s '^k' '^u detach_to_commit_in_worktree\n'

# bindkey -s '^a' '^ugit add .\n'
# bindkey -s '^s' '^ugit status\n'
