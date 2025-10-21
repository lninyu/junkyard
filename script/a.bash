# shellcheck disable=SC2034
declare -i depth=0 foo=0 max=1000
declare cond='foo < max'
declare expr='++foo'
declare _loop='
    cond && (
        expr,
        ++depth < 64 && (
            _loop,
            _loop
        ),
        --depth
    )'
declare _while='depth=0, _loop'

cond="${cond//[[:space:]]}"
expr="${expr//[[:space:]]}"
_loop="${_loop//[[:space:]]}"
_while="${_while//[[:space:]]}"

declare -p cond expr _loop _while

time {
    ((_while))
}

declare -i bar=0 baz=max

time {
    while ((baz--)); do
        ((++bar))
    done
} 2> /dev/null

echo "foo:${foo}"
echo "bar:${bar}"
