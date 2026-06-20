# ------------------------------
# Aliases
# ------------------------------

alias g++='g++ -std=c++23 -Wpedantic -Wall -Weffc++ -Wextra -Wconversion -Wsign-conversion -Werror'

# Ruby
alias irb='irb --simple-prompt'

# K8s
alias k='kubectl'
alias kb='kubie'

# IDEs
alias code="code --profile main"

# Misc
alias open="xdg-open"
alias gs="git status"

alias devcon="devcontainer"

# ------------------------------
# Remaps
# ------------------------------

bindkey -s '^n' '^unvim .\n'
bindkey -s '^p' '^uib_connect_vpn.sh\n'

# bindkey -s '^h' '^u. hop_to_worktree\n'
# bindkey -s '^k' '^u. create_worktree\n'

# bindkey -s '^m' '^u. create_new_branch_in_worktree\n'
# bindkey -s '^k' '^u detach_to_commit_in_worktree\n'

# bindkey -s '^a' '^ugit add .\n'
# bindkey -s '^s' '^ugit status\n'
#
alias nvim="nvim --server $NVIM --remote-tab"
