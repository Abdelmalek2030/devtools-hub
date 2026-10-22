# Bash programmable completion for clean-ports(1)

_clean_ports_completions() {
    local cur prev
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"

    if [ "$COMP_CWORD" -eq 1 ]; then
        COMPREPLY=( $(compgen -W "3000 4000 5000 5432 6379 8000 8080 8443 9000" -- "$cur") )
        return 0
    fi

    if [ "$COMP_CWORD" -eq 2 ]; then
        COMPREPLY=( $(compgen -W "--dry-run" -- "$cur") )
        return 0
    fi
}

complete -F _clean_ports_completions clean-ports
