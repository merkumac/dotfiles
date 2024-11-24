# ---- Basic ZSH Config ----

setopt autocd        # auto switch to directory without cd


# ---- history config ----
# TODO: Consider using atuin? If that would make any sense...
setopt inc_append_history  # immediately append to history instead of overwriting
setopt extended_history    # record history with timestamps
setopt hist_ignore_dups    # don't record the entry which was just recorded
setopt share_history       # share history between all the terminal sessions

# ---- prompt config ----
# user@macbook:~/projects $
PROMPT='%F{green}%n@%m%f:%F{blue}%~%f %# '

