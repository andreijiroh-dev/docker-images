#!/usr/bin/env bash

if [[ $DEBUG != "" ]]; then
  set -x
fi
COMMAND=$*

if [[ $1 = "serve" ]] || [[ $1 == "build" ]] || [[ $1 == "gh-deploy" ]] || [[ $1 == "new" ]] || [[ $1 == "--help" ]] || [[ $1 == "mkdocs" ]]; then
  exec "mkdocs $COMMAND"
else
  exec "$COMMAND"
fi
