
##  Install LineageOS on i9300

    * Basic_requirements
    * Preparing_for_installation
    * Installing_a_custom_recovery_using_heimdall
    * Installing_LineageOS_from_recovery
    * Get_assistance

Basic requirements
 Important: Please read through the instructions at least once completely
before actually following them to avoid any problems because you missed
something!

   1. Make sure your computer has working adb. Setup instructions can be found
      here.

   2. Enable USB_debugging on your device.

**Preparing for installation**

Samsung devices come with a unique boot mode called “Download mode”, which is
very similar to “Fastboot mode” on some devices with unlocked bootloaders.
Heimdall is a cross-platform, open-source tool for interfacing with Download
mode on Samsung devices. The preferred method of installing a custom recovery
is through this boot mode – rooting the stock firmware is neither necessary nor required.

   1. Download and install the Heimdall_suite:
          o Windows: Extract the Heimdall suite and take note of the directory
            containing heimdall.exe. You can verify Heimdall is working by
            opening a command prompt in that directory and typing heimdall
            version. If you receive an error, make sure you have the Microsoft
            Visual_C++_2012_Redistributable_Package_(x86) installed on your
            computer.
          o Linux: Pick the appropriate package to install for your
            distribution. The -frontend packages aren’t needed for this guide.
            After installation, verify Heimdall is installed by running
            heimdall version in the terminal.
          o macOS: Install the dmg package. After installation, Heimdall should
            be available from the terminal - type heimdall version to double-
            check.
   2. Power off the device and connect the USB adapter to the computer (but not
      to the device, yet).
   3. Boot into download mode:
          o With the device powered off, hold Home + Volume Down + Power.
      Accept the disclaimer, then insert the USB cable into the device.
   4. Windows only: install the drivers. A more complete set of instructions
      can be found in the ZAdiag_user_guide.
         1. Run zadiag.exe from the Drivers folder of the Heimdall suite.
         2. Choose Options » List all devices from the menu.
         3. Select Samsung USB Composite Device or MSM8x60 or Gadget Serial or
            Device Name from the drop down menu. (If nothing relevant appears,
            try uninstalling any Samsung related Windows software, like Samsung
            Windows drivers and/or Kies).
         4. Click Replace Driver (having to select Install Driver from the drop
            down list built into the button).
         5. If you are prompted with a warning that the installer is unable to
            verify the publisher of the driver, select Install this driver
            anyway. You may receive two more prompts about security. Select the
            options that allow you to carry on.
   5. On the computer, open a command prompt (on Windows) or terminal (on Linux
      or macOS) window, and type:
      heimdall print-pit
   6. If the device reboots, Heimdall is installed and working properly.
Installing a custom recovery using heimdall
   1. Download a custom recovery - you can download TWRP. Simply download the
      latest recovery file, named something like twrp-x.x.x-x-i9300.img.
   2. Power off the your device and connect the USB adapter to the computer
      (but not to the device, yet).
   3. Boot into download mode:
          o With the device powered off, hold Home + Volume Down + Power.
      Accept the disclaimer, then insert the USB cable into the device.
   4. On the computer, open a command prompt (on Windows) or terminal (on Linux
      or macOS) window in the directory the recovery image is located, and
      type:
      heimdall flash --RECOVERY twrp-x.x.x-x-i9300.img --no-reboot
       Tip: The file may not be named identically to what stands in this
      command, so adjust accordingly. If the file is wrapped in a zip or tar
      file, extract the file first, because Heimdall is not going to do it for
      you.
   5. A blue transfer bar will appear on the device showing the recovery being
      transferred.
   6. Unplug the USB cable from your device.
   7. Manually reboot into recovery:
          o With the device powered off, hold Home + Volume Up + Power.
       Note: Be sure to reboot into recovery immediately after having installed
      the custom recovery. Otherwise the custom recovery will be overwritten
      and the device will reboot (appearing as though your custom recovery
      failed to install).
Installing LineageOS from recovery
   1. Download the LineageOS_install_package that you’d like to install or
      build the package yourself.
          o Optionally, download additional application packages such as Google
            Apps (use the arm architecture).
   2. If you aren’t already in recovery, reboot into recovery:
          o With the device powered off, hold Home + Volume Up + Power.
   3. (Optional, but recommended): Tap the Backup button to create a backup.
      Make sure the backup is created in the external sdcard or copy it onto
      your computer as the internal storage will be formatted later in this
      process.
   4. Go back to return to main menu, then tap Wipe.
   5. Now tap Format Data and continue with the formatting process. This will
      remove encryption as well as delete all files stored on the internal
      storage.
   6. Return to the previous menu and tap Advanced Wipe.
   7. Select the Cache and System partitions to be wiped and then Swipe to
      Wipe.
   8. Sideload the LineageOS .zip package:
          o On the device, select “Advanced”, “ADB Sideload”, then swipe to
            begin sideload.
          o On the host machine, sideload the package using: adb sideload
            filename.zip
   9. (Optional): Install any additional packages using the same method.
       Note: If you want Google Apps on your device, you must follow this step
      before the first boot into Android!
  10. (Optional): Root the device by installing the LineageOS_SU_Addon (use the
      arm package) or using any other method you prefer.
  11. Once installation has finished, return to the main menu, tap Reboot, and
      then System.
Get assistance
If you have any questions or get stuck on any of the steps, feel free to ask on
our_subreddit or in #LineageOS_on_freenode.
[LineageOS Logo]
© 2016 - 2018 The LineageOS Project
Licensed under CC_BY-SA_3.0.
Site last generated: Dec 21, 2018
 Back_to_Top

