```bash
function func() {
  [[ ${1:?} != var ]] && local -n var=${1}

  echo "${var}"

  # 増える問題
  # `$1 == var`の時と`$1 != var`の時で出力されるものが異なる
  echo "${!var}"
}

func var
```
