```bash
function func() {
  [[ ${1:?} != var ]] && local -n var=${1}
}

func var
```
