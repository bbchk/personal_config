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

alias nri="npm install"
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

# k8s
# other
alias k='kubectl'

alias kr='k run'

# work on this
export ns="-n secret-ops"
# export droy="-oyaml --dry-run=client"
export kyaml="-oyaml"
export kdrn='--dry-run=client'


alias kap='k apply -f'

alias kl='k logs'
alias kexec='k exec -it'
alias kpf='k port-forward'
alias kaci='k auth can-i' 
alias kat='k attach'
alias kapir='k api-resources'
alias kapiv='k api-versions'

# create
alias kc='k create'

# get
alias kg='k get'
alias kga='k get all'

alias kgns='k get ns'
alias kgp='k get pods'
alias kgs='k get secrets'


alias kgd='k get deploy'

alias kgrs='k get rs'
alias kgss='k get sts'
alias kgds='k get ds'
alias kgcm='k get configmap'
alias kgcj='k get cronjob'
alias kgj='k get job'
alias kgsvc='k get svc -o wide'
alias kgn='k get no -o wide'
alias kgr='k get roles'
alias kgrb='k get rolebindings'
alias kgcr='k get clusterroles'
alias kgrb='k get clusterrolebindings'
alias kgsa='k get sa'
alias kgnp='k get netpol'

# edit
alias ke='k edit'
alias kens='k edit ns'
alias kes='k edit secrets'
alias ked='k edit deploy'
alias kers='k edit rs'
alias kess='k edit sts'
alias keds='k edit ds'
alias kesvc='k edit svc'
alias kecm='k edit cm'
alias kecj='k edit cj'
alias ker='kedit roles'
alias kecr='k edit clusterroles'
alias kerb='k edit clusterrolebindings'
alias kesa='k edit sa'
alias kenp='k edit netpol'

# describe
alias kd='k describe'
alias kdns='k describe ns'
alias kdp='k describe pod'
alias kds='k describe secrets'
alias kdd='k describe deploy'
alias kdrs='k describe rs'
alias kdss='k describe sts'
alias kdds='k describe ds'
alias kdsvc='k describe svc'
alias kdcm='k describe cm'
alias kdcj='k describe cj'
alias kdj='k describe job'
alias kdsa='k describe sa'
alias kdr='k describe roles'
alias kdrb='k describe rolebindings'
alias kdcr='k describe clusterroles'
alias kdcrb='k describe clusterrolebindings'
alias kdnp='k describe netpol'

# delete
alias kdel='k delete'
alias kdelns='k delete ns'
alias kdels='k delete secrets'
alias kdelp='k delete po'
alias kdeld='k delete deployment'
alias kdelrs='k delete rs'
alias kdelss='k delete sts'
alias kdelds='k delete ds'
alias kdelsvc='k delete svc'
alias kdelcm='k delete cm'
alias kdelcj='k delete cj'
alias kdelj='k delete job'
alias kdelr='k delete roles'
alias kdelrb='k delete rolebindings'
alias kdelcr='k delete clusterroles'
alias kdelrb='k delete clusterrolebindings'
alias kdelsa='k delete sa'
alias kdelnp='k delete netpol'

# mock
alias kmock='k create mock -o yaml --dry-run=client'
alias kmockns='k create ns mock -o yaml --dry-run=client'
alias kmockcm='k create cm mock -o yaml --dry-run=client'
alias kmocksa='k create sa mock -o yaml --dry-run=client'

# config
alias kcfg='k config'
alias kcfgv='k config view'
alias kcfgns='k config set-context --current --namespace'
alias kcfgcurrent='k config current-context'
alias kcfggc='k config get-contexts'
alias kcfgsc='k config set-context'
alias kcfguc='k config use-context'
alias kcfgv='k config view'

# Kubescape related
# alias kssbom='k -n kubescape get sbomspdxv2p3s'
# alias kssbomf='k -n kubescape get sbomspdxv2p3filtereds'
# alias kssboms='k -n kubescape get sbomsummaries'
# alias ksvulns='k -n kubescape get vulnerabilitymanifestsummaries'
# alias ksvuln='k -n kubescape get vulnerabilitymanifests'

# Kubescape related with labels
# alias kssboml='k -n kubescape get sbomspdxv2p3s --show-labels'
# alias kssbomfl='k -n kubescape get sbomspdxv2p3filtereds --show-labels'
# alias kssbomsl='k -n kubescape get sbomsummaries --show-labels'
# alias ksvulnsl='k -n kubescape get vulnerabilitymanifestsummaries --show-labels'
# alias ksvulnl='k -n kubescape get vulnerabilitymanifests --show-labels'
 

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
