# ------------------------------
# zsh config
# ------------------------------

autoload -Uz vcs_info compinit

# Use cache for compinit (check only once per day)
if [[ -n ${ZDOTDIR}/.zcompdump(#qNmh+24) ]]; then
  compinit
else
  compinit -C
fi

precmd() {
    vcs_info
}

zstyle ':vcs_info:git:*' formats '[%b]'
setopt prompt_subst
setopt histignorespace

PROMPT='%F{155} ╭─%f%B%F{227}%~%f %F{214}${vcs_info_msg_0_}%f%b
%F{155} ╰$ %f'
RPROMPT='%B%F{155}%f%b'
export FZF_DEFAULT_OPTS="--color=fg:white,bg:black,hl:155,fg+:white,bg+:black,hl+:214,prompt:white,pointer:214"

export PATH="/usr/bin:$PATH"
# export LD_LIBRARY_PATH="/usr/lib:$LD_LIBRARY_PATH"

# Terminal history
HISTFILE="${HOME}/pers/secrets/my/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS

export GPG_TTY=$(tty)
export MANPATH="/usr/local/man:$MANPATH"
export LANG=en_US.UTF-8
export LESS='-R'
export EDITOR='nvim'
export VISUAL='nvim'
export SUDO_EDITOR='nvim'
export MANPAGER="nvim +Man!!"

export PATH="$HOME/pers/scripts:$PATH"
