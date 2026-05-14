# ------------------------------
# zsh config ------------------------------

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

HISTFILE="${HOME}/.zsh_history"
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
export EDITOR="nvr --servername $NVIM --remote-tab"
export VISUAL="$EDITOR"
export MANPAGER="nvr --servername $NVIM --remote-tab +'Man!' -"

export PATH="$HOME/pers/scripts:$PATH"

[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"
#
# TODO: refactor later
git() {
    if [[ $1 == "clone" ]] || [[ $1 == "clonew" ]] || [[ $1 == "submodule" && $2 == "add" ]]; then
        command git "$@"
        local exit_code=$?

        if [ $exit_code -eq 0 ]; then
            local nvim_sockets=$(
                find /tmp "${XDG_RUNTIME_DIR:-/run/user/$UID}" -name 'nvim.*.0' 2>/dev/null | sort -u
            )

            if [ -n "$nvim_sockets" ]; then
                echo "🔄 Refreshing Neovim sessionizer cache..."
                (
                    echo "$nvim_sockets" | while read -r socket; do
                        nvim --server "$socket" \
                            --remote-send "<Cmd>lua local s=require('custom.sessionizer'); s.refresh_cache(); s.populate_cache({ quiet = true })<CR>" \
                            2>/dev/null &
                    done
                    wait
                ) &>/dev/null
            fi
        fi

        return $exit_code
    else
        command git "$@"
    fi
}
