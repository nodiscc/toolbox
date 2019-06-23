#!/bin/bash
# Description: install requirements for deployment script

set -o errexit
set -o nounset

source ./config
export curdir=$(dirname "$0")

if [[ -f "./bin/adb" ]]; then
    echo "[info] ADB already installed"
else
    echo "[info] downloading ADB ..."
    adb_url="https://dl.google.com/android/repository/platform-tools_r28.0.1-linux.zip"
    wget "$adb_url"
    echo "[info] Extracting ADB ..."
    unzip "./platform-tools*.zip"
    cp "./platform-tools/adb" "./bin/adb"
fi

if which java; then
    echo "[info] Java: OK"
else
    echo "[info@ Installing Java ..."
    sudo apt install default-jre
fi
