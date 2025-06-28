((__utils__)) && return 1 || readonly __utils__=1

function utils.sleep() {
    read -srt "${1:?}" _
}

function utils.hasFunc() {
    declare -F "${1:?}" &> /dev/null
}

function utils.utf8Length() {
    local -n result="${1:?}"; result=-1
    local -r string="${2:?}" IFS= LC_ALL=C
    local c

    while read -rn1 -d "" c; do
        printf -v c %d "'${c}"

        (((c & 0xc0) ^ 0x80 && ++result))
    done <<< "${string}"
}

function utils.graycode() {
    local -n result="${1:?}"
    local -i number="${2:?}"

    ((result = number ^ number >> 1))
}

function utils.toGraycode() {
    local -n number="${1:?}"

    ((number ^= number >> 1))
}

readonly -f utils.sleep
readonly -f utils.hasFunc
readonly -f utils.utf8Length
readonly -f utils.graycode
readonly -f utils.toGraycode
