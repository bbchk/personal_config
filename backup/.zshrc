# ------------------------------
# omz config 
# ------------------------------

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="strug"

# Remind about update when it is time
zstyle ':omz:update' mode reminder  

plugins=(git docker zsh-syntax-highlighting zsh-autosuggestions you-should-use)

source $ZSH/oh-my-zsh.sh

# ------------------------------
# end omz config 
# ------------------------------



# ------------------------------
# zsh config 
# ------------------------------

autoload -Uz vcs_info compinit

compinit

precmd() {
    vcs_info
}

zstyle ':vcs_info:git:*' formats '[%b]'

setopt prompt_subst

# Prompt config
PROMPT='%F{92} ╭─%f%B%F{220}%~%f %F{92}${vcs_info_msg_0_}%f%b
%F{92} ╰$ %f'
RPROMPT='%B%F{92}%f%b'

# ------------------------------
# end zsh config 
# ------------------------------



# ------------------------------
# user configuration 
# ------------------------------

export DOCKER_CLI_EXPERIMENTAL=enabled

export GPG_TTY=$(tty)

export MANPATH="/usr/local/man:$MANPATH"

# Manually set language environment
export LANG=en_US.UTF-8

export LESS='-R'

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
  export MANPAGER="vim +Man!!"
else
  export EDITOR='nvim'
  export MANPAGER="nvim +Man!!"
fi

# Compilation flags
export ARCHFLAGS="-arch x86_64"

bindkey -s '^f' 'tmux-sessionizer\n'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export PATH="$HOME/pers/scripts:$PATH"

# ------------------------------
# end user configuration 
# ------------------------------



# ------------------------------
# aliases 
# ------------------------------

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

# Github Copilot 
alias gpilot="gh copilot"
alias ghs="ghs copilot suggest"
alias ghe="ghe copilot explain"

# Ruby
alias irb='irb --simple-prompt'

# Editors
alias vim='nvim'
alias v='nvim'
alias code="code --profile main"

# Misc
alias open="xdg-open"

# ------------------------------
# end aliases 
# ------------------------------



# ------------------------------
# System specific 
# ------------------------------

export PATH="/usr/bin:$PATH"
export LD_LIBRARY_PATH="/usr/lib:$LD_LIBRARY_PATH"

if ! pgrep -x "keychain" > /dev/null; then
  for key in ~/.ssh/*; do
    [ -f "$key" ] && eval $(keychain --eval --agents ssh "$key" > /dev/null 2>&1)
  done
fi

# ------------------------------
# End system specific 
# ------------------------------



# ------------------------------
# Ruby config 
# ------------------------------

# Load RVM if available
if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
  source "$HOME/.rvm/scripts/rvm"
fi

# Update PATH to include Ruby gems and RVM binaries
export PATH="$HOME/.local/share/gem/ruby/3.2.0/bin:$PATH:$HOME/.rvm/bin"

# ------------------------------
# End Ruby config 
# ------------------------------



# ------------------------------
# Node config 
# ------------------------------

export NVM_DIR="$HOME/.nvm"

# Load nvm if the script exists
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Load nvm bash completion if it exists
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"


export PNPM_HOME="/home/bchk/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# ------------------------------
# End Node config 
# ------------------------------


# TODO: delete if not needed
# export PATH="/home/bchk/.config/herd-lite/bin:$PATH"
# export PHP_INI_SCAN_DIR="/home/bchk/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"
