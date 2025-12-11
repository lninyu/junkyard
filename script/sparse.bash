function sparse::bounds() {
    [[ ${!1@a} == *a* ]] || return 1

    local IFS=$'\40' LC_ALL=C a

    # If $1 == parameter, then `local -n parameter=$1` would create
    # a circular reference: parameter -> parameter.
    if [[ ${1:?} != b ]]; then
        local -n b=${1}
    fi

    ((${#b[@]})) || return 1

    # "idx idx2 idx3 ..."
    a="${!b[*]}"

    printf -v "${2:?}" %d "${a%% *}"

    # [2 ** 63] wraps to [0], 2 ** 63 - 1 is 19-digit.
    # local -ir length=2**63-1
    # a="${a:${#a}<${#length}?0:-${#length}}"
    a="${a:${#a}<19?0:-19}"

    printf -v "${3:?}" %d "${a##* }"
}
