[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
if [[ ! "$PATH" == */home/bchk/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/bchk/.fzf/bin"
fi

source <(fzf --zsh)

if (( $+commands[kubectl] )); then
  _kubectl_completion() {
    source <(kubectl completion zsh)
    unfunction _kubectl_completion
  }
  compdef _kubectl_completion kubectl
fi
