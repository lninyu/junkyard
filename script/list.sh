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

function list.update() { :;}
function list.updateRaw() { :;}
function list.remove() { :;}
function list.delete() { :;}
function list.defrag() { :;}
function list.squash() { :;}
function list.equals() { :;}
function list.length() { :;}
