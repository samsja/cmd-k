# cmd-k shell integration for bash
ck() {
    local cmd=$(cmd-k "$@")

    # Use read with -e (readline) and -i (pre-fill)
    read -e -p "$ " -i "$cmd" final_cmd
    if [[ -n "$final_cmd" ]]; then
        eval "$final_cmd"
    fi
}
