# csi 1000 - 1003, 1006, 2004
function tui.input() {
    local a b LC_ALL="C" IFS=""

    while read -srn1 -d "" a; do
        case ${a} in
        $'\x1b')
            b+=$'\x1b'
            read -srn1 -d "" a

            case ${a} in
            $'\x5b')
                b+=$'\x5b'
                read -srn1 -d "" a

                case ${a} in
                $'\x32')
                    b+=$'\x32'
                    read -srn1 -d "" a

                    case ${a} in
                    $'\x30')
                        b+=$'\x30'
                        read -srn1 -d "" a

                        case ${a} in
                        $'\x30')
                            b+=$'\x30'
                            read -srn1 -d "" a

                            case ${a} in
                            $'\x7e')
                                b=()
                                while read -srn1 -d "" a; do
                                    b+="${a}"

                                    case ${b} in
                                    *$'\x1b\x5b\x32\x30\x31\x7e')
                                        echo -n "${b::${#b}-6}"
                                        b=
                                        break
                                    ;;
                                    esac
                                done
                            ;;
                            *)
                                echo -n "${b}${a}"
                            ;;
                            esac
                        ;;
                        *)
                            echo -n "${b}${a}"
                            b=
                        ;;
                        esac
                    ;;
                    *)
                        echo -n "${b}${a}"
                        b=
                    ;;
                    esac
                ;;
                $'\x3c')
                    b+=$'\x3c'
                    while read -srn1 -d "" a; do
                        case ${a} in
                        [Mm])
                            echo -n "${b}${a}"
                            b=
                            break
                        ;;
                        *)
                            b+="${a}"
                        ;;
                        esac
                    done
                ;;
                *)
                    echo -n "${b}${a}"
                    b=
                ;;
                esac
            ;;
            *)
                echo -n "${b}${a}"
                b=
            ;;
            esac
        ;;
        *)
            echo -n "${a}"
        ;;
        esac
    done
}
