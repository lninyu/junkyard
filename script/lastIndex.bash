lastIndex() {
    local -n a="${1:?}"
    local -n b="${2:?}"
    local -a c=("${!b[@]}")
    
    a="${c[-1]}"
}
