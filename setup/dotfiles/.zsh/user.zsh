# ------------------------------
# user configuration 
# ------------------------------

export JAVA_HOME="/usr/lib/jvm/java-21-openjdk"
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

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# Scripts keybindings 
bindkey -s '^f' '^u^ktmux-sessionizer\n'
bindkey -s '^h' '^u^kcheat-sheet-tmux-integration\n' 

# upgrade fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# include fzf bindings into zsh shell 
source <(fzf --zsh)
source <(kubectl completion zsh)

export PATH="$HOME/pers/scripts:$PATH"
export PATH="$HOME/pers/programs/sioyek/:$PATH"

# ------------------------------
# end user configuration 
# ------------------------------
