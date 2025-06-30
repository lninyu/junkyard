function math.min() {
    #= common.info "result=${1}, value=${2}, min=${3}"
    (($1=$2<$3?$2:$3))
}

function math.max() {
    #= common.info "result=${1}, value=${2}, max=${3}"
    (($1=$2>$3?$2:$3))
}

function math.min_list() {
    #= common.info "values=(${*:2})"
    local -n min=${1}; min=${2}
    local -i num
    shift 2
    for num;do ((min>num))&&((min=num));done
}

function math.max_list() {
    #= common.info "values=(${*:2})"
    local -n max=${1}; max=${2}
    local -i num
    shift 2
    for num;do ((max<num))&&((max=num));done
}

function math.inRange() {
    #= common.info "value=${1}, min=${2}, max=${3}"
    (($2<=$1&&$1<=$3))
}

function math.abs() {
    #= common.info "result=${1}, value=${2}"
    (($1=0x8000000000000000&$2?-$2:$2))
}

function math.sum() {
    #= common.info "values=(${*:2})"
    local -n i=${1}
    shift
    ((i=0${*/#/+}))
}

function math.avg() {
    #= common.info "values=(${*:2})"
    #= if (( ${#} - 1 == 0 )); then
    #=     common.error "length:${#} is 0."
    #= fi
    local -n i=${1}
    shift
    ((i=(0${*/#/+})/${#}))
}

function math.mod() {
    #= common.info "result=${1}, value=${2}, modulo=${3}"
    (($1=$2%$3,0x8000000000000000&$1))&&(($1+=$3))
}

function math.wrap() {
    #= common.info "result=${1}, value=${2}, min=${3}, max=${4}"
    #= if (( $4 - $3 + 1 == 0 )); then
    #=     common.error "range is 0."
    #= fi
    (($1=(($2-$3)%($1=$4-$3+1)+$1)%$1+$3))
}

function math.clamp() {
    #= common.info "result=${1}, value=${2}, min=${3}, max=${4}"
    #= if (( ${3} > ${4} )); then
    #=     common.error "min:${3} is greater than max:${4}."
    #= fi
    (($1=$2<$3?$3:$2>$4?$4:$2))
}
