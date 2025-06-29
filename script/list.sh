((__list__)) && return 1 || readonly __list__=1818850164 #0x6c697374
# list:{0x6c697374, limit:int, count:int, meta:(str){offset:int, length:int}[], data:str[]}
function list.new() {
    local -n self="${1:?}"

    self=(${__list__} $((${2:-0} > 0 ? ${2:-0} : 0)) 0 "")
}

function list.append() {
    local -n self="${1:?}" data="${2:?}"

    if ((self == __list__)); then
        self+=("${data[@]}" [3]+="${#self[@]} ${#data[@]} ")
# @debug
#    else
#        echo "${FUNCNAME}: invalid condition" >&2
#        return 1
# @debug:end
    fi
}

function list.appendRaw() {
    local -n self="${1:?}"

    if ((self == __list__)); then
        self+=("${@:2}" [3]+="${#self[@]} $((${#} - 1)) ")
# @debug
#    else
#        echo "${FUNCNAME}: invalid condition" >&2
#        return 1
# @debug:end
    fi
}

function list.insert() {
    local -n self="${1:?}" data="${3:?}"
    local -i meta=(${self[3]}) idx="${2:?}"

    if ((self == __list__ && 0 <= (idx <<= 1) && idx <= ${#meta[@]})); then
        meta+=([idx]=${#self[@]} ${#data[@]} ${meta[@]:idx})
        self+=("${data[@]}" [3]="${meta[*]}")
# @debug
#    else
#        echo "${FUNCNAME}: invalid condition" >&2
#        return 1
# @debug:end
    fi
}

function list.insertRaw() {
    local -n self="${1:?}"
    local -i meta=(${self[3]}) idx="${2:?}"

    if ((self == __list__ && 0 <= (idx <<= 1) && idx <= ${#meta[@]})); then
        meta+=([idx]=${#self[@]} ${#}-2 ${meta[@]:idx})
        self+=("${@:3}" [3]="${meta[*]}")
# @debug
#    else
#        echo "${FUNCNAME}: invalid condition" >&2
#        return 1
# @debug:end
    fi
}

function list.update() {
    local -n self="${1:?}" data="${3:?}"
    local -i meta=(${self[3]}) siz idx="${2:?}"

    if ((self == __list__ && 0 <= (idx <<= 1) && idx < ${#meta[@]})); then
        if (((siz = ${#data[@]}) <= (len = meta[idx + 1]) && 0 <= siz)); then
            ((self[2] += len - siz, meta[idx + 1] = siz))

            self+=([ meta[idx] ]="${data}" "${data[@]:1}" [3]="${meta[*]}")
        else
            ((self[2] += siz - len, meta[idx + 1] = siz, meta[idx] = ${#self[@]}))

            self+=("${data[@]}" [3]="${meta[*]}")
        fi

        if ((self[1] && self[1] <= self[2])); then
            "${FUNCNAME%.*}.defrag" "${1}"
        fi
# @debug
#    else
#        echo "${FUNCNAME}: invalid condition" >&2
#        return 1
# @debug:end
    fi
}

function list.updateRaw() {
    local -n self="${1:?}"
    local -i meta=(${self[3]}) siz idx="${2:?}"

    if ((self == __list__ && 0 <= (idx <<= 1) && idx < ${#meta[@]})); then
        if (((siz = ${#} - 2) <= (len = meta[idx + 1]) && 0 <= siz)); then
            ((self[2] += len - siz, meta[idx + 1] = siz))

            self+=([ meta[idx] ]="${3}" "${@:4}" [3]="${meta[*]}")
        else
            ((self[2] += siz - len, meta[idx + 1] = siz, meta[idx] = ${#self[@]}))

            self+=("${@:3}" [3]="${meta[*]}")
        fi

        if ((self[1] && self[1] <= self[2])); then
            "${FUNCNAME%.*}.defrag" "${1}"
        fi
# @debug
#    else
#        echo "${FUNCNAME}: invalid condition" >&2
#        return 1
# @debug:end
    fi
}

function list.remove() {
    local -n self="${1:?}"
    local -i meta=(${self[3]}) idx="${2:?}"

    if ((self == __list__ && 0 <= (idx <<= 1) && idx < ${#meta[@]})); then
        ((self[2] += meta[idx + 1], meta[idx + 1] = 0))

        self[3]="${meta[*]}"

        if ((self[1] && self[1] <= self[2])); then
            "${FUNCNAME%.*}.defrag" "${1}"
        fi
# @debug
#    else
#        echo "${FUNCNAME}: invalid condition" >&2
#        return 1
# @debug:end
    fi
}

function list.delete() {
    local -n self="${1:?}"
    local -a meta=(${self[3]})
    local -i idx="${2:?}"

    if ((self == __list__ && 0 <= (idx <<= 1) && idx < ${#meta[@]})); then
        ((self[2] += meta[idx + 1]))

        meta+=([idx]=\  \ )
        self[3]="${meta[*]}"

        if ((self[1] && self[1] <= self[2])); then
            "${FUNCNAME%.*}.defrag" "${1}"
        fi
# @debug
#    else
#        echo "${FUNCNAME}: invalid condition" >&2
#        return 1
# @debug:end
    fi
}

function list.get() {
    local -n self="${1:?}" result="${3:?}"
    local -i meta=(${self[3]}) idx="${2:?}"

    if ((self == __list__ && 0 <= (idx <<= 1) && idx < ${#meta[@]})); then
        result=("${self[@]:meta[idx]:meta[idx + 1]}")
# @debug
#    else
#        echo "${FUNCNAME}: invalid condition" >&2
#        return 1
# @debug:end
    fi
}

function list.defrag() { :;}
function list.squash() { :;}
function list.equals() { :;}
function list.length() { :;}
