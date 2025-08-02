aaaaa() {
    local -r LC_ALL=C IFS=
    while read -r; do
        ( ((REPLY)) ) 2> /dev/null && echo "= $((REPLY))"
    done
}
