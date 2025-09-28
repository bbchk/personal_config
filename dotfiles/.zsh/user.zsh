# ------------------------------
# user configuration
# ------------------------------

HISTFILE="${HOME}/pers/secrets/.zsh_history"

HISTSIZE=100000
SAVEHIST=100000

# History-related options
setopt SHARE_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS

export PATH="$HOME/.symfony5/bin:$PATH"
export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
export PATH=$JAVA_HOME/bin:$PATH

export GOROOT=/usr/lib
export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

export PATH="$PATH:/usr/lib/docker/cli-plugins"
export DOCKER_CLI_EXPERIMENTAL=enabled
export KUBE_PS1_ENABLED=off

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

# keybindings
bindkey -s '^f' '^utmux-sessionizer\n'
bindkey -s '^o' '^usessionizer\n'
# bindkey -s '^h' '^ucheat-sheet-tmux-integration\n'

bindkey -s '^n' '^unvim .\n'
bindkey -s '^p' '^uconnect_vpn\n'

bindkey -s '^h' '^u. hop_to_worktree\n'
bindkey -s '^k' '^u. create_worktree\n'

# bindkey -s '^m' '^u. create_new_branch_in_worktree\n'
# bindkey -s '^k' '^u detach_to_commit_in_worktree\n'

bindkey -s '^a' '^ugit add .\n'
bindkey -s '^s' '^ugit status\n'


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [[ ! "$PATH" == */home/bchk/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/bchk/.fzf/bin"
fi

autoload -U +X compinit && compinit
source <(fzf --zsh)
source <(kubectl completion zsh)

export PATH="$HOME/pers/scripts:$PATH"

# ------------------------------
# end user configuration
# ------------------------------
