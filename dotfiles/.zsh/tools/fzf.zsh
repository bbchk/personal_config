[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
if [[ ! "$PATH" == */home/bchk/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/bchk/.fzf/bin"
fi

autoload -U +X compinit && compinit
source <(fzf --zsh)
source <(kubectl completion zsh)
