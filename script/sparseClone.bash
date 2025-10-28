function sparseClone() {
    local LC_ALL=C IFS=
    builtin : "$(declare -p "${2:?}")"
    eval "${1:?}=${_#*=}"
}
