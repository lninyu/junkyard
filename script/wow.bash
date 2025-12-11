declare -r LC_ALL=C IFS=

if (($#)); then
    echo $(($*))
else
    while read -r; do
        ( ((REPLY)) ) 2> /dev/null && echo "= $((REPLY))"
    done
fi
