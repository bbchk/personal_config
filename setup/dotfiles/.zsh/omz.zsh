# ------------------------------
# omz config 
# ------------------------------

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="strug"

# Remind about update when it is time
zstyle ':omz:update' mode reminder  

plugins=(git docker zsh-syntax-highlighting zsh-autosuggestions you-should-use kube-ps1)

PROMPT='$(kube_ps1)'$PROMPT 

source $ZSH/oh-my-zsh.sh

# ------------------------------
# end omz config 
# ------------------------------
