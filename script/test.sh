function @debug:run() {
    local file="${1:?}" line state=0 IFS=
    local regex1='^[[:blank:]]*#[[:blank:]]*@debug[[:blank:]]*$'
    local regex2='^[[:blank:]]*#[[:blank:]]*@debug:end[[:blank:]]*$'

    if [[ -f "${file}" ]]; then
        while read -r line; do
            if [[ "${line,,}" =~ ${regex1} ]]; then state=1
            elif [[ "${line,,}" =~ ${regex2} ]]; then state=0
            elif ((state)) && [[ "${line}" =~ ^[[:blank:]]*# ]]; then echo "${line#*"#"}"
            else echo "${line}"; state=0
            fi
        done < "${file}"
    fi
}

@debug:run script/list.sh
