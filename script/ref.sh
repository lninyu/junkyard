refget() {
    local a=$2
    while [[ ${!a} == \** ]]; do a=${!a:1}; done
    local -n b=$1; b=${!a}
}

refset() {
    local a=$1
    while [[ ${!a} == \** ]]; do a=${!a:1}; done
    local -n a=$a; a=$2
}
