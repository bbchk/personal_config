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

# 155
# 130
# Prompt config
PROMPT='%F{155} ╭─%f%B%F{227}%~%f %F{155}${vcs_info_msg_0_}%f%b
%F{155} ╰$ %f'
RPROMPT='%B%F{155}%f%b'

# ------------------------------
# end zsh config 
# ------------------------------
