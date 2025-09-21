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
setopt histignorespace 

export ZSH_CUSTOM="$HOME/pers/config/omz"

# Prompt config
PROMPT='%F{155} ╭─%f%B%F{227}%~%f %F{155}${vcs_info_msg_0_}%f%b
%F{155} ╰$ %f'
RPROMPT='%B%F{155}%f%b'

export FZF_DEFAULT_OPTS="--color=fg:white,bg:black,hl:red,fg+:white,bg+:black,hl+:227,prompt:155,pointer:227"

# ------------------------------
# end zsh config 
# ------------------------------
