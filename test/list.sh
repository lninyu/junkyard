function test.new.0() {
    local array
    list.new array
    local result="$(local -p array)"
    local expect='declare -a array=([0]="1818850164" [1]="0" [2]="0" [3]="")'
    [[ "${result}" == "${expect}" ]]
}

function test.new.1() {
    local array num=10
    list.new array num
    local result=${array[1]}
    local expect=${num}
    [[ "${result}" == "${expect}" ]]
}

function test.new.2() {
    local array num=-1312123
    list.new array num
    local result=${array[1]}
    local expect=0
    [[ "${result}" == "${expect}" ]]
}

function test.append() {
    local array arr=(0 1 2 a b c " " "  " "   ")
    list.new array
    local arrayL=${#array[@]} arrL=${#arr[@]}
    list.append array arr
    [[ ${array[arrayL]} == ${arr[0]} && ${array[arrayL+arrL]} == ${arr[arrL]} ]]
}

function test.appendRaw() {
    local array arr=(0 1 2 a b c " " "  " "   ")
    list.new array
    local arrayL=${#array[@]} arrL=${#arr[@]}
    list.appendRaw array "${arr[@]}"
    [[ ${array[arrayL]} == ${arr[0]} && ${array[arrayL+arrL]} == ${arr[arrL]} ]]
}

function test.main() {
    source "script/utils.sh"
    source "script/list.sh"

    local testfunc
    utils.getFuncs testfunc "test.*"

    for testfunc in "${testfunc[@]}"; do
        [[ "${testfunc}" == "${FUNCNAME}" ]] && continue

        if "${testfunc}"
            then echo "${testfunc}: pass"
            else echo "${testfunc}: fail"
        fi
    done
}; test.main

echo "###########################################"
declare cedde
declare -p cedde
list.new cedde
declare -p cedde
list.appendRaw cedde + + +
list.appendRaw cedde - - -
list.appendRaw cedde _ _ _
list.appendRaw cedde
list.appendRaw cedde
declare -p cedde
#list.updateRaw cedde 0
#list.updateRaw cedde 1
#declare -p cedde
list.delete cedde 4
list.delete cedde 3
list.delete cedde 2
declare -p cedde

((__list__)) && return 1 || readonly __list__=1818850164 #0x6c697374

# list:{0x6c697374, limit:int, count:int, meta:(str){offset:int, length:int}[], data:str[]}

function list.new() {
    local -n self="${1:?}"

    self=(${__list__} $((${2:-0} > 0 ? ${2:-0} : 0)) 0 "")
}

function list.append() {
    local -n self="${1:?}" data="${2:?}"

    ((self == __list__)) && {
        self+=("${data[@]}" [3]+=" ${#self[@]} ${#data[@]}")
    }
}

function list.appendRaw() {
    local -n self="${1:?}"

    ((self == __list__)) && {
        self+=("${@:2}" [3]+=" ${#self[@]} $((${#} - 1))")
    }
}

function list.insert() {
    local -n self="${1:?}" data="${3:?}"
    local -i meta=(${self[3]}) idx="${2:?}"

    ((self == __list__ && 0 <= (idx <<= 1) && idx <= ${#meta[@]})) && {
        meta+=([idx]=${#self[@]} ${#data[@]} ${meta[@]:idx})
        self+=("${data[@]}" [3]="${meta[*]}")
    }
}

function list.insertRaw() {
    local -n self="${1:?}"
    local -i meta=(${self[3]}) idx="${2:?}"

    ((self == __list__ && 0 <= (idx <<= 1) && idx <= ${#meta[@]})) && {
        meta+=([idx]=${#self[@]} ${#}-2 ${meta[@]:idx})
        self+=("${@:3}" [3]="${meta[*]}")
    }
}

function list.update() {
    local -n self="${1:?}" data="${3:?}"
    local -i meta=(${self[3]}) siz idx="${2:?}"

    ((self == __list__ && 0 <= (idx <<= 1) && idx < ${#meta[@]})) && {
        if (((siz = ${#data[@]}) <= (len = meta[idx + 1]) && 0 <= siz)); then
            ((self[2] += len - siz, meta[idx + 1] = siz))

            self+=([ meta[idx] ]="${data}" "${data[@]:1}" [3]="${meta[*]}")
        else
            ((self[2] += siz - len, meta[idx + 1] = siz, meta[idx] = ${#self[@]}))

            self+=("${data[@]:1}" [3]="${meta[*]}")
        fi

        ((self[1] && self[1] <= self[2])) && list.defrag "${1}"
    }
}

function list.updateRaw() {
    local -n self="${1:?}"
    local -i meta=(${self[3]}) siz len idx="${2:?}"

    ((self == __list__ && 0 <= (idx <<= 1) && idx < ${#meta[@]})) && {
        if (((siz = ${#} - 2) <= (len = meta[idx + 1]) && 0 <= siz)); then
            ((self[2] += len - siz, meta[idx + 1] = siz))

            self+=([ meta[idx] ]="${3}" "${@:4}" [3]="${meta[*]}")
        else
            ((self[2] += siz - len, meta[idx + 1] = siz, meta[idx] = ${#self[@]}))

            self+=("${@:3}" [3]="${meta[*]}")
        fi

        ((self[1] && self[1] <= self[2])) && list.defrag "${1}"
    }
}

function list.remove() {
    local -n self="${1:?}"
    local -i meta=(${self[3]}) idx="${2:?}"

    ((self == __list__ && 0 <= (idx <<= 1) && idx < ${#meta[@]})) && {
        ((self[2] += meta[idx + 1], meta[idx + 1] = 0))

        self[3]="${meta[*]}"

        ((self[1] && self[1] <= self[2])) && list.defrag "${1}"
    }
}

function list.delete() {
    local -n self="${1:?}"
    local -a meta=(${self[3]})
    local -i idx="${2:?}"

    ((self == __list__ && 0 <= (idx <<= 1) && idx < ${#meta[@]})) && {
        ((self[2] += meta[idx + 1]))

        meta+=([idx]="" "")
        self[3]="${meta[*]}"

        ((self[1] && self[1] <= self[2])) && list.defrag "${1}"
    }
}

function list.defrag() { :;}
function list.squash() { :;}
function list.equals() { :;}
function list.length() { :;}

#function list:new() {
#    local -n self="${1:?}"
#
#    if ((!${#self[@]}))
#        then local -i rate="${2//[^0-9]/}"; self=(1818850164 ${rate} 0 "")
#        else return 1
#    fi
#}
#function list:append() {
#    case "${2:?}" in
#        -r|--raw)
#            local -n self="${1:?}"
#            local -ai view=(${self[3]})
#
#            if ((self[0] == 1818850164)); then
#                view+=(${#self[@]} ${#}-2)
#                self+=("${@:3}" [3]="${view[*]}")
#            fi ;;
#        *)
#            local -n self="${1:?}" data="${2:?}"
#            local -ai view=(${self[3]})
#
#            if ((self[0] == 1818850164)); then
#                view+=(${#self[@]} ${#data[@]})
#                self+=("${data[@]}" [3]="${view[*]}")
#            fi ;;
#    esac
#}
#function list:insert() {
#    local -i index="${2:?}"
#
#    case "${3:?}" in
#        -r|--raw)
#            local -n self="${1:?}"
#            local -ai view=(${self[3]})
#
#            if ((self[0] == 1818850164 && 0 <= (index <<= 1) && index <= ${#view[@]})); then
#                view+=([index]=${#self[@]} ${#}-3 ${view[@]:index})
#                self+=("${@:4}" [3]="${view[*]}")
#            fi ;;
#        *)
#            local -n self="${1:?}" data="${3:?}"
#            local -ai view=(${self[3]})
#
#            if ((self[0] == 1818850164 && 0 <= (index <<= 1) && index <= ${#view[@]})); then
#                view+=([index]=${#self[@]} ${#data[@]} ${view[@]:index})
#                self+=("${data[@]}" [3]="${view[*]}")
#            fi ;;
#    esac
#}
#function list:update() {
#    local -i index="${2:?}" size
#
#    case "${3:?}" in
#        -r|--raw)
#            local -n self="${1:?}"
#            local -a view=(${self[3]})
#
#            if ((self[0] == 1818850164 && 0 <= (index <<= 1) && index < ${#view[@]})); then
#                if ((0 <= (size = ${#} - 3) && size <= view[index+1])); then
#                    ((self[2] += view[index+1] - size))
#                    view[index+1]=${size}
#                    self+=([view[index] ]="${4}" "${@:5}" [3]="${view[*]}")
#                else
#                    ((self[2] += size - view[index+1]))
#                    view+=([index]=${#self[@]} ${size})
#                    self+=("${@:4}" [3]="${view[*]}")
#                fi
#
#                if ((self[1] && self[1] <= self[2])); then
#                    list:defrag "${1}"
#                fi
#            fi ;;
#        *)
#            local -n self="${1:?}" data="${3:?}"
#            local -a view=(${self[3]})
#
#            if ((self[0] == 1818850164 && 0 <= (index <<= 1) && index < ${#view[@]})); then
#                if ((0 <= (size = ${#data[@]}) && size <= view[index+1])); then
#                    ((self[2] += view[index+1] - size))
#                    view[index+1]=${size}
#                    self+=([view[index] ]="${data[0]}" "${data[@]:1}" [3]="${view[*]}")
#                else
#                    ((self[2] += size - view[index+1]))
#                    view+=([index]=${#self[@]} ${size})
#                    self+=("${data[@]}" [3]="${view[*]}")
#                fi
#
#                if ((self[1] && self[1] <= self[2])); then
#                    list:defrag "${1}"
#                fi
#            fi ;;
#    esac
#}
#function list:remove() {
#    local -n self="${1:?}"
#    local -i index="${2:?}"
#    local -a view=(${self[3]})
#
#    if ((self[0] == 1818850164 && 0 <= (index <<= 1) && index < ${#view[@]})); then
#        ((self[2] += view[index+1], view[index+1] = 0))
#        self[3]="${view[*]}"
#
#        if ((self[1] && self[1] <= self[2])); then
#            list:defrag "${1}"
#        fi
#    fi
#}
#function list:delete() {
#    local -n self="${1:?}"
#    local -i index="${2:?}"
#    local -a view=(${self[3]})
#
#    if ((self[0] == 1818850164 && 0 <= (index <<= 1) && index < ${#view[@]})); then
#        ((self[2] += view[index+1]))
#        view+=([index]="" "")
#        view=(${view[*]})
#        self[3]="${view[*]}"
#
#        if ((self[1] && self[1] <= self[2])); then
#            list:defrag "${1}"
#        fi
#    fi
#}
#function list:set() {
#    list:update "${@}"
#}
#function list:get() {
#    local -n self="${1:?}" result="${3:?}"
#    local -i index="${2:?}"
#    local -a view=(${self[3]})
#
#    if ((self[0] == 1818850164 && 0 <= (index <<= 1) && index < ${#view[@]})); then
#        result=("${self[@]:view[index]:view[index+1]}")
#    fi
#}
#function list:defrag() {
#    local -n self="${1:?}"
#
#    if ((self[0] == 1818850164)); then
#        local -a view=(${self[3]}) temp=()
#        local -i index size="${#view[@]}"
#
#        list_new temp "${self[1]}"
#
#        for ((index = 0; index < size; index += 2)); do
#            temp+=("${self[@]:view[index]:view[index+1]}" [3]+="${#temp[@]} ${view[index+1]} ")
#        done
#
#        self=("${temp[@]}")
#    fi
#}
#function list:squash() {
#    local -n self="${1:?}"
#
#    if ((self[0] == 1818850164)); then
#        local -a view=(${self[3]})
#        local -i index size="${#view[@]}"
#
#        for ((index = 0; index < size; index += 2)); do
#            if ((!view[index+1])); then
#                view+=([index]="" "")
#            fi
#        done
#
#        view=(${view[*]})
#        self[3]="${view[*]}"
#    fi
#}
#function list:equals() {
#    local -n listA="${1:?}" listB="${2:?}"
#    local -a viewA=(${listA[3]}) viewB=(${listB[3]}) sliceA sliceB
#
#    if ((listA[0] == 1818850164 && listB[0] == 1818850164 && ${#viewA[@]} == ${#viewB[@]})); then
#        local -i idx1 idx2 va=${#viewA[@]} sa=${#sliceA[@]}
#
#        for ((idx1 = 0; idx1 < va; idx1 += 2)); do
#            if ((viewA[idx1+1] != viewB[idx1+1])); then
#                return 1
#            fi
#
#            sliceA=("${listA[@]:viewA[idx1]:viewA[idx1+1]}")
#            sliceB=("${listB[@]:viewB[idx1]:viewB[idx1+1]}")
#
#            for ((idx2 = 0; idx2 < sa; ++idx2)); do
#                if [[ "${sliceA[idx2]}" != "${sliceB[idx2]}" ]]; then
#                    return 1
#                fi
#            done
#        done
#    else
#        return 1
#    fi
#}
#function list:forEach() {
#    local -n self="${1:?}"
#    local -r func="${2:?}"
#    local -a view=(${self[3]})
#
#    if ((self[0] == 1818850164)) && declare -F "${func}" &> /dev/null; then
#        for ((index = 0; index < ${#view[@]}; index += 2)); do
#            "${func}" "${self[@]:view[index]:view[index+1]}"
#        done
#    fi
#}
#function list:filter() {
#    local -n self="${1:?}" result="${2:?}"
#    local -r func="${3:?}"
#    local -a view=(${self[3]})
#
#    if ((self[0] == 1818850164)) && declare -F "${func}" &> /dev/null; then
#        list:new "${2}"
#
#        for ((index = 0; index < ${#view[@]}; index += 2)); do
#            if "${func}" "${self[@]:view[index]:view[index+1]}"; then
#                result+=("${self[@]:view[index]:view[index+1]}" [3]+="${#result[@]} ${view[index+1]} ")
#            fi
#        done
#    fi
#}
#function list:map() {
#    local -n self="${1:?}" result="${2:?}"
#    local -r func="${3:?}"
#    local -a view=(${self[3]}) temp
#
#    if ((self[0] == 1818850164)) && declare -F "${func}" &> /dev/null; then
#        list:new "${2}"
#
#        for ((index = 0; index < ${#view[@]}; index += 2)); do
#            temp=()
#            "${func}" temp "${self[@]:view[index]:view[index+1]}"
#            result+=("${temp[@]}" [3]+="${#result[@]} ${#temp[@]} ")
#        done
#    fi
#}
