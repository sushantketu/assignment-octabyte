#!/bin/bash
set -e

MESSAGE=$1

curl -X POST -H 'Content-type: application/json' \
  --data "{\"text\":\"$MESSAGE\"}" $SLACK_WEBHOOK_URL
