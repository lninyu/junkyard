# See: https://github.com/dylanaraps/pure-bash-bible?tab=readme-ov-file#reverse-an-array
function util.reverse() {
    if [[ ${FUNCNAME[1]} == $FUNCNAME ]]; then
        o=("${BASH_ARGV[@]::$#}")
    elif local -n o=${1:?} i=${2:-$1}; shopt -q extdebug; then
        $FUNCNAME "${i[@]}"
    else
        shopt -s extdebug
        $FUNCNAME "${i[@]}"
        shopt -u extdebug
    fi
}
