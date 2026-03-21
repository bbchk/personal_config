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
bindkey -s '^p' '^uconnect_vpn.sh\n'

# bindkey -s '^h' '^u. hop_to_worktree\n'
# bindkey -s '^k' '^u. create_worktree\n'

# bindkey -s '^m' '^u. create_new_branch_in_worktree\n'
# bindkey -s '^k' '^u detach_to_commit_in_worktree\n'

# bindkey -s '^a' '^ugit add .\n'
# bindkey -s '^s' '^ugit status\n'
#
alias nvim="nvim --server $NVIM --remote-tab"

# # sudoedit with nvr when inside Neovim, plain nvim otherwise
# se() {
#   local socket="${NVIM:-}"
#   if [[ -z "$socket" ]]; then
#     socket=$(nvr --serverlist 2>/dev/null | head -n1)
#   fi
#   if [[ -n "$socket" ]]; then
#     SUDO_EDITOR="nvr --servername $socket --remote-wait-silent +'set bufhidden=wipe'" sudoedit "$@"
#   else
#     SUDO_EDITOR=nvim sudoedit "$@"
#   fi
# }
