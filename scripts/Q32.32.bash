q32_32.toFloat() {
    printf -v "${1:?}" "0x%xp-32" "$((${2:?}))"
    printf -v "${1}" "${3:-"%f"}" "${!1}"
}

q32_32.fromInt() {
    (( ${1:?} = (${2:?}) << 32 ))
}

q32_32.toInt() {
    (( ${1:?} = (${2:?}) < 0 ? -((${2}) >> 32) : (${2}) >> 32 ))
}

q32_32.add() {
    (( ${1:?} = (${3:-${1}}) + (${2}) ))
}

q32_32.sub() {
    (( ${1:?} = (${3:-${1}}) - (${2}) ))
}

q32_32.mul() {
    local -i a="${3:-${1}}" b="${2:?}" sa sb au al bu bl uu ul lu ll rt ru rl

    (( a = (sa = a & 0x8000000000000000) ? -a : a ))
    (( b = (sb = b & 0x8000000000000000) ? -b : b ))
    (( au = 0xffffffff & a >> 32, al = 0xffffffff & a ))
    (( bu = 0xffffffff & b >> 32, bl = 0xffffffff & b ))
    (( uu = au * bu ))
    (( ul = au * bl ))
    (( lu = al * bu ))
    (( ll = al * bl ))
    (( rt = (0xffffffff & ul) + (0xffffffff & lu) + (0xffffffff & ll >> 32) ))
    (( rl = (0xffffffff & ll) + (rt << 32) ))
    (( ru = (0xffffffff & ul >> 32) + (0xffffffff & lu >> 32) + (0xffffffff & rt >> 32) + uu ))
    (( sa ^ sb )) && (( ru = ~ru, rl = ~rl, !++rl )) && (( ++ru ))
    (( ${1} = ru << 32 | 0xffffffff & rl >> 32 ))

    (( uu + ((ul + lu) >> 32) & 0xffffffff00000000 )) && q32_32.die "OverflowError" "$(local)"
}

q32_32.die() {
    local out idx len fmt="- %s (%d)"

    for ((idx = 0, len = ${#FUNCNAME[@]}; idx < len; ++idx)); do
        ((idx + 1 == len)) && fmt="${fmt/\%s/<%s>}"

        printf -v out[${idx}] -- "${fmt}" "${FUNCNAME[idx]}" "${BASH_LINENO[idx]}"
    done

    printf "%s\n" "[die - ${1:-"UnknownError"}]" "${@:2}" "[trace]" "${out[@]}" >& 2

    exit 1
}
