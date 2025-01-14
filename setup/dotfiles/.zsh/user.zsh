# ------------------------------
# user configuration 
# ------------------------------

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
# bindkey -s '^h' '^u^ktmux neww -n "cheat-sheet" zsh -c "source cheat-sheet; exec zsh"\n'
bindkey -s '^h' 'if [[ "$(tmux display-message -p "#W")" == "cheat-sheet" ]]; then source cheat-sheet; exec zsh; else tmux neww -n "cheat-sheet" zsh -c "source cheat-sheet; exec zsh"; fi\n'

# upgrade fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# include fzf bindings into zsh shell 
source <(fzf --zsh)

export PATH="$HOME/pers/scripts:$PATH"

# ------------------------------
# end user configuration 
# ------------------------------
