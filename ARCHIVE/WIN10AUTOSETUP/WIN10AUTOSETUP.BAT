:: ╻ ╻╻┏┓╻╺┓ ┏━┓┏━┓╻ ╻╺┳╸┏━┓┏━┓┏━╸╺┳╸╻ ╻┏━┓
:: ┃╻┃┃┃┗┫ ┃ ┃┃┃┣━┫┃ ┃ ┃ ┃ ┃┗━┓┣╸  ┃ ┃ ┃┣━┛
:: ┗┻┛╹╹ ╹╺┻╸┗━┛╹ ╹┗━┛ ╹ ┗━┛┗━┛┗━╸ ╹ ┗━┛╹  
:: Windows 10 automated setup for offline/standalone personal gaming/multimedia machine
:: Removes/disables/blocks unneeded/annoying services/telemetry/updates
:: Installs basic preset software list
:: Applies basic configuration tweaks
:: Do not run in other Windows versions!
:: Use at your own risk.
:: Use a Free Software operating system such as GNU/Linux unless you really need Windows for a specific task.
:: This will not run in safe mode as some required services are not enabled.
:: Some registry settings (HKCU...) will only affect the current user. If you don't intend to run sysprep, you must set these registry settings from the user account you will be using (not the admin account)
:: License: MIT (https://opensource.org/licenses/MIT)
:: Sources: https://github.com/bmrf/tron, https://github.com/nodiscc/toolbox, https://community.spiceworks.com/scripts/show/3298-windows-10-decrapifier-version-1, https://github.com/dfkt/win10-unfuck, https://github.com/WindowsLies/BlockWindows, https://github.com/ReneNyffenegger/Configure-Windows
:: Known limitations:
:: - Blank tiles are displayed in the start menu after running the script. You have to remove the tiles manually.
:: - Running sysprep after this script does not actually work. Sysprep will complete but when booting a machin from the sysprepped image it will hang on the loading screen indefinitely. Just run the script locally...
:: TODO: check https://github.com/Disassembler0/Win10-Initial-Setup-Script/blob/master/Win10.ps1, https://github.com/W4RH4WK/Debloat-Windows-10/, https://github.com/szepeviktor/windows-workstation, https://ss64.com/nt/syntax-reghacks.html
::
:: USAGE :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
::
:: - Install Windows from an official Microsoft ISO image
:: - Run Windows Update, install all updates, Reboot as many times as necessary
:: - Enable the local Administrator account in MMC console "Users" (Computer > Manage)
:: - Logout, login as Administrator
:: - Save this script as WIN10AUTOSETUP.BAT (for example in C:\Users\Administrator\Desktop)
:: - Save unattend.xml and setacl.exe to the same directory as the script
::     unattend.xml will make the Administrator user profile the default template for new user accounts after sysprep
::     Setacl.exe by Helge Klein, Freeware, http://helgeklein.com/setacl/, SHA256 427ff43693cb3ca2812c4754f607f107a6b2d3f5a8b313addee57d89982df419
:: - Read the whole file, comment out unwanted changes
:: - Start Menu > cmd.exe (make sure it is running as Administrator)
:: - cd C:\Users\Administrator\Desktop\ && WIN7AUTOSETUP.BAT
:: - Wait for the script to complete
:: - Reboot
:: - Login as Administrator again, install/change/include any other software, preferences, files...
:: - Recheck that no more Windows updates are available
:: - Delete the original (non-Admin) user account, remove the corresponding user profile
:: - Run C:\Windows\System32\sysprep\sysprep.exe /generalize /oobe /shutdown /unattend:C:\Users\Administrator\Desktop\unattend.xml
::     This will prepare your system for cloning/deployment on any other computer, and shutdown.
:: - Clone the resulting disk image to the target machine's disk using dd/clonezilla/VM cloning tool
:: - Boot your machine, activate Windows.

:: PREP :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
prompt $

REM Kill helppane.exe if it's running (Usually on Win10+ in safe mode)
taskkill /f /im HelpPane.exe /t

REM Set system clock via NTP
sc config w32time start= auto
net stop w32time
w32tm /config /syncfromflags:manual /manualpeerlist:"2.pool.ntp.org,0x8 time.windows.com,0x8 time.nist.gov,0x8"
net start w32time
w32tm /resync /nowait

REM Enable MSIServer service
net start MSIServer

:: MISC SERVICES :::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

REM Misc services

REM Disable windows error reporting service (privacy)
net stop WerSvc
sc config WerSvc start= disabled

REM Disable offline files (no roaming profiles)
net stop cscservice
sc config cscservice start= disabled

REM Disable Volume Shadow Copy (VSS, windows backups) (use an external backup tool)
net stop VSS
sc config VSS start= disabled

REM Disable biometric services (fingerprint sensors) (only password auth allowed)
net stop WbioSrvc
sc config WbioSrvc start= disabled

REM Disable copy of user certificates and root certificates from smart cards (only password auth allowed)
net stop CertPropSvc
sc config CertPropSvc start= disabled

REM Disable NTFS link tracking (don't rely on NTFS-specific mechanisms)
net stop TrkWks
sc config TrkWks start= disabled

REM Disable Encrypting File System (proprietary crypto)
net stop EFS
sc config EFS start= disabled

REM Disable bitlocker (proprietary crypto)
net stop BDESVC
sc config BDESVC start= disabled

REM Disable Diagnostic Policy Service (problem detection, troubleshooting and resolution) (privacy, useless)
net stop DPS
net stop WdiSystemHost
sc config DPS start= disabled
sc config WdiSystemHost start= disabled

REM Disable file indexing (performance)
:: File searches will be slower
net stop WSearch
sc config WSearch start= disabled

:: REM Disable event log (disabled)
:: net stop eventlog
:: sc config eventlog start= disabled

:: REM Disable print spooler (disabled)
:: Printer service must ben enable manually
:: net stop Spooler
:: sc config Spooler start= disabled

:: REM Disable Themes service (performance, old style rendering, disabled)
:: net stop themes
:: sc config themes start= disabled

:: REM Disable scanners and cameras (disabled)
:: net stop stisvc
:: sc config stisvc start= disabled

:: REM Disable Tablet PC Input Service (disabled)
:: net stop TabletInputService
:: sc config TabletInputService start= disabled

:: REM Disable security center (disabled)
:: net stop wscsvc
:: sc config wscsvc start= disabled

:: REM Disable windows defender (performance) (disabled)
:: TODO must be done in safe mode
:: net stop WinDefend
:: sc config WinDefend start= disabled

:: NETWORKING SERVICES :::::::::::::::::::::::::::::::::::::::::::::::::::::::::

REM disable IPv6 oper IPv4
net stop iphlpsvc
sc config iphlpsvc start= disabled

REM Disable server (file, print, and named-pipe sharing) (security)
net stop LanmanServer
sc config LanmanServer start= disabled

REM Disable computer and resources network publication (security)
net stop FDResPub
sc config FDResPub start= disabled

REM Disable NetBIOS over TCP/IP (security)
net stop LmHosts
sc config LmHosts start= disabled

REM Disable Home Group (security)
net stop HomeGroupProvider
net stop HomeGroupListener
sc config HomeGroupProvider start= disabled
sc config HomeGroupListener start= disabled

REM Disable auto connection to remote network when a program calls a remote DNS or NetBIOS name (security)
net stop RasAuto
sc config RasAuto start= disabled

REM Disable direct DSL/Phone dialing (security)
net stop RasMan
sc config RasMan start= disabled

REM Disable Routing and Remote Access (security)
net stop RemoteAccess
sc config RemoteAccess start= disabled 

REM Disable remote registry (security)
net stop RemoteRegistry
sc config RemoteRegistry start= disabled

REM Disable network connection sharing (security)
net stop SharedAccess
net stop ALG
sc config SharedAccess start= disabled
sc config ALG start= disabled

REM Disable network uPnP devices detection (security)
net stop SSDPSRV
net stop fdPHost
sc config SSDPSRV start= disabled
sc config fdPHost start= disabled

REM Disable mobile broadband network autoconfiguration (security)
net stop WwanSvc
sc config WwanSvc start= disabled

REM Disable maintaining a list of network resources
:: When file sharing is enabled, network shares will take longer to discover
net stop Browser
sc config Browser start= disabled

:: REM Disable bluetooth (disabled)
:: net stop bthserv
:: sc config bthserv start= disabled


:: DEFAULT APPS/DEBLOAT :::::::::::::::::::::::::::::::::::::::::::::::::::::::::

REM Remove default Metro apps bloat (Windows 8 and up)
:: This command will re-install ALL default Windows 10 apps:
:: Get-AppxPackage -AllUsers| Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
:: Make sure the required service is started
net start AppXSVC

"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -File ".\metro_Microsoft_modern_apps_to_target_by_name.ps1"

REM Remove forced OneDrive integration
:: Make sure the presence of desktop.ini doesn't incorrectly trip the 'onedrive is in use' check
if exist "%USERPROFILE%\OneDrive\desktop.ini" del /f /q "%USERPROFILE%\OneDrive\desktop.ini"
taskkill /f /im OneDrive.exe
ping 127.0.0.1 -n 4
%SystemRoot%\System32\OneDriveSetup.exe /uninstall
%SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall
ping 127.0.0.1 -n 12
takeown /f "%LocalAppData%\Microsoft\OneDrive" /r /d y
icacls "%LocalAppData%\Microsoft\OneDrive" /grant administrators:F /t
rmdir /s /q "%LocalAppData%\Microsoft\OneDrive"
rmdir /s /q "%ProgramData%\Microsoft OneDrive"
rmdir /s /q "%SystemDrive%\OneDriveTemp"
REM These two registry entries disable OneDrive links in the Explorer side pane
reg add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v System.IsPinnedToNameSpaceTree /t reg_dword /d 0 /f
reg add "HKCR\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v System.IsPinnedToNameSpaceTree /t reg_dword /d 0 /f

REM Disable "how-to" tips appearing in Win8+
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableSoftLanding /t reg_dword /d 1 /f

REM Disabling delivery optimization for local machine...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /T REG_DWORD /V "DODownloadMode" /D 0 /F
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /V "DownloadMode" /T REG_DWORD /D 0 /F
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /V "DODownloadMode" /T REG_DWORD /D 0 /F

REM Changing delivery optimization download mode for this user...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization" /T REG_DWORD /V "SystemSettingsDownloadMode" /D 3 /F

REM Disabling auto update and download of Windows Store Apps...
reg add "HKCU\SOFTWARE\Policies\Microsoft\WindowsStore" /T REG_DWORD /V "AutoDownload" /D 2 /F

REM Disabling Suggested Apps, Feedback, Lockscreen Spotlight, and unwanted app installs for this user...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager\" /T REG_DWORD /V "SystemPaneSuggestionsEnabled" /D 0 /F
reg add "HKCU\Software\Microsoft\CurrentVersion\ContentDeliveryManager\" /T REG_DWORD /V "SoftLandingEnabled" /D 0 /F
reg add "HKCU\Software\Microsoft\CurrentVersion\ContentDeliveryManager\" /T REG_DWORD /V "RotatingLockScreenEnable" /D 0 /F
reg add "HKCU\Software\Microsoft\CurrentVersion\ContentDeliveryManager\" /T REG_DWORD /V "PreInstalledAppsEnabled" /D 0 /F
reg add "HKCU\Software\Microsoft\CurrentVersion\ContentDeliveryManager\" /T REG_DWORD /V "SilentInstalledAppsEnabled" /D 0 /F
reg add "HKCU\Software\Microsoft\CurrentVersion\ContentDeliveryManager\" /T REG_DWORD /V "ContentDeliveryAllowed" /D 0 /F
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced\" /T REG_DWORD /V "ShowSyncProviderNotifications" /D 0 /F

REM Disabling Cloud-Content for this machine...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent\" /T REG_DWORD /V "DisableWindowsConsumerFeatures" /D 1 /F

REM Disabling OneDrive for local machine...
reg add "HKLM\Software\Policies\Microsoft\Windows\OneDrive" /T REG_DWORD /V "DisableFileSyncNGSC" /D 1 /F
reg add "HKLM\Software\Policies\Microsoft\Windows\OneDrive" /T REG_DWORD /V "DisableFileSync" /D 1 /F

REM Disabling Onedrive startup run for this user...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /T REG_BINARY /V "OneDrive" /D 0300000021B9DEB396D7D001 /F


::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

REM Disable fully automatic reboot while users are logged on
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoRebootWithLoggedOnUsers" /t REG_DWORD /d "1" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AlwaysAutoRebootAtScheduledTime" /t REG_DWORD /d "0" /f

REM Show UAC Allow/Deny prompt for all privilegied operations, including from Windows binaries
:: https://msdn.microsoft.com/en-us/library/cc232761.aspx
:: Set to 1 to ask for password on UAC prompt
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "ConsentPromptBehaviorAdmin" /t REG_DWORD /d "2" /f

REM Disable SMBv1, SMBv2, SMBv3
:: Disables file sharing
:: https://support.microsoft.com/fr-fr/help/2696547/how-to-enable-and-disable-smbv1-smbv2-and-smbv3-in-windows-and-windows-server
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "Disable-WindowsOptionalFeature -NoRestart -Online -FeatureName SMB1Protocol"
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "Set-SmbServerConfiguration -EnableSMB2Protocol $false"
:: TODO requires confirmation

REM Disable windows features (mediaplayer/xpsviewer)
Dism /online /NoRestart /Disable-Feature /FeatureName:WindowsMediaPlayer
Dism /online /NoRestart /Disable-Feature /FeatureName:Xps-Foundation-Xps-Viewer
:: TODO remove more useless features

:: REM Hide search in taskbar (disabled)
::reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "SearchboxTaskbarMode" /t REG_DWORD /d "0" /f

REM Always show all icons and notifications on the taskbar
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "EnableAutoTray" /t REG_DWORD /d "2" /f

REM Explorer show all folders including Recycle Bin, Desktop, Control Panel
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "NavPaneShowAllFolders" /t REG_DWORD /d "1" /f

REM Explorer Show file extensions
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t REG_DWORD /d "1" /f

REM Explorer, Show hidden files
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d "1" /f

:: REM Explorer Really, show ALL hidden Files (disabled)
:: reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v SuperHidden /t REG_DWORD  /d "0" /f 
:: reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSuperHidden /t REG_DWORD /d "1" /f 

REM Explorer don't generate Thumbs.db files for local files
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v DisableThumbnailCache /t REG_DWORD /d 1 /f

REM Explorer don't ask to search the internet for the correct program when opening a file with an unknown extension
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoInternetOpenWith /t REG_DWORD /d 1 /f

:: REM Explorer, open to This PC (broken?) (disabled)
:: reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t REG_DWORD /d "0" /f

REM No Glomming (keep every icon on the taskbar separate)
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "TaskbarGlomming" /t REG_DWORD /d "0" /f

REM Start menu speed - the default is 400
reg add "HKEY_CURRENT_USER\Control Panel\Desktop" /v "MenuShowDelay" /d "50" /f

REM Don't hide the log-off option from the Start Menu
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "StartMenuLogOff" /t REG_DWORD /d "1" /f

REM Download windows updates but don't install automatically
reg add "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update" /v "AUOptions" /t REG_DWORD /d "3" /f

REM When opening files with an unknown extension, dont prompt to 'Look for an app in the Store'
reg add "HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows\Explorer" /v "NoUseStoreOpenWith" /t REG_DWORD /d "3" /f

REM Disable event sounds
reg add "HKEY_USERS\.DEFAULT\AppEvents\Schemes" /v "Default" /d ".NONE" /f

REM Disable AutoPlay
reg add "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\AutoplayHandlers" /v "DisableAutoplay" /t REG_DWORD /d "0" /f

REM Configure sysprep not to remove manually installed drivers (disabled)
:: reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Setup\Syspre\Settings\sppnp" /v PersistAllDeviceInstalls /t REG_DWORD /d 1 /f

REM create godmode directory on desktop
mkdir C:\Users\Public\Desktop\GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}

:: TELEMETRY :::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: Remove Windows 10 telemetry-related updates
REM KB 2902907 (https://support.microsoft.com/en-us/kb/2902907)
start /wait "" wusa /uninstall /kb:2902907 /norestart /quiet
REM KB 2922324 (https://support.microsoft.com/en-us/kb/2922324)
start /wait "" wusa /uninstall /kb:2922324 /norestart /quiet
REM KB 2952664 (https://support.microsoft.com/en-us/kb/2952664)
start /wait "" wusa /uninstall /kb:2952664 /norestart /quiet
REM KB 2976978 (https://support.microsoft.com/en-us/kb/2976978)
start /wait "" wusa /uninstall /kb:2976978 /norestart /quiet
REM KB 2977759 (https://support.microsoft.com/en-us/kb/2977759)
start /wait "" wusa /uninstall /kb:2977759 /norestart /quiet
REM KB 2990214 (https://support.microsoft.com/en-us/kb/2990214)
start /wait "" wusa /uninstall /kb:2990214 /norestart /quiet
REM KB 3012973 (https://support.microsoft.com/en-us/kb/3012973)
start /wait "" wusa /uninstall /kb:3012973 /norestart /quiet
REM KB 3014460 (https://support.microsoft.com/en-us/kb/3014460)
start /wait "" wusa /uninstall /kb:3014460 /norestart /quiet
REM KB 3015249 (https://support.microsoft.com/en-us/kb/3015249)
start /wait "" wusa /uninstall /kb:3015249 /norestart /quiet
REM KB 3021917 (https://support.microsoft.com/en-us/kb/3021917)
start /wait "" wusa /uninstall /kb:3021917 /norestart /quiet
REM KB 3022345 (https://support.microsoft.com/en-us/kb/3022345)
start /wait "" wusa /uninstall /kb:3022345 /norestart /quiet
REM KB 3035583 (https://support.microsoft.com/en-us/kb/3035583)
start /wait "" wusa /uninstall /kb:3035583 /norestart /quiet
REM KB 3044374 (https://support.microsoft.com/en-us/kb/3044374)
start /wait "" wusa /uninstall /kb:3044374 /norestart /quiet
REM KB 3050265 (https://support.microsoft.com/en-us/kb/3050265)
start /wait "" wusa /uninstall /kb:3050265 /norestart /quiet
REM KB 3050267 (https://support.microsoft.com/en-us/kb/3050267)
start /wait "" wusa /uninstall /kb:3050267 /norestart /quiet
REM KB 3065987 (https://support.microsoft.com/en-us/kb/3065987)
start /wait "" wusa /uninstall /kb:3065987 /norestart /quiet
REM KB 3068708 (https://support.microsoft.com/en-us/kb/3068708)
start /wait "" wusa /uninstall /kb:3068708 /norestart /quiet
REM KB 3075249 (https://support.microsoft.com/en-us/kb/3075249)
start /wait "" wusa /uninstall /kb:3075249 /norestart /quiet
REM KB 3075851 (https://support.microsoft.com/en-us/kb/3075851)
start /wait "" wusa /uninstall /kb:3075851 /norestart /quiet
REM KB 3075853 (https://support.microsoft.com/en-us/kb/3075853)
start /wait "" wusa /uninstall /kb:3075853 /norestart /quiet
REM KB 3080149 (https://support.microsoft.com/en-us/kb/3080149)
start /wait "" wusa /uninstall /kb:3080149 /norestart /quiet
REM Additional KB entries removed by Microsoft; originally associated with telemetry
start /wait "" wusa /uninstall /kb:2976987 /norestart /quiet
start /wait "" wusa /uninstall /kb:3068707 /norestart /quiet

:: Batch 1
start "" /b /wait cscript.exe ".\block_windows_updates.vbs" 3080149 3075853 3075851 3075249 3068708 3068707 3065987 3050267 3050265 3044374 3035583 3022345 

:: Batch 2
start "" /b /wait cscript.exe ".\block_windows_updates.vbs" 3021917 3015249 3014460 3012973 2990214 2977759 2976987 2976978 2952664 2922324 2902907

:: See also https://serverfault.com/questions/145843/block-specific-windows-update-hotfix/341318

:: Remove telemetry-related scheduled tasks
schtasks /delete /F /TN "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser"
schtasks /delete /F /TN "\Microsoft\Windows\Application Experience\ProgramDataUpdater"
schtasks /delete /F /TN "\Microsoft\Windows\Autochk\Proxy"
schtasks /delete /F /TN "\Microsoft\Windows\Customer Experience Improvement Program\Consolidator"
schtasks /delete /F /TN "\Microsoft\Windows\Customer Experience Improvement Program\KernelCeipTask"
schtasks /delete /F /TN "\Microsoft\Windows\Customer Experience Improvement Program\UsbCeip"
schtasks /delete /F /TN "\Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector"
schtasks /delete /F /TN "\Microsoft\Windows\PI\Sqm-Tasks"
schtasks /delete /F /TN "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem"
schtasks /delete /F /TN "\Microsoft\Windows\Windows Error Reporting\QueueReporting"
schtasks /delete /f /tn "\Microsoft\Windows\application experience\Microsoft compatibility appraiser"
schtasks /delete /f /tn "\Microsoft\Windows\application experience\aitagent"
schtasks /delete /f /tn "\Microsoft\Windows\application experience\programdataupdater"
schtasks /delete /f /tn "\Microsoft\Windows\autochk\proxy"
schtasks /delete /f /tn "\Microsoft\Windows\customer experience improvement program\consolidator"
schtasks /delete /f /tn "\Microsoft\Windows\customer experience improvement program\kernelceiptask"
schtasks /delete /f /tn "\Microsoft\Windows\customer experience improvement program\usbceip"
schtasks /delete /f /tn "\Microsoft\Windows\diskdiagnostic\Microsoft-Windows-diskdiagnosticdatacollector"
schtasks /delete /f /tn "\Microsoft\Windows\maintenance\winsat"
schtasks /delete /f /tn "\Microsoft\Windows\media center\activateWindowssearch"
schtasks /delete /f /tn "\Microsoft\Windows\media center\configureinternettimeservice"
schtasks /delete /f /tn "\Microsoft\Windows\media center\dispatchrecoverytasks"
schtasks /delete /f /tn "\Microsoft\Windows\media center\ehdrminit"
schtasks /delete /f /tn "\Microsoft\Windows\media center\installplayready"
schtasks /delete /f /tn "\Microsoft\Windows\media center\mcupdate"
schtasks /delete /f /tn "\Microsoft\Windows\media center\mediacenterrecoverytask"
schtasks /delete /f /tn "\Microsoft\Windows\media center\objectstorerecoverytask"
schtasks /delete /f /tn "\Microsoft\Windows\media center\ocuractivate"
schtasks /delete /f /tn "\Microsoft\Windows\media center\ocurdiscovery"
schtasks /delete /f /tn "\Microsoft\Windows\media center\pbdadiscovery"
schtasks /delete /f /tn "\Microsoft\Windows\media center\pbdadiscoveryw1"
schtasks /delete /f /tn "\Microsoft\Windows\media center\pbdadiscoveryw2"
schtasks /delete /f /tn "\Microsoft\Windows\media center\pvrrecoverytask"
schtasks /delete /f /tn "\Microsoft\Windows\media center\pvrscheduletask"
schtasks /delete /f /tn "\Microsoft\Windows\media center\registersearch"
schtasks /delete /f /tn "\Microsoft\Windows\media center\reindexsearchroot"
schtasks /delete /f /tn "\Microsoft\Windows\media center\sqlliterecoverytask"
schtasks /delete /f /tn "\Microsoft\Windows\media center\updaterecordpath"

:: Remove bad services
:: Diagnostic Tracking
net stop Diagtrack
sc config Diagtrack start= disabled

:: Retail Demo
net stop RetailDemo
sc delete RetailDemo

:: "WAP Push Message Routing Service"
net stop dmwappushservice
sc config dmwappushservice start= disabled

:: Windows Event Collector Service
net stop Wecsvc
sc config Wecsvc start= disabled

:: Xbox Live services
net stop XblAuthManager
net stop XblGameSave
net stop XboxNetApiSvc
sc config XblAuthManager start= disabled
sc config XblGameSave start= disabled
sc config XboxNetApiSvc start= disabled

:: Toggle official MS telemetry registry entries
REM GPO options to disable telemetry
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Wow6432Node\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d "0" /f

REM Diagtrack keylogger
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /v "Start" /t REG_DWORD /d "0" /f

REM Wifi sense
reg add "HKLM\software\microsoft\wcmsvc\wifinetworkmanager" /v "wifisensecredshared" /t REG_DWORD /d "0" /f
reg add "HKLM\software\microsoft\wcmsvc\wifinetworkmanager" /v "wifisenseopen" /t REG_DWORD /d "0" /f

REM Windows Defender sample reporting
reg add "HKLM\software\microsoft\windows defender\spynet" /v "spynetreporting" /t REG_DWORD /d "0" /f
reg add "HKLM\software\microsoft\windows defender\spynet" /v "submitsamplesconsent" /t REG_DWORD /d "0" /f

REM SkyDrive
reg add "HKLM\software\policies\microsoft\windows\skydrive" /v "disablefilesync" /t REG_DWORD /d "1" /f

REM Kill OneDrive from hooking into Explorer even when disabled
reg add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d "0" /f
reg add "HKCR\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /v "System.IsPinnedToNameSpaceTree" /t REG_DWORD /d "0" /f

REM DiagTrack service
reg add "HKLM\SYSTEM\CurrentControlSet\Services\DiagTrack" /v "Start" /t REG_DWORD /d "4" /f

REM "WAP Push Message Routing Service"
reg add "HKLM\SYSTEM\CurrentControlSet\Services\dmwappushservice" /v "Start" /t REG_DWORD /d "4" /f

REM Disable Cortana globally
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortanaAboveLock" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowSearchToUseLocation" /t REG_DWORD /d "0" /f

REM Disable "Search online and include web results"
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d "0" /f

REM Disabling telemetry for local machine...
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /T REG_DWORD /V "AllowTelemetry" /D 0 /F
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Metadata" /V "PreventDeviceMetadataFromNetwork" /T REG_DWORD /D 1 /F
reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /V "DontOfferThroughWUAU" /T REG_DWORD /D 1 /F
reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /V "CEIPEnable" /T REG_DWORD /D 0 /F
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /V "AITEnable" /T REG_DWORD /D 0 /F
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /V "DisableUAR" /T REG_DWORD /D 1 /F

REM Setting Windows 10 privacy options for this user...
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /T REG_DWORD /V "LetAppsAccessAccountInfo" /D 2 /F
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /T REG_DWORD /V "Enabled" /D 0 /F
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AppHost" /T REG_DWORD /V "EnableWebContentEvaluation" /D 0 /F
reg add "HKCU\SOFTWARE\Microsoft\Input\TIPC" /T REG_DWORD /V "Enabled" /D 0  /F
reg add "HKCU\Control Panel\International\User Profile" /T REG_DWORD /V "HttpAcceptLanguageOptOut" /D 1 /F
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /T REG_SZ /V Value /D DENY /F
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E5323777-F976-4f5b-9B55-B94699C46E44}" /T REG_SZ /V Value /D DENY /F
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{2EEF81BE-33FA-4800-9670-1CD474972C3F}" /T REG_SZ /V Value /D DENY /F
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{C1D23ACC-752B-43E5-8448-8D0E519CD6D6}" /T REG_SZ /V Value /D DENY /F
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E5323777-F976-4f5b-9B55-B94699C46E44}" /T REG_SZ /V Value /D DENY /F
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{D89823BA-7180-4B81-B50C-7E471E6121A3}" /T REG_SZ /V Value /D DENY /F
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{992AFA70-6F47-4148-B3E9-3003349C1548}" /T REG_SZ /V Value /D DENY /F
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{A8804298-2D5F-42E3-9531-9C8C39EB29CE}" /T REG_SZ /V Value /D DENY /F
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled" /T REG_SZ /V Value /D DENY /F
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{D89823BA-7180-4B81-B50C-7E471E6121A3}" /T REG_SZ /V Value /D DENY /F
reg add "HKCU\SOFTWARE\Microsoft\Personalization\Settings" /T REG_DWORD /V "AcceptedPrivacyPolicy" /D 0 /F
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SettingSync\Groups\Language" /T REG_DWORD /V "Enabled" /D 0 /F
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /T REG_DWORD /V "RestrictImplicitTextCollection" /D 1 /F
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization" /T REG_DWORD /V "RestrictImplicitInkCollection" /D 1 /F
reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /T REG_DWORD /V "HarvestContacts" /D 0 /F
reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /T REG_DWORD /V "NumberOfSIUFInPeriod" /D 0 /F

REM Disallowing apps from accessing account info on this machine...
reg add "HKLM\Software\Policies\Microsoft\Windows\AppPrivacy" /T REG_DWORD /V "LetAppsAccessAccountInfo" /D 2 /F

REM Disallowing Cortana and web connected search through local machine policy...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /V "AllowCortana" /T REG_DWORD /D 0 /F
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /V "ConnectedSearchUseWeb" /T REG_DWORD /D 0 /F

REM Disabling Cortana and Bing search for this user...
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /V "CortanaEnabled" /T REG_DWORD /D 0 /F
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /V "SearchboxTaskbarMode" /T REG_DWORD /D 0 /F
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /V "BingSearchEnabled" /T REG_DWORD /D 0 /F
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /V "DeviceHistoryEnabled" /T REG_DWORD /D 0 /F

REM Disabling some unecessary scheduled tasks...
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "Get-Scheduledtask SmartScreenSpecific,Microsoft Compatibility Appraiser,Consolidator,KernelCeipTask,UsbCeip,Microsoft-Windows-DiskDiagnosticDataCollector,GatherNetworkInfo,QueueReporting | Disable-scheduledtask"

REM Stopping and disabling diagnostics tracking services, Onedrive sync service, various Xbox services, Distributed Link Tracking, and Windows Media Player network sharing (you can turn this back on if you share your media libraries with WMP)...
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "Get-Service Diagtrack,DmwApPushService,OneSyncSvc,XblAuthManager,XblGameSave,XboxNetApiSvc,TrkWks,WMPNetworkSvc | stop-service -passthru | set-service -startuptype disabled"

:: NULL ROUTE BAD HOSTS
:: Run 'route -f' to flush ALL routes IMMEDIATELY. It will delete your default route so you'll need to reboot or do an ipconfig /release & ipconfig /renew to get back online
:: Run this command to clear persistent routes only, takes effect at reboot. This will undo all the below changes
::reg delete HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\PersistentRoutes /va /f
:: The reason we can't do this via firewall ACL entries or host file entries is because Windows maliciously ignores any rules blocking access to telemetry servers.
:: Currently the only known solution is installing null-routes in the route table.
:: a-0001.a-msedge.net
route -p add 204.79.197.200/32 0.0.0.0
:: a23-218-212-69.deploy.static.akamaitechnologies.com
route -p add 23.218.212.69/32 0.0.0.0
:: a.ads1.msn.com
route -p add 204.160.124.125/32 0.0.0.0
route -p add 8.253.14.126/32 0.0.0.0
route -p add 8.254.25.126/32 0.0.0.0
:: a.ads2.msads.net
route -p add 93.184.215.200/32 0.0.0.0
:: a.ads2.msn.com
route -p add 198.78.194.252/32 0.0.0.0
route -p add 198.78.209.253/32 0.0.0.0
route -p add 8.254.23.254/32 0.0.0.0
:: ac3.msn.com
route -p add 131.253.14.76/32 0.0.0.0
:: ads1.msads.net
route -p add 23.201.58.73/32 0.0.0.0
:: ads1.msn.com
route -p add 204.160.124.125/32 0.0.0.0
route -p add 8.253.14.126/32 0.0.0.0
route -p add 8.254.25.126/32 0.0.0.0
:: adsmockarc.azurewebsites.net
route -p add 191.236.16.12/32 0.0.0.0
:: ads.msn.com
route -p add 157.56.91.82/32 0.0.0.0
:: auth.gfx.ms
route -p add 23.61.72.70/32 0.0.0.0
:: b.ads1.msn.com
route -p add 204.160.124.125/32 0.0.0.0
route -p add 8.253.14.126/32 0.0.0.0
route -p add 8.254.25.126/32 0.0.0.0
:: b.ads2.msads.net
route -p add 93.184.215.200/32 0.0.0.0
:: df.telemetry.microsoft.com
route -p add 65.52.100.7/32 0.0.0.0
:: help.bingads.microsoft.com
route -p add 207.46.202.114/32 0.0.0.0
:: oca.telemetry.microsoft.com
route -p add 65.55.252.63/32 0.0.0.0
:: oca.telemetry.microsoft.com.nsatc.net
route -p add 65.55.252.63/32 0.0.0.0
:: pre.footprintpredict.com
route -p add 204.79.197.200/32 0.0.0.0
:: reports.wes.df.telemetry.microsoft.com
route -p add 65.52.100.91/32 0.0.0.0
:: sb.scorecardresearch.com
route -p add 104.79.156.195/32 0.0.0.0
:: services.wes.df.telemetry.microsoft.com
route -p add 65.52.100.92/32 0.0.0.0
:: settings-win.data.microsoft.com
route -p add 65.55.44.108/32 0.0.0.0
:: s.gateway.messenger.live.com
route -p add 157.56.106.210/32 0.0.0.0
:: sgmetrics.cloudapp.net
route -p add 168.62.11.145/32 0.0.0.0
:: spynet2.microsoft.com
route -p add 23.96.212.225/32 0.0.0.0
:: spynetalt.microsoft.com
route -p add 23.96.212.225/32 0.0.0.0
:: sqm.df.telemetry.microsoft.com
route -p add 65.52.100.94/32 0.0.0.0
:: sqm.telemetry.microsoft.com
route -p add 65.55.252.93/32 0.0.0.0
:: sqm.telemetry.microsoft.com.nsatc.net
route -p add 65.55.252.93/32 0.0.0.0
:: statsfe1.ws.microsoft.com
route -p add 134.170.115.60/32 0.0.0.0
route -p add 207.46.114.61/32 0.0.0.0
:: statsfe2.update.microsoft.com.akadns.net
route -p add 65.52.108.153/32 0.0.0.0
:: statsfe2.ws.microsoft.com
route -p add 64.4.54.22/32 0.0.0.0
:: storeedgefd.dsx.mp.microsoft.com
route -p add 104.79.153.53/32 0.0.0.0
:: telecommand.telemetry.microsoft.com
route -p add 65.55.252.92/32 0.0.0.0
:: telecommand.telemetry.microsoft.com.nsatc.net
route -p add 65.55.252.92/32 0.0.0.0
:: telemetry.appex.bing.net
route -p add 168.62.187.13/32 0.0.0.0
:: telemetry.microsoft.com
route -p add 65.52.100.9/32 0.0.0.0
:: telemetry.urs.microsoft.com
route -p add 131.253.40.37/32 0.0.0.0
:: vortex.data.microsoft.com
route -p add 64.4.54.254/32 0.0.0.0
:: vortex-sandbox.data.microsoft.com
route -p add 64.4.54.32/32 0.0.0.0
:: vortex-win.data.microsoft.com
route -p add 64.4.54.254/32 0.0.0.0
:: watson.live.com
route -p add 207.46.223.94/32 0.0.0.0
:: watson.microsoft.com
route -p add 65.55.252.71/32 0.0.0.0
:: watson.ppe.telemetry.microsoft.com
route -p add 65.52.100.11/32 0.0.0.0
:: watson.telemetry.microsoft.com
route -p add 65.52.108.29/32 0.0.0.0
:: watson.telemetry.microsoft.com.nsatc.net
route -p add 65.52.108.29/32 0.0.0.0
:: wes.df.telemetry.microsoft.com
route -p add 65.52.100.93/32 0.0.0.0

:: Kill GWX/Skydrive/Spynet/Telemetry/waitifisense/etc
taskkill /f /im gwx.exe /t
:: Set administrator ownership on protected system registry keys
setacl.exe -on "hkey_local_machine\software\microsoft\wcmsvc\wifinetworkmanager" -ot reg -actn setowner -ownr n:administrators
setacl.exe -on "hkey_local_machine\software\microsoft\wcmsvc\wifinetworkmanager" -ot reg -actn ace -ace "n:administrators;p:full"
setacl.exe -on "hkey_local_machine\software\microsoft\windows\currentversion\windowsupdate\auto update" -ot reg -actn setowner -ownr n:administrators
setacl.exe -on "hkey_local_machine\software\microsoft\windows\currentversion\windowsupdate\auto update" -ot reg -actn ace -ace "n:administrators;p:full"
setacl.exe -on "hkey_local_machine\software\microsoft\windows defender\spynet" -ot reg -actn setowner -ownr n:administrators
setacl.exe -on "hkey_local_machine\software\microsoft\windows defender\spynet" -ot reg -actn ace -ace "n:administrators;p:full"
setacl.exe -on "hkey_local_machine\software\policies\microsoft\windows\datacollection" -ot reg -actn setowner -ownr n:administrators
setacl.exe -on "hkey_local_machine\software\policies\microsoft\windows\datacollection" -ot reg -actn ace -ace "n:administrators;p:full"
setacl.exe -on "hkey_local_machine\software\policies\microsoft\windows\gwx" -ot reg -actn setowner -ownr n:administrators
setacl.exe -on "hkey_local_machine\software\policies\microsoft\windows\gwx" -ot reg -actn ace -ace "n:administrators;p:full"
setacl.exe -on "hkey_local_machine\software\policies\microsoft\windows\skydrive" -ot reg -actn setowner -ownr n:administrators
setacl.exe -on "hkey_local_machine\software\policies\microsoft\windows\skydrive" -ot reg -actn ace -ace "n:administrators;p:full"

:: Kill pending tracking reports
if not exist %ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\ mkdir %ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\
echo. > %ProgramData%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl
echo y|cacls.exe "%programdata%\Microsoft\Diagnosis\ETLLogs\AutoLogger\AutoLogger-Diagtrack-Listener.etl" /d SYSTEM

:: UPDATES :::::::::::::::::::::::::::::::::::::::::::::::::::::::::

REM Update Windows Defender
"%ProgramFiles%\Windows Defender\mpcmdrun.exe" -SignatureUpdate

REM Windows updates
sc config wuauserv start= auto
net start wuauserv
wuauclt /detectnow /updatenow
ping 127.0.0.1 -n 15

::::: SOFTWARE INSTALLATION  :::::::::::::::::::::::::::::::::::::::::::::::::::::::::

REM Install Windows Subsytem for Linux
:: https://docs.microsoft.com/en-us/windows/wsl/install-win10
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "Enable-WindowsOptionalFeature -NoRestart -Online -FeatureName Microsoft-Windows-Subsystem-Linux"

:: Install Chocolatey
:: https://chocolatey.org/install
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
:: TODO choco feature enable -n allowGlobalConfirmation

choco install 7zip.install --yes
choco install sumatrapdf.install --yes
choco install libreoffice-fresh --yes
choco install firefoxesr --yes
choco install mumble --yes
choco install jre8 --yes
choco install deluge --yes
choco install nextcloud-client --yes
choco install winscp --yes
choco install youtube-dl --yes
choco install vlc --yes
choco install quodlibet --yes
choco install opencodecs --yes
choco install winff --yes
choco install audacity --yes
choco install audacity-lame --yes
choco install mixxx --yes
choco install blender --yes
choco install obs --yes
choco install gimp --yes
choco install dia --yes
choco install nirlauncher --yes
choco install sysinternals --yes
choco install openhardwaremonitor --yes
choco install bleachbit --yes
choco install win32diskimager --yes
choco install windirstat --yes
choco install virtualbox --yes
choco install pwgen --yes
choco install putty.install --yes
choco install notepadplusplus --yes
choco install cdburnerxp --yes
choco install meld --yes
choco install resourcehacker.portable --yes
choco install git --yes
choco install wget --yes
choco install steam --yes
choco install playnite --yes

:: Additional software
:: PDF Creator http://sourceforge.net/projects/pdfcreator/
:: Xournal http://xournal.sourceforge.net/
:: Mozilla Thunderbird https://www.mozilla.org/fr/thunderbird/
:: Pidgin http://pidgin.im/download/
:: Pidgin-OTR http://www.cypherpunks.ca/otr/index.php#downloads
:: Owncloud http://owncloud.org/
:: Audacious http://audacious-media-player.org/download 
:: QuodLibet https://quodlibet.readthedocs.org/en/latest/ 
:: Combined Community Codec Pack http://www.cccp-project.net/download.php?type=cccp
:: OGG Codecs https://www.xiph.org/downloads/
:: Electricsheep http://electricsheep.org/download
:: CDex http://cdexos.sourceforge.net/
:: WinFF http://winff.org/html_new/
:: Kodi http://kodi.tv/download/
:: AviDemux http://avidemux.berlios.de/download.html
:: VirtualDub http://www.virtualdub.org/ 
:: Handbrake http://handbrake.fr/ 
:: Picard http://wiki.musicbrainz.org/PicardTagger 
:: mp3tag http://www.mp3tag.de/en/
:: Ardour https://ardour.org/
:: GIMP http://www.gimp.org/downloads/
:: Inkscape http://inkscape.org/screenshots/index.php?lang=en
:: Scribus http://scribus.net/canvas/About
:: Tiled http://www.mapeditor.org/ `tiled`
:: IrfanView http://www.irfanview.com/
:: LibreCAD http://librecad.org/cms/home.html
:: Sweet Home 3D http://www.sweethome3d.com/fr/index.jsp
:: InfraRecorder http://infrarecorder.org/?page_id=5
:: Duplicate Files Finder http://doubles.sourceforge.net/
:: WinCDEmu http://wincdemu.sysprogs.org/download/
:: Testdisk/Photorec http://www.cgsecurity.org/wiki/PhotoRec
:: Ext2fsd http://sourceforge.net/projects/ext2fsd/files/
:: Process Explorer https://technet.microsoft.com/en-us/sysinternals/bb896653.aspx
:: VirtualBox https://www.virtualbox.org/
:: WinDirStat http://windirstat.info/
:: PWGen http://pwgen-win.sourceforge.net/
:: Free File Renamer http://sourceforge.net/projects/freefilerenamer
:: resource hacker http://www.angusj.com/resourcehacker/
:: Sublime Text http://www.sublimetext.com/
:: Console2 http://sourceforge.net/projects/console/
:: Meld http://meldmerge.org/
:: WinPCap https://www.winpcap.org/
:: Wireshark https://www.wireshark.org/
:: PuTTY http://www.putty.org/
:: Github (+git CLI)
:: Git Extensions http://gitextensions.github.io/
:: Twine https://twinery.org/
:: PCSX2 https://github.com/PCSX2/pcsx2
:: SaveGameBackup.net http://sourceforge.net/projects/savegamebackup/

:: Download additional software
"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "(New-Object System.Net.WebClient).DownloadString('https://freefr.dl.sourceforge.net/project/savegamebackup/sgbnet13.zip')"

:: CLEANUP :::::::::::::::::::::::::::::::::::::::::::::::::::::::::

:: REM Clear Windows Update cache (disabled, run manually after reboot)
:: net stop WUAUSERV
:: if exist %windir%\softwaredistribution\download rmdir /s /q %windir%\softwaredistribution\download 
:: net start WUAUSERV

:: REM run cleanmgr (disabled)
:: start /wait CLEANMGR /C: /sageset:0 || echo ERROR && exit /b

:: REM run other cleaners (disabled)
:: start /wait "c:\Program Files\Bleachbit\bleachbit.exe"

:: REM run defrag (disabled)
:: start /wait defrag /C

:: REM check system integrity with sfc (disabled)
:: start /wait sfc /scannow

:: REM checkdisk (disabled)
:: start /wait chkdsk.exe %SystemDrive%

:: REM re-run windows update
wuauclt.exe /detectnow /updatenow

:: REM run msconfig for manual tweaks
start /wait msconfig
