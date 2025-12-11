# # version(Bash >= 5.1)
# sparse::bounds <list> <minidx> <maxidx>
function sparse::bounds() {
    local IFS=" " LC_ALL=C a

    [[ ${!1@a} == *a* ]] || return 1

    # If $1 == parameter, then `local -n parameter=$1` would create
    # a circular reference: parameter -> parameter.
    if [[ ${1:?} == b ]]; then
        # shellcheck disable=2154
        a="${!b[*]}" # direct
    else
        local -n c=${1}
        a="${!c[*]}"
    fi

    ((${#a[@]})) || return 1

    printf -v "${2:?}" %d "${a%% *}"

    # [2 ** 63] wraps to [0], 2 ** 63 is 19-digit.
    a="${a: -19}"

    printf -v "${3:?}" %d "${a##* }"
}
