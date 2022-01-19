# android-apk-deploy

Simple script to deploy .apk android applications over USB

## Usage

 - [Factory reset](https://support.google.com/android/answer/6088915) the target devices
 - Do not link a Google account at install time
 - [Enable devloper mode](https://developer.android.com/studio/debug/dev-options.html#enable)
 - Connect the devices over USB
 - Clone the repository `git clone`
 - Put your `.apk` files in `apk/`
 - Configure names of applications to deploy in `config`
 - Run `./install-requirements.sh` to install adb and java
 - Place app data/content in a directory under `data` (eg. `data/com.example.myapp`)
 - Deploy to all connected devices `./deploy-apk-all-devices.sh`
 - Or deploy to a single device:
   - Get the serial with `./bin/adb devices`
   - Run `./deploy-app.sh $SERIAL`

## License

WTFPL
