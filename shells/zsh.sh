# cmd-k shell integration for zsh
ck() {
    local cmd=$(cmd-k "$@")
    # Use print -z to push to the editing buffer
    print -z "$cmd"
}
