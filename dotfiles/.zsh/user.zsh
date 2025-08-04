# ------------------------------
# user configuration 
# ------------------------------

# gsettings set org.gnome.desktop.interface enable-animations false

export PATH="$HOME/.symfony5/bin:$PATH"
export JAVA_HOME="/usr/lib/jvm/java-17-openjdk-amd64"
export PATH=$JAVA_HOME/bin:$PATH

export PATH="$PATH:/usr/lib/docker/cli-plugins"
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

# keybindings 
bindkey -s '^f' '^u^ktmux-sessionizer\n'
bindkey -s '^h' '^u^kcheat-sheet-tmux-integration\n' 

bindkey -s '^n' '^u^knvim .\n' 
bindkey -s '^p' '^u^kconnect_vpn\n' 

bindkey -s '^b' '^u^k. to_worktree\n' 
bindkey -s '^w' '^u^kcreate_worktree\n' 

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [[ ! "$PATH" == */home/bchk/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/bchk/.fzf/bin"
fi

source <(fzf --zsh)
source <(kubectl completion zsh)

export PATH="$HOME/pers/scripts:$PATH"

# ------------------------------
# end user configuration 
# ------------------------------
