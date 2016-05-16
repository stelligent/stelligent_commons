#!/usr/bin/env bash
set -e

echo "In configure-jenkins.sh"
script_dir="$(dirname "$0")"

echo The value of arg 0 = $0
echo The value of arg 1 = $1 
echo The value of arg script_dir = $script_dir

uuid=$(date +%s)

echo The value of uuid = $uuid


sleep 20

