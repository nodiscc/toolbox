# LineageOS



<img style="float: right; margin: 10px; display: inline-block;" align="top" src="https://upload.wikimedia.org/wikipedia/commons/thumb/d/df/Screenshot_LineageOS_for_microG.png/800px-Screenshot_LineageOS_for_microG.png?20171111164357" height="200"> [LineageOS](https://en.wikipedia.org/wiki/LineageOS) is an operating system for smartphones, tablet computers, and set-top boxes, based on [Android](https://en.wikipedia.org/wiki/Android_(operating_system)) using mostly [Free and open-source software](https://en.wikipedia.org/wiki/Free_and_open-source_software).





## Requirements

- A phone from the [supported devices](https://wiki.lineageos.org/devices/) list. Most of these can be bought reconditioned/second-hand for a fraction of the cost. The exmaples below are for a €90 Samsung Galaxy A5 2016 - SM-A510F . Info about the device can be found at https://wiki.lineageos.org/devices/a5xelte. The [installation guide](https://wiki.lineageos.org/devices/a5xelte/install) provides all the information required to install LineageOS on this phone.
- A USB/micro-USB cable
- A computer to run the required flashing tools (Linux/Windows)
- [Android Debug Bridge](https://en.wikipedia.org/wiki/Android_software_development#ADB) (on debian-based Linux distributions, [install](https://wiki.debian.org/PackageManagement#Installing.2C_removing.2C_upgrading_software) the [`adb`](https://packages.debian.org/buster/adb) package)
- [Heimdall suite](https://www.androidfilehost.com/?w=files&flid=304516) (this is a LineageOS-maintained version of the original, unmaintained [Heimdall](https://www.glassechidna.com.au/heimdall/))
- The latest [TWRP](https://dl.twrp.me/a5xelte/) version for this device.

Download all required files to a single work directory:

```bash
Heimdall-linux-master-012220.zip
twrp-3.5.2_9-0-a5xelte.img
lineage-17.1-20210801-nightly-a5xelte-signed.zip
lineage-17.1-20210801-recovery-a5xelte.img # this file is not used
```

_Note:_ flashing custom firmware always presents a risk of bricking the device. Make sure the images being flashed are desgiend for your exact device/model.


## Enable USB debugging


## Install a recovery image (TWRP)

[Team Win Recovery Project (TWRP)](https://en.wikipedia.org/wiki/Team_Win_Recovery_Project) is an open-source software custom recovery image for Android-based devices.


<img style="float: right; margin: 10px; display: inline-block;" align="top" src="https://www.forecovery.com/wp-content/uploads/2017/07/samsung-download-mode.jpg" height="200"> 

- Extract `heimdall` from `Heimdall-linux-master-012220.zip` to the work directory
- Disconnect the phone USB cable, if any
- Power off the device
- Boot it into **download mode** by holding `Volume Down` + `Home` + `Power`
- Press the phone button for _Continue_ (`Volume Up`)
- Connect the USB cable between the phone and computer
- Open a terminal emulator/command-line prompt in the work directory, then run:

```
./heimdall flash --RECOVERY twrp-3.5.2_9-0-a5xelte.img --no-reboot
```

- A transfer bar will appear on the device showing the recovery image being flashed. Note: The device will continue to display `Downloading... Do not turn off target!!` even after the process is complete
- Unplug the USB cable from your device.
- Press the `Volume Down` + `Power buttons` for 8~10 seconds until the screen turns black & release the buttons *immediately* when it does. If you don’t, the stock ROM will reboot and overwrite the custom recovery with the stock recovery, and you’ll need to flash it again.


## Install LineageOS

<img style="float: right; margin: 10px; display: inline-block;" align="top" src="https://uploads.tapatalk-cdn.com/20190325/0185e3df6c7f9fab5bbe63182203c65f.jpg" height="200"> 

- Boot to TWRP recovery: `Volume Up` + `Home` + `Power`
- Unlock the device by swiping
- Tap `Wipe` and confirm by swiping, return to the previous menu
- Tap `Format Data` and confirm by swiping, return to the previous menu
- Tap `Advanced Wipe`, then select the `Cache` and `System` partitions and confirm by swiping, return to the previous menu
- Tap `Advanced` > `ADB Sideload` confirm by swiping
- On your computer, begin transfering the LineageOS package by running:

```bash
adb sideload lineage-17.1-20210801-nightly-a5xelte-signed.zip
```

- Reboot the device
- Follow the basic configuration steps for LineageOS


## F-Droid

[F-Droid](https://en.wikipedia.org/wiki/F-Droid) is a software repository for Android, serving a similar function to the Google Play store. The main repository, hosted by the project, contains only free and open source apps.

- [Download the F-Droid APK](https://f-droid.org/F-Droid.apk) and run it

<!--- TODO -------
### Automatic updates
----------->


## Trusting self-signed certificates

To let Android applications consume data from a web app/service that uses a self-signed TLS certificate, the certificate must be loaded to the Android certificate store. The certificate must have the `basicConstraints: "CA:TRUE"` and `key_usage: "digitalSignature,keyEncipherment"` flags set for Android to recognize it as a valid certificate.
- Export the certificate in PEM format (from a web browser or directly from the server's `.crt` file), transfer the file to the Android device
- Open the `.crt` file from the Android file browser, input a relevant name (eg. `rss.EXAMPLE.org self-signed`), tap `Import`


## Edit the phone's hosts file

With a non-rooted device it is impossible to edit the `/etc/hosts` file directly from the device. This must be done using `adb` (see installation instructions above) from a computer connected via USB:

```bash
# check that the device is attached and unlocked
adb devices
# remount the root filesystem read-write
adb remount
# pull a copy of the hosts file to the computer
adb pull /etc/hosts
# edit the file in a text editor, then
# push it back to the phone
adb push hosts /etc/hosts
```

Changes will be applied next time the device reconnects to a network.
