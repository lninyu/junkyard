((__list__)) && return 1 || readonly __list__=1818850164 #0x6c697374
# list:{0x6c697374, limit:int, count:int, meta:(str){offset:int, length:int}[], data:str[]}
function list.new() {
    local -n self="${1:?}"

    self=(${__list__} $((${2:-0} > 0 ? ${2:-0} : 0)) 0 "")
}

function list.append() { :;}
function list.appendRaw() { :;}
function list.insert() { :;}
function list.insertRaw() { :;}
function list.update() { :;}
function list.updateRaw() { :;}
function list.remove() { :;}
function list.delete() { :;}
function list.defrag() { :;}
function list.squash() { :;}
function list.equals() { :;}
function list.length() { :;}
