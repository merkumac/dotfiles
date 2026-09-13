# ---- Basic ZSH Config ----
# ---- history config ----
# TODO: Consider using atuin? If that would make any sense...
setopt inc_append_history     # immediately append to history instead of overwriting
setopt share_history          # all terminals see the same history in real-time
setopt extended_history       # record history with timestamps
setopt hist_ignore_dups       # don't record the entry which was just recorded
setopt hist_expire_dups_first # if HISTSIZE reached - remove dupes

HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

# ---- prompt config ----
# user@macbook:~/projects $
PROMPT='%F{green}%n@%m%f:%F{blue}%~%f %# '

# I've used the `ll` since 2003, so that's the only alias I need.
alias ll='ls -la'

if command -v fzf > /dev/null; then
    alias hists='history | fzf'
fi

export FZF_DEFAULT_OPTS="--height=40% --reverse --border"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window up:3:hidden"

case "$(uname)" in
    Darwin) # macOS
        path_homebrew="/opt/homebrew/bin/:/opt/homebrew/sbin"
        path_rust="$HOME/.cargo/bin"
	path_llvm="/opt/homebrew/opt/llvm/bin"
	path_local="$HOME/.local/bin:$HOME/bin"

        export PATH="$path_homebrew:$path_llvm:$path_rust:$path_local:$PATH"
        ;;

    Linux) # Linux - WSL or native
        path_local="$HOME/.local/bin:$HOME/bin"
        export PATH="$path_local:$PATH"
        ;;

    *) # unknown platform
        echo "Unknown platform: $(uname). PATH was not set intentionally."
        ;;
esac

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if (( $+widgets[fzf-history-widget] )); then
    bindkey '^R' fzf-history-widget
fi
