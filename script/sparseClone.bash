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

sparse.shiftCopyIfEmpty() {
    local -n a=${1:?} b=${2:?}
    local -i c=${3:?}

    for c in "${!b[@]}"; do
        builtin : "${a[c+$3]:="${b[c]}"}"
    done
}

sparse.clone() { # (src, src_pos, dest, dest_offset, length)
    local -n a=${1:?} b=${3:?}
    local -i c=${4:?} d=("${!a[@]}")

    for c in "${d[@]:${2:?}:${5:?}}"; do
        b[c+$4]="${a[c]}"
    done
}

sparse.copy() { # (src, src_offset, dest, dest_offset, length)
    local -n a=${1:?} b=${3:?}
    local -i c=${2:?} d=${5:?}+$2 e=${4:?}-$2 f

    for f in "${!a[@]}"; do
        if (( c <= f )); then
            if (( d <= f )); then
                break
            fi

            b[f+e]="${a[f]}"
        fi
    done
}

idxpos() { # (result, array, index)
    local -n a=${2:?}
    local -i b=${3:?} c d=0 e=${#a[@]}-1
    local -a f=("${!a[@]}")

    while (( c = d + e >> 1, d <= e )); do
        if (( f[c] == b )); then
            (( ${1:?} = c )); return
        fi

        (( f[c] < b ? (d = c + 1) : (e = c - 1) ))
    done

    return 1
}
