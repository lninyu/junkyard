ref() {
    local k="${2:?}" d="${3:?}"

    while ((--d)); do
        k="${!k}"
    done

    case "${1:?}" in
    get)
        if [[ "${4:?}" != "a" ]]; then
            local -n a="${4}" && a="${k}"
        else
            local -n b="${4}" && b="${k}"
        fi
        ;;
    set)
        if [[ "${k}" != "a" ]]; then
            local -n a="${k}" && b="${4:?}"
        else
            local -n b="${k}" && b="${4:?}"
        fi
        ;;
    esac
}
