function sparseClone() {
    local LC_ALL=C IFS=
    builtin : "$(declare -p "${2:?}")"
    eval "${1:?}=${_#*=}"
}

sparse.shiftCopy() {
    local -n a=${1:?} b=${2:?}
    local -i c=${3:?}

    for c in "${!b[@]}"; do
        # shellcheck disable=SC2034
        a[c+$3]="${b[c]}"
    done
}
