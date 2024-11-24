# ---- Basic ZSH Config ----

setopt autocd        # auto switch to directory without cd


# ---- history config ----
# TODO: Consider using atuin? If that would make any sense...
setopt inc_append_history  # immediately append to history instead of overwriting
setopt extended_history    # record history with timestamps
setopt hist_ignore_dups    # don't record the entry which was just recorded
setopt share_history       # share history between all the terminal sessions

HISTFILE=$HOME/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

# ---- prompt config ----
# user@macbook:~/projects $
PROMPT='%F{green}%n@%m%f:%F{blue}%~%f %# '

# ---- aliases ----
alias ll='ls -la'

alias history='history 1'

if command -v fzf > /dev/null; then
    alias hists='history | fzf'
fi

# git - let's see if I'll use them
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias up='git push'
alias pu='git pull'

