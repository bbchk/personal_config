# ------------------------------
# Oh My Zsh (zsh plugin manager) configuration
# ------------------------------

export ZSH_DISABLE_COMPFIX="true"

export ZSH="$HOME/pers/dotfiles/.oh-my-zsh"
export ZSH_CUSTOM="$HOME/pers/dotfiles/.custom/omz"

ZSH_THEME="strug"

# Remind about update when it is time
zstyle ':omz:update' mode reminder

plugins=(git docker zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
