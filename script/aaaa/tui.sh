((__tui__)) && return 1 || {
    readonly __tui__=1

    eval 'readonly _TUI_EMPTY=(""{,,,}{,,,}{,,,})'
}

function tui.resetbuf() {
    local -n buf="${1:?}"
    local -i siz=LINES+1

    buf=()

    until (((siz -= 64) & 0x8000000000000000)); do
        # ?: (siz -= 64) >> 63
        buf+=("${_TUI_EMPTY[@]}")
    done

    buf+=("${_TUI_EMPTY[@]::siz+64}")
}

function tui.flushbuf() {
    local -n buf="${1:?}"
    local -r IFS= LC_ALL=C

    echo -en $'\e[H'"${buf[*]//%/$'\n'}"

    buf=()
}
