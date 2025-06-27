((__utils__))&&return||readonly __utils__=1

function utils.sleep() {
    read -srt "${1:?}" _
}

function utils.hasFunc() {
    declare -F "${1:?}" &> /dev/null
}

readonly -f utils.sleep
readonly -f utils.hasFunc
