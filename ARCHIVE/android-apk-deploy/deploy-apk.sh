#!/bin/bash
# Description: deploy APK to an android device matching a serial
# Usage: ./deploy-app.sh serial
set -o nounset
set -o errexit

source ./config
serial="$1"
adb="$adb_PATH -s $serial"
curdir="$(dirname "$0")"

convertsecs() {
 ((h=${1}/3600))
 ((m=(${1}%3600)/60))
 ((s=${1}%60))
 printf "%02d:%02d:%02d\n" $h $m $s
}

START_TIME="$SECONDS"

for i in "${applications[@]}"
do
  echo -e "$GREEN Uninstall old application : $i on $* $GREY"
  $adb uninstall "$i"
  echo -e "$GREEN Installation of application : $i on $* $GREY"
  $adb install -r "$curdir/APK/$i.apk"
  echo -e "$GREEN Content deploiement of application : $curdir/data/$i on /sdcard/Android/data/$i data folder\n on $* $GREY"
  $adb push "$curdir/data/$i" "/sdcard/Android/data/"
  echo -e "$GREEN Validate permissions of application $i on $* $GREY"
  $adb shell pm grant "$i" android.permission.ACCESS_FINE_LOCATION
  $adb shell pm grant "$i" android.permission.WRITE_EXTERNAL_STORAGE
  #$adb shell pm grant "$i" android.permission.ACCESS_WIFI_STATE
  #$adb shell pm grant "$i" android.permission.CHANGE_WIFI_STATE
  #$adb shell pm grant "$i" android.permission.CHANGE_WIFI_MULTICAST_STATE
  #$adb shell pm grant "$i" android.permission.CAMERA
  #$adb shell pm grant "$i" android.permission.BLUETOOTH
  echo -e "$GREEN Set application device owner : $i on $* $GREY"
  $adb shell dpm set-device-owner "$i/io.wezit.android.kiosk.receivers.KioskAdminReceiver"
  echo -e "$GREEN Disable android toast : $i on $* $GREY"
  $adb shell appops set android TOAST_WINDOW deny
done

ELAPSED_TIME=$(( SECONDS - START_TIME ))

echo -e "$GREY \t\t------------------------"
echo -e "$GREY \t\tDEVICE : $* \n \t\tDURATION : $(convertsecs $ELAPSED_TIME) \n"
echo -e "$GREY \t\t------------------------"
