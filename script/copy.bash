function copy() { # array: ref -> list, ptr: ref -> int, len: int, newptr: int
    local -n a=${1:?};local -i b=("${!a[@]}") {c..i};((c=0,e=g=${#a[@]}-1,h=${2:?}+${3:?}));while((c<=e));do ((b[d=c+e>>1]<h?(c=(g=d)+1):(e=d-1)));done;((c=0,e=g));while((c<=e));do((b[d=c+e>>1]<$2?(c=d+1):(e=(f=d)-1)));done;for i in "${b[@]:f:h=(${2}=${4:?})-${!2},g-f+1}";do a[i+h]="${a[i]}";done
}
