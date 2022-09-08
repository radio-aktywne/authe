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

until [ -f /etc/certs/ca.pem ] &&
  [ -f /etc/certs/cert.pem ] &&
  [ -f /etc/certs/key.pem ] &&
  [ -f /etc/certs/client.cert.pem ] &&
  [ -f /etc/certs/client.key.pem ]; do
  echo "Waiting for certificates..."
  sleep 1
done

cat /etc/certs/ca.pem >>/etc/ssl/certs/ca-certificates.crt

kratos migrate sql --read-from-env --yes --config /app/conf/config.yaml
kratos serve --sqa-opt-out --config /app/conf/config.yaml
