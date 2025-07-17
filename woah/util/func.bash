function func.exists() {
    declare -F "${@}" &>/dev/null
}

function func.rename() {
    if declare -F "${1:?}" && ! declare -F "${2:?}"; then
        : "$(declare -f "${1}")"
        eval "${2}${_#* }"
        unset -f "${1}"
    fi
}

function func.inject() {
    if ! declare -F "${2:?}" "${3:?}" &>/dev/null; then
        return 1
    fi

    local target inject
    target="$(declare -f ${2})"
    inject="$(declare -f ${3})"
    inject="${inject#*{}"

    case "${1,,}" in
    head) eval "${target/{/{${inject%\}}}" ;;
    tail) eval "${target%\}}${inject%\}}}" ;;
    *) return 1 ;;
    esac
}

function func.cp() {
    local func list temp
    mapfile -t list < <(compgen -A function -- "${1?}")

    for func in "${list[@]}"; do
        : "$(declare -f "${func}")"
        temp+="${_/${1}/${2?}};"
    done

    eval "${temp}"
}

function func.mv() {
    : "$(declare -f func.cp)";: "${_/cp/mv}"
    eval "${_%\}}unset -f \"\${list[@]}\";}"
    $FUNCNAME "${@}"
}
