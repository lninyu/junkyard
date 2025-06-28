((__utils__)) && return 1 || readonly __utils__=1

# @summary
# - sleep (100% builtin fr)
#
# @recommended >= 4.0-alpha
# - read -t can handle fractional seconds
function utils.sleep() {
    read -srt "${1:?}" _
}

# @summary
# - Check if function is defined.
# - You know it when you see it.
function utils.funcExists() {
    declare -F "${1:?}" &> /dev/null
}

# @summary
# - Counts the number of characters in utf-8 strings.
#
# @remark
# - Counts UTF-8 lead bytes only; does not handle grapheme clusters correctly.
#
# @require >= 4.3
# - local -n
#
# @example "Count the number of UTF-8 characters in a string containing emoji."
# - declare length string=$'wow\xf0\x9f\x92\xa9!'
# - utils.utf8Length length "${string}"
# - echo "length = ${length}"
#
# @example:output
# - length = 5
function utils.utf8Length() {
    local -n result="${1:?}"; result=-1
    local -r string="${2:?}" IFS= LC_ALL=C
    local c

    while read -rn1 -d "" c; do
        printf -v c %d "'${c}"

        ((c & 0xc0 ^ 0x80 && ++result))
    done <<< "${string}"
}

# @summary
# - Converts number to graycode.
#
# @example
# - declare result number=10
# - utils.graycode result number
# - echo "${number} -> ${result}"
#
# @example:output
# - 10 -> 15
function utils.graycode() {
    ((${1:?} = ${2:?} ^ ${2} >> 1))
}

# @summary
# - Converts number to graycode in-place.
function utils.toGraycode() {
    ((${1:?} ^= ${1} >> 1))
}

# @summary
# - Make the specified function immutable.
function utils.freezeFunc() {
    local list; for list; do
        readonly -f "${list}"
    done &> /dev/null
}

# @summary
# - List function names matching a pattern or specific name.
#
# @require >= 4.3
# - local -n
#
# @example "Get functions matching a pattern."
# - declare -a funcs
# - utils.getFuncs funcs "utils.*f*"
# - printf "%s\n" "${funcs[@]}"
#
# @example:output
# - utils.freezeFunc
# - utils.funcExists
# - utils.utf8Length
function utils.getFuncs() {
    local -n list="${1:?}"
    local -r cond="${2}" IFS=$'\n'

    if [[ -z ${cond} ]]; then
        list=($(declare -F))
        list=(${list[@]##* })
    elif [[ ${cond} == *"*"* ]]; then
        local -i index size

        list=($(declare -F))
        list=(${list[@]##* })

        for ((index = 0, size = ${#list[@]}; index < size; ++index)); do
            if [[ "${list[index]}" != ${cond} ]]; then
                list[index]=
            fi
        done

        list=(${list[@]})
    elif utils.funcExists "${cond}"; then
        list=("${cond}")
    fi
}
