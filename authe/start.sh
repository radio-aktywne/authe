#!/bin/sh

envsub() {
  eval "cat <<EOF
$(cat "$1")
EOF
" 2>/dev/null
}

find ./conf -type f | while IFS= read -r file; do
  # shellcheck disable=SC2005
  echo "$(envsub "$file")" >"$file"
done

export "SELFSERVICE_ALLOWED_RETURN_URLS=$AUTHE_ALLOWED_RETURN_URLS"

kratos migrate sql --read-from-env --yes --config /app/conf/config.yaml
kratos serve --sqa-opt-out --config /app/conf/config.yaml
