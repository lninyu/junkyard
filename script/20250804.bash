__() {
    local -ir FALSE=DEAD=0 TRUE=WRAP=1 # border

    local -n ai=${1} ao=${2}
    local -i wx=${3} wy=${4}
    local -i sx=${5} sy=${6}
    local -i px=${7} py=${8}

    local -i x0 x1 x2
    local -i y0 y1 y2
    local -i t0 t1 t2
    local -i t3 t4 t5
    local -i no=()

    (( t0 = px + sx, t1 = px - 1, t2 = px + 1 ))
    (( t3 = py + sy, t4 = py - 1, t5 = py + 1 ))

    (( (x0 = wx ? (t0 - 1) % sx : 0 <= t1 && t1 < sx ? t1 : -1) ^ -1 )) || (( no[0] = -1, no[3] = -1, no[6] = -1 ))
    (( (x1 = wx ?  t0      % sx : 0 <= px && px < sx ? px : -1) ^ -1 )) || (( no[1] = -1, no[4] = -1, no[7] = -1 ))
    (( (x2 = wx ? (t0 + 1) % sx : 0 <= t2 && t2 < sx ? t2 : -1) ^ -1 )) || (( no[2] = -1, no[5] = -1, no[8] = -1 ))

    (( (y0 = wy ? (t3 - 1) % sy * sx : 0 <= t4 && t4 < sy ? t4 * sx : -1) ^ -1 )) || (( no[0] = -1, no[1] = -1, no[2] = -1 ))
    (( (y1 = wy ?  t3      % sy * sx : 0 <= py && py < sy ? py * sx : -1) ^ -1 )) || (( no[3] = -1, no[4] = -1, no[5] = -1 ))
    (( (y2 = wy ? (t3 + 1) % sy * sx : 0 <= t5 && t5 < sy ? t5 * sx : -1) ^ -1 )) || (( no[6] = -1, no[7] = -1, no[8] = -1 ))

    ao=(
        "~no[0] & ai[y0 + x0]" "~no[1] & ai[y0 + x1]" "~no[2] & ai[y0 + x2]"
        "~no[3] & ai[y1 + x0]" "~no[4] & ai[y1 + x1]" "~no[5] & ai[y1 + x2]"
        "~no[6] & ai[y2 + x0]" "~no[7] & ai[y2 + x1]" "~no[8] & ai[y2 + x2]"
    )
}

pseudo_enum() {
    local -ir A=FOO=0 FALSE=0
    local -ir B=BAR=1 TRUE=1
    local -ir C=BAZ=2
    local -ir D=QUX=3

    echo "${1:?} = $((${1^^}))"
}
