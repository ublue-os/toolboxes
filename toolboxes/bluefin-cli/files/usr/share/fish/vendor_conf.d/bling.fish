if status is-interactive
    set -gx STARSHIP_CONFIG /etc/starship.toml
    eval "$(starship init fish)"
    eval "$(atuin init fish)"
    eval "$(zoxide init fish --cmd cd)"
    set -gx HOST (hostname -s)
end

# Eza for ls
alias ll='eza -l --icons=auto --group-directories-first' 2>/dev/null
alias l.='eza -d .*' 2>/dev/null
alias ls='eza' 2>/dev/null
alias l1='eza -1'

# Ripgrep for grep
alias grep='rg' 2>/dev/null
alias egrep='rg' 2>/dev/null
alias fgrep='rg -F' 2>/dev/null
alias xzgrep='rg -z' 2>/dev/null
alias xzegrep='rg -z' 2>/dev/null
alias xzfgrep='rg -z -F' 2>/dev/null

# Zoxide is handling cd
alias cd='cd' 2>/dev/null

# Fd for find
alias find='fd' 2>/dev/null 