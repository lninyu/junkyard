# sparse::bounds <list> <result_min> <result_max>
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

# sparse::rangedBounds <keys> <result_min> <result_max> <range_min> <range_max>
function sparse::rangedBounds() {
    local -nr keys=${1:?} head=${2:?} tail=${3:?}
    local -ir rmin=${4:?} rmax=${5:?}
    local -i lo mi hi

    ((lo = 0, hi = tail = ${#keys[@]} - 1))

    while ((lo <= hi)); do
        ((keys[mi = lo + hi >> 1] < rmax ? (lo = (tail = mi) + 1) : (hi = mi - 1)))
    done

    ((lo = 0, hi = tail))

    while ((lo <= hi)); do
        ((keys[mi = lo + hi >> 1] < rmin ? (lo = mi + 1) : (hi = (head = mi) - 1)))
    done

    if ((keys[head] < rmin || rmax <= keys[tail])); then
        ((!(head = tail = -1)))
    fi
}
