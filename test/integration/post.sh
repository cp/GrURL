#! /bin/bash

echo "No key specified..."

curl -X POST \
  -H "Content-Type: application/json" \
  -d'{"url":"http://jekyllrb.com/"}' \
  http://localhost:9292/

echo; echo

KEY=$(ruby -e "require 'securerandom'; puts SecureRandom.urlsafe_base64")

echo "The key '${KEY}' is specified..."

curl -X POST \
  -H "Content-Type: application/json" \
  -d"{\"url\":\"http://jekyllrb.com\",\"key\":\"${KEY}\"}" \
  http://localhost:9292/

echo
