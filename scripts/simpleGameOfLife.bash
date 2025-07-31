step() {
    # a  n0, b  n1, c  n2, d  n3, e  n4, f  n5, g  n6, h  n7, i  n8, # neighbor count 0..8
    # j  tl,      , k  tr, l  cl,      , m  cr, n  bl,      , o  br
    # p ~tl, q ~tc, r ~tr, s ~cl, t ~cc, u ~cr, v ~bl, w ~bc, x ~br
    local -i {a..x}
    ((q= ~$8,p= ~(j=$8<<1|1&$3>>63),r= ~(k=0x7fffffffffffffff&$8>>1|$1<<63)))
    ((t= ~$5,s= ~(l=$5<<1|1&$6>>63),u= ~(m=0x7fffffffffffffff&$5>>1|$4<<63)))
    ((w= ~$2,v= ~(n=$2<<1|1&$9>>63),x= ~(o=0x7fffffffffffffff&$2>>1|$7<<63)))
    ((i=(h=(g=(f=(e=(d=(c=j&$8)&k)&l)&m)&n)&$2)&o))
    ((h=h&x|(g=g&w|(f=f&v|(e=e&u|(d=d&s|(c=c&r|(b=j^$8)&k)&l)&m)&n)&$2)&o))
    ((g=g&x|(f=f&w|(e=e&v|(d=d&u|(c=c&s|(b=b&r|(a=p&q)&k)&l)&m)&n)&$2)&o))
    ((f=f&x|(e=e&w|(d=d&v|(c=c&u|(b=b&s|(a=a&r)&l)&m)&n)&$2)&o))
    ((e=e&x|(d=d&w|(c=c&v|(b=b&u|(a=a&s)&m)&n)&$2)&o))
    ((d=d&x|(c=c&w|(b=b&v|(a=a&u)&n)&$2)&o))
    ((c=c&x|(b=b&w|(a=a&v)&$2)&o))
    ((b=b&x|(a=a&w)&o))
    ((a=a&x))
    (((${10}=t&(${11:-0})|$5&(${12:-0}))^$5))
}

print() {
    local -n _board=${1:?}
    local -i chunk pos
    local text

    for chunk in ${_board[@]}; do
        for pos in {63..0}; do
            text+=$((chunk >> pos & 1))
        done

        text+=$'\n'
    done

    : "${text//1/██}"
    echo "${_//0/░░}"
}

main() {
    local -r B="$(tr [0-8] [a-i] <<< "3|6")"
    local -r S="$(tr [0-8] [a-i] <<< "2|3")"
    local -i i size step next=() board=(
        0 0 0 0 0 0 0 0
        0 0 0 0 "7<<56" "1<<59" "1<<59" "1<<59"
        0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0)

    local char
    while
        print board
        read -srn1 -t.02 char || ((1))
    do
        [[ $char == q ]] && {
            echo -en $'\e[2J\e[H'
            break
        }

        for ((i = 0, size = ${#board[@]}; i < size; ++i)); do
            step board[$(( (i + size - 1) % size ))]{,,} board[$i]{,,} board[$(( (i + 1) % size ))]{,,} next[$i]
        done

        board=("${next[@]}")

        echo -en $'\e[K'"step:$((++step))"$'\e[H'
    done
}

echo -en $'\e[2J\e[H'
main

