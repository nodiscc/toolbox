#!/bin/bash
# Description: deploy the application to all connected android devices
# Usage: ./deploy-apk-all-devices.sh

set -o errexit
set -o nounset

CURRENTDIR="$(dirname "$0")"

for i in $(./bin/adb devices | grep -v "List" | cut -f1); do
    "$CURRENTDIR/deploy-apk.sh" "$i"
done