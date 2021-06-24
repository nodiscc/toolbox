### Windows

#### windows snippets

Windows force Active directory synchronization with O365 (ignore 30 min default interval) `Start-ADSyncSyncCycle -PolicyType Delta`

Windows enable password for UAC: Local Security Policy > Local Policies > Security Options > User Account Control : Behavior of the elevation prompt for... > Prompt for crendtials

windows powsershell general computer info `Get-ComputerInfo; Get-Counters; Get-WmiObject Win32_PNPEntity | sort -property deviceid |ft -Property service,name,manufacturer,deviceid; Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName,DisplayVersion,Publisher,InstallDate | format-table -autosize;  Get-AppxPackage | ft -Property PackageFullName,InstallLocation; Get-Process | ft -Property Id,PagedMemorySize,PagedSystemMemorySIze,PrivateMemorySIze,VirtualMemorySize,WorkingSet,CPU,Handlecount,Name,Path; Get-ScheduledTasks`

windows powsershell device list  `Get-WmiObject Win32_PNPEntity | sort -property deviceid |ft -Property service,name,manufacturer,deviceid`

windows powershell installed programs list `Get-ItemProperty HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName,DisplayVersion,Publisher,InstallDate | format-table -autosize`

windows powershell process list `Get-Process | ft -Property Id,PagedMemorySize,PagedSystemMemorySIze,PrivateMemorySIze,VirtualMemorySize,WorkingSet,CPU,Handlecount,Name,Path`

windows performance/resource monitor `resmon.exe`

Windows Connected USB drives list: `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\USBSTOR\`, `C:\Windows\setupapi.log` -> Perform search for Serial Number

Windows Unicode Right-to-left override `"Awesome Song uploaded by \[U+202e\]3pm.exe"`

Reset windows passwords: Load up a linux distro and copy the SAM that is located in `C:\windows\system32\config`; run ophcrack on it. Or use https://pogostick.net/~pnh/ntpasswd/

Windows Remote desktop connection: `mstsc.exe [<Connection File>] [/v:<Server>[:<Port>]] [/admin] [/f] [/w:<Width> /h:<Height>] [/public] [/span] /edit <Connection File> /migrate`

Windows Trigger BSOD: regedit > `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\i8042prt\Parameters` or `HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\i8042prt\Parameters`. New DWORD > `CrashOnCtrlScroll` = 1. Hit Right Ctrl + Scroll Lock x2. Or kill csrss.exe.

Windows **RAID5** `list disk; select disk 1 ; list part; list vol ; select vol 0 [DVD]; [DVD] assign letter=z; create volume raid=5120 disk=1,2,3; select vol 3 [RAID]; format quick; assign letter=d OU assign mount=c:\Base`

Windows add DHCP range: `add-dhcpserverv4scope -startrange 192.168.0.100 -endrange 192.168.0.200 -subnetmask 255.255.255.0 -name lan1_dhcp_range`

Windows add DHCP reservation `add-dhcpserverv4reservation -scopeid 192.168.0.0 -ipaddress 192.168.0.100 -clientid 00-0c-29-f6-ad-0b`

Windows add DNS conditional forwarder: `add-DNSServerConditionalForwarderZone -Name example.com -MasterServers x.x.x.x`

Windows add DNS global forwarder: `add-DNSServerForwarder -IPAddress 10.0.0.1`

Windows add firewall rule: `netsh advfirewall firewall add rule name="Block NetBIOS Port 137 (UDP)" dir=in action=block protocol=UDP localport=137`

Windows add NDS server DHCP option: `set-dhcpserverv4optionvalue -optionId 6 -ScopeId 192.168.0.0 -Value 192.168.0.1`

Windows add primary DNS zone: `add-DNSServerPrimaryZone -Name ad.example.com -Zonefile ad.example.com`

Windows change login screen background: place a .jpg image <245kb in `%windir\system32\oobe\info\backgrounds\backgroundDefault.jpg` + `HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\Background\OEMBackground` (DWORD=1)

Windows check NTP server offset: `w32tm /stripchart /computer:time.windows.com`

Windows create firewall rule: `New-NetFirewallRule -DisplayName 'ICMPv4-In-ByIP' -Enabled True -Profile Domain -Direction Inbound -Action Allow -Protocol ICMPv4 -RemoteAddress 10.11.200.104,10.11.200.58`

Windows create godmode directory `mkdir GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}`

Windows Create junction point: `mklink /J <Target> <Linkname>`

Windows disable SMBv1: `Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" SMB1 -Type DWORD -Value 0 -Force`

Windows download file `$clnt = new-object System.Net.WebClient; $clnt.DownloadFile("https://source.fi/le.txt", "destfile.txt")`

Windows Download file `& { iwr http://www.it1.net/it1_logo2.jpg -OutFile logo.jpg }`

Windows download file `explorer https://url.of/file`

Windows Enable/Allow RDP: `Get-NetFirewallRule -DisplayName "Remote Desktop*" | Set-NetFirewallRule -enabled true; Get-Service "*rdp*"; Set-Service -Name "ServiceName" -Status Running` + enable System Properties > Remote Settings > Allow

Windows encrypt swap: cmd as admin > `fsutil behavior set encryptpagingfile 1`

Windows get hotfix status info: `Get-Hotfix -Id KB2952664`

Windows install Active Directory: `Get-Command *-Ad*; Import-Module ActiveDirectory, Add-WindowsFeature RSAT-AD-PowerShell`

Windows install DHCP service: `install-windowsfeature dhcp; install-windowsfeature rsat-dhcp`

Windows install DNS service: `install-windowsfeature dns, install-windowsfeature rsat-dns-server`

Windows install DNS: `install-windowsfeature [dns|rsta-dns-server]`

Windows ipconfig commands: `/displaydns /all /release /renew`

Windows list hidden windows updates; `(New-Object -ComObject Microsoft.Update.Session).CreateUpdateSearcher().Search('IsInstalled=0 and IsHidden=1').Updates | %{'KB'+$_.KBArticleIDs}`

Windows List junction points: `dir /aL; dir /aL /s C:\;`

Windows list optional windows features; `Get-WindowsOptionalFeature -Online`

Windows list running services: `Get-Service | Where-Object { $_.Status -eq "Running" }`

Windows list services:`Get-Service`

Windows display routing information `route print; netstat -r`

Windows make filesystem case-sensitive `reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\kernel" /v ObCaseInsensitive /t REG_DWORD /d 0 /f`

Windows multi user RDP: `HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TerminalServer\fSingleSessionPerUser` (0x0 Allow multiple sessions per user, 0x1 Force each user to a single session)

Windows Powershell help: `Get-Help Get-Help -ShowWindow/ -Detailed -Examples -Full`

Windows Powershell help: `Help about_*`

Windows Powershell list methods/attributes: `$command | Get-Member`

Windows Powershell loop `$startdate=get-date; $val=0; while ($val -neq 65535) { $val++; Write-Host -NoNewline "$val " }; $enddate=get-date; $totaltime=$enddate - $startdate; write-host "total time is $totaltime"`

Windows Powershell update-help from local repo: `Update-Help -SourcePath \\10.x.x.x.x\path\to\powershell\help\ -Credential ad\username`

Windows RDP Port number: `HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TerminalServer\WinStations\RDP-Tcp\PortNumber`

Windows Remote desktop connection `mstsc /span /v:HOSTNAME`

Windows remove password prompt at boot `Win + R` > "control userpasswords2" > Uncheck password

Windows server configuration tool: `sconfig`

Windows Set DNS server for client machine: `Set-DNSClientServerIpADdress -InterfaceIndex 12 -ServerAddress '10.0.0.1, 10.0.0.9'`

Windows set DNS suffix `Set-DNSClientGlobalSetting -SearchSuffix example.local`

Windows set IP address `New-NetIPAddress -IPAddress 10.11.17.1 -AddressFamily IPv4 -InterfaceAlias Ethernet0 -DefaultGateway 10.11.255.254 -PrefixLength 8`

Windows show DNS resource record: `Get-DNSServerResourceRecord -Name ad.example.com`

Windows shutdown remote machine via SMB: `net rpc shutdown -C "comment" -I IPADDRESS -U USERNAME%PASSWORD`

Windows System properties: `sysdm.cpl`

Windows uninstall KB `wusa /uninstall /kb:2952664`

Windows generate file checksum `certUtil -hashfile cheminVersLeFichier [MD2 MD4 MD5 SHA1 SHA256 SHA384 SHA512]`

Windows Force unmount all network shares `net use * /delete /y`

----------------------------------------------

**Windows User accounts**

 * **Create user models** `New-ADUser -name "Modele_Direction" -City "Nantes" -PostalCode "44000" -Organization "Direction" -Company "Société XX"`
 * **List user models** `Get-ADUser -Filter 'Name -like "Modele*"' | ft -Display "Name"`
 * Copy models to new accounts
 * Set passwords, enable accounts
 * **Create global security groups** `New-ADGroup -GroupScope Global -GroupCategory Security -Name "G_Interimaires"`
 * **Add users to groups** `Add-ADGroupMember -Identity "G_Interimaires" -Members "Christophe"`
 * Create OUs
 * Move objects inside OUs
 * Create search queries
 * **Export user details** `Get-ADGroupMamber -Identity "David" | Out-File "export.txt"`

----------------------------------------------

**windows local privilege escalation**

* reboot
* disconnect power during splash, plug back in
* boot
* ` Launch startup repair (recommended)`
* on system restore dialog: ` Cancel` , Scan,
* on "Cannot repair automatically" dialog: ` View problem details`, click link to ` X:\Windows\System32\en-US\erofflps.txt`, it pops notepad
* `File>Open>C:\Windows\System32\`, set view to ` all files *.*`
* rename `Sethc`  to ` Sethc1`
* duplicate ` cmd`
* rename new `cmd` to ` Sethc`
* Press shift 5 times (opens cmd instead of Sethc sticky keys dialog) to test
* Reboot
* Wait for login prompt, press Shift 5 times,cmd opens
* ` whoami` should return `NT AUTHORITY\SYSTEM`
* `net user` to show available users*
* `net user $username *`
* type new password
* close cmd, login.

<http://ifconfig.dk/password/> Can also be done by booting live CD, copying `cmd.exe`  to `magnify.exe`,  reboot, click magnify icon. Commands: `net user username new_password`; `net user username password /add`, `net localgroup administrators username /add`, `net user username /delete`, `net localgroup Remote Desktop Users UserLoginName /add` (RDP); `net user commands Reference`

----------------------------------------------

**List DNS zones**

```powershell
$Zones = @(Get-DnsServerZone)
ForEach ($Zone in $Zones) {
	Write-Host "`n$($Zone.ZoneName)" -ForegroundColor "Green"
	$Zone | Get-DnsServerResourceRecord
}
```

----------------------------------------------

**Windows ADDS setup**

```
sconfig # configure host name/IP/subnet, set DNS to 127.0.0.1
Install-WindowsFeature AD-Domain-Services
Import-Module ADDSDeployment
Test-ADDSDomainControllerInstallation
Test-ADDSForestInstallation
Test-ADDSDomainInstallation
Install-ADDSForest
 -CreateDnsDelegation:$false
 -DatabasePath “C:\Windows\NTDS”
 -DomainMode “Win2012R2”
 -DomainName “yourdomain.com”
 -DomainNetbiosName “YOURDOMAIN”
 -ForestMode “Win2012R2”
 -InstallDns:$true
 -LogPath “C:\Windows\NTDS”
 -NoRebootOnCompletion:$false
 -SysvolPath “C:\Windows\SYSVOL”
 -Force:$true
```

* Promote machine to AD DC
* Clients: Set DNS to IP of Controller, join domain
* Clients: Setup Remote Desktop
* Clients: Install remote RSAT console (KB958830)




#### windows command line

* **https://ss64.com/nt/**
* **https://web.csulb.edu/~murdock/dosindex.html**
* https://ss64.com/nt/icacls.html
* https://ss64.com/nt/net-config.html
* https://ss64.com/nt/net-service.html
* https://ss64.com/nt/net-time.html
* https://ss64.com/nt/net.html
* https://ss64.com/nt/robocopy.html
* https://ss64.com/nt/wmic.html
* https://technet.microsoft.com/en-us/library/

#### active directory

* **https://en.wikipedia.org/wiki/Active_Directory**
* http://brakertech.com/one-liners/active-directory-cheat-sheet/
* http://www.dummies.com/programming/networking/active-directory-for-dummies-cheat-sheet/
* https://andrewwippler.com/2015/12/21/switching-from-active-directory-to-samba4/
* https://blogs.technet.microsoft.com/uktechnet/2016/06/08/setting-up-active-directory-via-powershell/
* https://brakertech.com/one-liners/active-directory-cheat-sheet/
* https://docs.microsoft.com/en-us/windows-server/identity/ad-ds/plan/security-best-practices/understanding-active-directory-domain-services--ad-ds--functional-levels
* https://docs.microsoft.com/en-us/windows-server/windows-server
* https://docs.microsoft.com/en-us/windows/windows-10/
* https://en.wikipedia.org/wiki/Directory_service
* https://en.wikipedia.org/wiki/Domain_controller
* https://en.wikipedia.org/wiki/Microsoft_Servers
* https://en.wikipedia.org/wiki/Security_Account_Manager
* https://en.wikipedia.org/wiki/Windows_domain
* https://en.wikipedia.org/wiki/Windows_domain
* https://en.wikipedia.org/wiki/Windows_Server
* https://en.wikipedia.org/wiki/Windows_Server_2012
* https://en.wikipedia.org/wiki/Workgroup_(computer_networking)
* https://help.ubuntu.com/community/ActiveDirectoryHowto
* https://msdn.microsoft.com/en-us/library/cc246068.aspx Nested groups 
* https://serverfault.com/questions/790152/export-active-directory-from-2008r2-to-samba-4-dc
* https://standalonelabs.wordpress.com/2011/05/08/what-is-the-_msdcs-subdomain/
* https://www.it-connect.fr/chapitres/controleur-de-domaine-et-domaine/
* https://www.it-connect.fr/chapitres/domaine-arbre-et-foret/
* https://www.it-connect.fr/chapitres/un-annuaire-active-directory-pourquoi/
* https://www.it-connect.fr/cours/notions-de-base-de-lactive-directory/
* https://www.it-connect.fr/creer-un-domaine-ad-avec-windows-server-2016/
* https://www.it-connect.fr/modules/lannuaire-active-directory-et-les-domaines/

#### GPO

* https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-7/hh147307(v=ws.10)

local GPO console: `gpedit.msc`

`rsop.msc` or `gpresult /z`, http://gpsearch.azurewebsites.net/, ADMX models: `%systemroot%\policyDefinitions\` or in SYSVOL share, must be `Enabled` AND `Enforced`, `Get-Command *GP*`


#### roaming profiles

* **https://en.wikipedia.org/wiki/Roaming_user_profile**
* https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/jj649079(v=ws.11)
* https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-vista/cc766489(v=ws.10)
* https://msdn.microsoft.com/en-us/library/windows/desktop/bb776897(v=vs.85).aspx


#### windows misc

- https://en.wikipedia.org/wiki/Microsoft_Exchange_Server
- https://en.wikipedia.org/wiki/NTFS
- https://exchangepedia.com/reference/ExQuick.html Exchange quick reference
- https://serverfault.com/questions/406240/what-is-group-policy-and-how-does-it-work
- https://www.techrepublic.com/blog/the-enterprise-cloud/an-overview-of-the-active-directory-domains-and-trusts-console/
- https://www.tuxera.com/community/ntfs-3g-advanced/ownership-and-permissions/
- - http://blog.netwrix.com/2014/12/03/detecting-a-security-threat-in-event-logs/


#### powershell

* https://docs.microsoft.com/en-us/azure/cloud-shell/features-powershell
* https://docs.microsoft.com/en-us/office365/enterprise/powershell/manage-office-365-with-office-365-powershell
* https://docs.microsoft.com/en-us/powershell/module/ module browser
* https://docs.microsoft.com/en-us/powershell/scripting/getting-started/fundamental/using-windows-powershell-for-administration
* https://docs.microsoft.com/en-us/powershell/scripting/getting-started/getting-ready-to-use-windows-powershell
* https://docs.microsoft.com/en-us/powershell/scripting/powershell-scripting
* https://docs.microsoft.com/en-us/powershell/scripting/setup/winrmsecurity
* https://github.com/PowerShell/PowerShell/blob/master/docs/learning-powershell/powershell-beginners-guide.md
* https://github.com/PowerShell/PowerShell/tree/master/docs/learning-powershell
* **https://ss64.com/ps/**
* https://ss64.com/ps/call.html
* https://ss64.com/ps/common.html
* https://ss64.com/ps/get-childitem.html
* https://ss64.com/ps/get-history.html
* https://ss64.com/ps/psboundparameters.html
* https://ss64.com/ps/source.html
* https://ss64.com/ps/syntax-args.html
* https://ss64.com/ps/syntax-automatic-variables.html
* https://ss64.com/ps/syntax-esc.html
* https://ss64.com/ps/syntax-function-advanced.html
* https://ss64.com/ps/syntax-function-input.html
* https://ss64.com/ps/syntax-functions.html
* https://ss64.com/ps/syntax-hash-tables.html#splat
* https://ss64.com/ps/syntax-pipeline.html
* https://ss64.com/ps/syntax-profile.html
* https://ss64.com/ps/syntax-ref.html
* https://ss64.com/ps/syntax-run.html
* https://ss64.com/ps/syntax-scopes.html
* https://ss64.com/ps/syntax-scriptblock.html
* https://ss64.com/ps/syntax-variables.html
* https://ss64.com/ps/syntax-wildcards.html
* https://ss64.com/ps/write-host.html
* https://ss64.com/ps/write-verbose.html
* https://stackoverflow.com/questions/573623/is-powershell-ready-to-replace-my-cygwin-shell-on-windows/573861
* https://www.dummies.com/programming/net/windows-powershell-2-for-dummies-cheat-sheet/
* https://www.leaseweb.com/labs/2014/02/powershell-windows-firewall/
* https://www.powershellgallery.com/items
* https://www.powershellgallery.com/packages/PSWindowsUpdate/1.5.2.2
* https://www.sevenforums.com/windows-updates-activation/386164-there-way-list-hidden-windows-updates-via-powershell.html

### Deployment

- **https://en.wikipedia.org/wiki/Windows_Deployment_Services**
- https://en.wikipedia.org/wiki/Windows_Assessment_and_Deployment_Kit (WADK)
- https://en.wikipedia.org/wiki/Windows_Imaging_Format
- https://en.wikipedia.org/wiki/Windows_Preinstallation_Environment , What is Windows PE
- https://en.wikipedia.org/wiki/Microsoft_Deployment_Toolkit
- https://en.wikipedia.org/wiki/System_Center_Configuration_Manager (https://www.reddit.com/r/SCCM/)
- https://www.reddit.com/r/sysadmin/wiki/ms/image

#### Sysprep


- https://en.wikipedia.org/wiki/Sysprep
- **Sysprep**: [Sysprep (Generalize) a Windows installation](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/sysprep--generalize--a-windows-installation), [Sysprep Process Overview](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/sysprep-process-overview), [Sysprep Support for Server Roles](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/sysprep-support-for-server-roles), [Sysprep (System Preparation) Overview](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/sysprep--system-preparation--overview), [Use Answer Files with Sysprep](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/use-answer-files-with-sysprep)
- **Audit mode/OOBE**: [Add a Driver Online in Audit Mode](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/add-a-driver-online-in-audit-mode), [Audit Mode Overview](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/audit-mode-overview), [Boot Windows to Audit Mode or OOBE](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/boot-windows-to-audit-mode-or-oobe), [Customize the Default User Profile by Using CopyProfile](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/customize-the-default-user-profile-by-using-copyprofile), [Enable and Disable the Built-in Administrator Account](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/enable-and-disable-the-built-in-administrator-account), [How Configuration Passes Work](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/how-configuration-passes-work), [How Oobe.xml Works](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/how-oobexml-works), [Oobe.xml Settings](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/oobexml-settings), [Sysprep Command-Line Options](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/sysprep-command-line-options)
- **Old docs**: [Windows Setup Installation process](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-vista/cc721913(v=ws.10)), [What is Sysprep?](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-vista/cc721940(v=ws.10)), [Sysprep Command-Line Syntax](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-vista/cc721973(v=ws.10)), [Customize Windows in Audit Mode](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-vista/cc722413(v=ws.10)), [How Sysprep Works](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-vista/cc766514(v=ws.10)), [System Preparation (Sysprep) Provider Developer's Guide for Windows 7](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-7/ee676646(v=ws.10))
- https://theitbros.com/sysprep-a-windows-7-machine-start-to-finish-v2/
- https://blogs.technet.microsoft.com/danstolts/2014/05/how-to-sysprep-sysprep-is-a-great-and-powerful-tool-and-easy-too-if-you-know-how-step-by-step/


##### DISM

- https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/capture-images-of-hard-disk-partitions-using-dism
- https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/create-and-manage-a-windows-image-using-dism
- https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism-application-servicing-command-line-options
- https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism-app-package--appx-or-appxbundle--servicing-command-line-options
- https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism-capabilities-package-servicing-command-line-options
- https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism-default-application-association-servicing-command-line-options
- https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism---deployment-image-servicing-and-management-technical-reference-for-windows
- https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism-driver-servicing-command-line-options-s14
- https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism-global-options-for-command-line-syntax
- https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism-how-to-topics--deployment-image-servicing-and-management
- https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism-image-management-command-line-options-s14
- https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism-languages-and-international-servicing-command-line-options
- https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism-operating-system-package-servicing-command-line-options
- https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism-provisioning-package-command-line-options
- https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism-unattended-servicing-command-line-options
- https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism-windows-edition-servicing-command-line-options
- https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/dism-windows-pe-servicing-command-line-options
- [dism.exe command line options](https://technet.microsoft.com/en-us/library/dd744382%28v=ws.10%29.aspx)

#### Alternatives

- **https://chocolatey.org/**, **https://chocolatey.org/packages**
- https://fogproject.org/download , https://github.com/FOGProject/fogproject, https://wiki.fogproject.org
- https://ss64.com/nt/syntax-reghacks.html
- https://www.pdq.com/pdq-deploy/

### Tools

- https://extension.nirsoft.net/


## Disabling secure boot in windows 8

 * In start menu, type `UEFI` or `BIOS` and click on the settings list.
 * Click on startup options. You should now be in general settings, scroll to the bottom of the right pane and click on the `restart` button below advanced boot.
 * Now go to `Troubleshoot -> Advanced Options > UEFI Firmware Settings`, and click `restart`. This will bring you to your UEFI firmware panel (UEFI's controls akin to BIOS).
 * Go to `Main` and set a Supervisor password, this will allow for advanced security settings.
 * Go to `Security` and **disable secure boot**.
 * Go to `boot order` and put whatever device has your linux image on it first, or if your firmware has such an option, turn on `legacy BIOS emulation` to get the typical BIOS screen when your computer boots.
 * Save and exit, you should now be able to safely install your distribution.