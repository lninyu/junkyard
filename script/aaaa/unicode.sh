((__unicode__)) && return 1 || readonly __unicode__=1

function unicode.get() {
    local -i fd
    exec {fd}<>/dev/tcp/unicode.org/80 || {
        echo "Connection failed" >&2
        return 1
    }

    local -a request
    local -r path="/Public/UCD/latest/ReadMe.txt"
#    local -r path="/Public/UCD/latest/ucd/auxiliary/GraphemeBreakProperty.txt"
    request+=("GET ${path} HTTP/1.1")
    request+=("Host: unicode.org")
    request+=("")

    printf "%s\r\n" "${request[@]}" >&${fd}

    local -a response
    mapfile -u ${fd} response

    printf "%s" "${response[@]}"

    exec {fd}>&-
}

unicode.get
