# ------------------------------
# aliases 
# ------------------------------

# git


alias gci="git commit -v"

# log
alias gshl="git log --pretty=oneline --abbrev-commit"

# difftastic
alias gdl="git -c diff.external=difft log -p --ext-diff"
alias gds="git -c diff.external=difft show --ext-diff"
alias gds="git dft = -c diff.external=difft diff"

# remote
alias gclone='git clone'


# end git

# Github Copilot 
alias gpilot="gh copilot"
alias ghs="ghs copilot suggest"
alias ghe="ghe copilot explain"

# Node
alias nr="npm run"
alias nrd="npm run dev"
alias nrw="npm run watch"
alias nrb="npm run build"
alias nrs="npm run start"
alias nrt="npm run test"
alias nrl="npm run lint"

# Laravel
# alias sail='[ -f sail ] && sh sail || sh vendor/bin/sail'
alias sail='sh $([ -f sail ] && echo sail || echo vendor/bin/sail)'
alias saup="sail up -d"
alias sado="sail down"
alias sart="sail artisan"
alias saop="sail artisan optimize"
alias samf="sail artisan migrate:fresh"
alias sacc="sail artisan cache:clear && sail artisan view:clear && sail artisan route:clear"
alias tinker="sail artisan tinker"


# Ruby
alias irb='irb --simple-prompt'

# Editors
alias vim='nvim'
alias v='nvim'
alias vi='nvim'

alias code="code --profile main"

# Misc
alias open="xdg-open"

alias clear="echo 'clear command is disabled'"

# ------------------------------
# end aliases 
# ------------------------------
