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
