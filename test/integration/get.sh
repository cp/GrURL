#! /bin/bash

curl -X POST \
  -H "Content-Type: application/json" \
  -d'{"url":"http://jekyllrb.com/", "key":"some_key"}' \
  http://localhost:9292/

echo

curl http://localhost:9292/some_key/info

echo
