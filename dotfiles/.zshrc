# # Source configuration files
# for config_file in ~/.zsh/*.zsh; do
#   source "$config_file"
# done
#


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

export GPG_TTY=$(tty)

export DOCKER_CLI_EXPERIMENTAL=enabled

export PATH=$PATH:~/scripts

if [ -z "$SSH_AUTH_SOCK" ]; then
    eval $(ssh-agent) > /dev/null
fi


# ------------------------------
# zsh config 
# ------------------------------

ZSH_THEME="strug"

# ------------------------------
# end zsh config 
# ------------------------------



# ------------------------------
# omz config 
# ------------------------------

# TODO: delete
# source $HOME/.oh-my-zsh/oh-my-zsh.sh

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Remind about update when it is time
zstyle ':omz:update' mode reminder  

plugins=(git docker zsh-syntax-highlighting zsh-autosuggestions you-should-use)

source $ZSH/oh-my-zsh.sh

# ------------------------------
# end omz config 
# ------------------------------



# ------------------------------
# user configuration 
# ------------------------------

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

# Prompt config
PROMPT='%F{92} ╭─%f%B%F{220}%~%f %F{92}${vcs_info_msg_0_}%f%b
%F{92} ╰$ %f'
RPROMPT='%B%F{92}%f%b'

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

# Editors
alias vim='nvim'
alias v='nvim'
alias code="code --profile main"

# Misc
alias open="xdg-open"

# ------------------------------
# end aliases 
# ------------------------------

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

PATH=~/.console-ninja/.bin:$PATH

# Example custom prompt configuration
# PROMPT='%{$fg_bold[green]%}%n@%m %{$fg_bold[blue]%}%~ %{$reset_color%}$(git_prompt_info)'

autoload -Uz vcs_info
precmd() {
    vcs_info
}
zstyle ':vcs_info:git:*' formats '[%b]'
setopt prompt_subst


# PROMPT='%F{blue}%~%f %F{092}% $ %f'
# RPROMPT='%F{green}${vcs_info_msg_0_}%f'

# PROMPT='%F{blue}%~%f %F{red}${vcs_info_msg_0_}%f%F{109}% %f '
# RPROMPT='%{$fg[cyan]%}%D{%Y-%m-%d %H:%M:%S%} %{$reset_color%}'

# PROMPT='%{$fg_bold[cyan]%}%c%{$reset_color%}$(git_prompt_info)%{$fg[green]%}'
# PROMPT+="%(?:%{$fg_bold[green]%}:%{$fg_bold[red]%}) > %{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(%{$fg_bold[red]%}"
# ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
# ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
#

# Start ssh-agent if not already running
#if [ -z "$SSH_AUTH_SOCK" ]; then
 # eval "$(ssh-agent -s)"
#fi

# Add SSH key if not already added
#ssh-add -l &>/dev/null || ssh-add ~/.ssh/id_ed25519

alias irb='irb --simple-prompt'


bindkey -s '^f' 'tmux-sessionizer\n'


export PATH="$HOME/pers/scripts:$PATH"

export PATH="/usr/bin:$PATH"
export LD_LIBRARY_PATH="/usr/lib:$LD_LIBRARY_PATH"


[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"


export PATH="$HOME/.local/share/gem/ruby/3.2.0/bin:$PATH"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
export PATH="$PATH:$HOME/.rvm/bin"



[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

. "/home/bchk/.wasmedge/env"
export PATH="/home/bchk/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/home/bchk/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

# pnpm
export PNPM_HOME="/home/bchk/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
