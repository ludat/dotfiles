#!/usr/bin/env bash

set -euo pipefail
set -x

app="$(memoize 10000 heroku apps | fzf)"
pg_uri="$(heroku config:get DATABASE_URL --app=$app)"
pgcli "$pg_uri"
