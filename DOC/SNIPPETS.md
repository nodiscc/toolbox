curl POST json `curl --header "Content-Type: application/json" --request POST --data '{"username":"xyz","password":"xyz"}' http://localhost:3000/api/login`

java limit/max memory usage `-Xms<memory>[MG] -Xmx<memory>[MG]`

git show number of commits in branch: `git rev-list --count HEAD` https://stackoverflow.com/questions/11657295/count-the-number-of-commits-on-a-git-branch

git show hash of last commit: `git rev-parse --short HEAD` https://stackoverflow.com/questions/949314/how-to-retrieve-the-hash-for-the-current-commit-in-git

ip address/interfaces in readable format `ip -br a`

python 3 http server `python3 -m http.server`

iptables trace packets: `iptables -A ..... -j TRACE; tail -f /var/log/kern.log | grep 'TRACE:'`

git bypass ssl certificate verification `git -c http.sslVerify=false clone https://example.com/path/to/git`

send mail from common line `echo "My message" | mail -s subject user@gmail.com`

python pretty-print dicts: `#import pprint; pp = pprint.PrettyPrinter(indent=4); pp.pprint(my_dict)`

docker-compose up #démarrage en mpode detached
docker-compose ps #vérifier que les containers sont up
docker-compose stop plexpy #stop single container
docker-compose up -d #après ajout d'un bloc au .yml, lancer nvx containers
docker-compose pull #update containers
docker-compose up -d #restart updated containers

systemctl daemon-reload error `Failed to reload daemon: Refusing to reload, not enough space available on /run/systemd. ` -> `sudo mkdir /var/log/journal && sudo systemctl restart systemd-journald`

apachectl `start/stop/restart/fullstatus/status/graceful/graceful-stop/configtest/startssl`

apache MPM: prefork: stable/fast, 1 connection -> 1 process (multi-process)  
apache MPM worker: lightweight, 1 connection -> 1 thread (requires php-fpm)  
apache MPM event: very lightweight, 1 request -> 1 thread. Use PHP-FPM anyway.

python directory of currently running script `os.path.abspath(__file__)`

python set environment variable `os.environ['LD_LIBRARY_PATH'] = "my_path"`

iptables/netfilter NAT Enable forwarding `echo 1 > /proc/sys/net/ipv4/ip_forward`

iptables forwarding `iptables -A FORWARD -i $wan_iface -o $lan_iface -m state --state RELATED,ESTABLISHED -j ACCEPT && iptables -A FORWARD -i $lan_iface -o $wan_iface -j ACCEPT`

iptables SNAT `iptables -t nat -A POSTROUTING -s $lan_network -o $wan_iface -j SNAT --to-source $wan_address`

iptables MASQUERADE `iptables -t nat -A POSTROUTING -o $wan_iface -j MASQUERADE`

iptables DNAT all ports `iptables -t nat -A PREROUTING -d $wan_address -j DNAT --to-destination $lan_address`

iptables DNAT single port `iptables -t nat -A PREROUTING -p tcp -d $wan_address --dport 80 -j dnat --to-destination $lan_address`

iptables full DNAT+SNAT `iptables -t nat -A PREROUTING -d $wan_address -j DNAT --to-destination $lan_address && iptables -t NAT -A POSTROUTING -s $lan_address -j SNAT --to-destination $wan_address`

monitoring CPU performance metrics: context switch (switch between processes/threads), run queue (num. of active processes in current CPU queue - Sleeping or WAiting for I/O processes are not in the run queue - priority affects selection of process from queue), CPU usage, load average (1 5 15 mins, run queue + uninterruptible). `cat,echo > /sys/block/sd?/queue/scheduler` (not instantaneous). Use realtime kernel? Recompile lightweight kernel?

monitoring/performance benchmarks: bonnie++, hdparm, dbench, memeater, http_load,siege,tiobench, ttcp, netperf

monitoring disk I/O. Sheduleur: deadline, noop, anticipatory, and cfq. CFQ: distribute I/O evenly across processes (Not ideal for cached RAID). NOOP: Low CPU usage, FIFO (SSD?). Anticipatory: reorders I/O operations to optimize seek (for slow disks). Deadline: I/O req. in priority queue (realtime, SSD?). bi/bo: block in/block ou, tps: transactions per second/ mount noatime,nodiratime! 

Memory optimization: use ECC RAM, Use swap file??  application 80%, infra 20%

pfsens upgrade from command line `sudo pfSense-upgrade -d`

Prevent AMD Ryzen crash when idle? Disable idle power management in UEFI, or turn off C-States

Apache tuning: MinSpareServers 20, MaxSPareServers 80,StartServers 32, MaxCLients 256, MaxRequestsPerChild. Use memcache, minimize modules, use nginx

ouyt of disk space ~/.xsession-errors.log getting extremely large: replace call to exec with `exec >> /dev/null 2>&1` in /etc/X11/Xsession

nginx enable HTTP2 `listen 443 ssl http2;`

Network tuning/monitoring: packet in/out, packets dropped

apache force HTTPS redirect rewriterule: `    RewriteCond %{HTTPS} !=on; RewriteRule ^/?(.*) https://%{SERVER_NAME}/$1 [R,L]`

Make nvidia optimus work under Debian: `sudo apt-get install bbswitch-dkms intel-microcode firmware-linux-nonfree bumblebee bumblebee-nvidia primus primus-libs primus-libs:i386 linux-headers-$(uname -r)`; Open `/etc/bumblebee/bumblebee.conf` and ser KernelDriver=nvidia-current; adduser your_user bumblebee; in `/etc/default/grub` add kernel option `rcutree.rcu_idle_gp_delay=1`; ` update-grub; reboot`. Test with `primusrun <command>` or `optirun <ommand>` <https://www.unixmen.com/how-to-make-nvidia-optimus-technology-work-properly-on-debian/>

nvidia driver fix screen tearing `options nvidia_drm modeset=1` in `/etc/modprobe.d/nvidia.conf`

Network Allow more ports to be available: `echo 1024 65000 > /proc/sys/net/ipv4/ip_local_port_range`

Network increase memory of socket buffers `echo 262143 > /proc/sys/core/rmem_max,default`

ffmpeg cut between 310th and 500th frame `ffmpeg -i constellaion003.mkv -vf 'select=gte(n\,301)*lte(n\,500)'` output.mkv (breaks video index/length/seek?)

find duplicate images and display in image viewer `findimagedupes -v=fp  -R -f=fp_data  ~/images; findimagedupes -v=fp  -R -f=fp_data  -p=/usr/bin/feh ~/images`

debian simple sid backport: First, check for a backport on [debian-backports].  If unavailable: 1) Add a deb-src line for sid (not a deb line!); ask me about [deb-src sid] 2) enable debian-backports (see [bdo]) 3) aptitude update; aptitude install build-essential; aptitude build-dep packagename; apt-get -b source packagename; 4) install the resultant debs.  To change compilation options, see [package recompile]; for versions newer than sid see [uupdate]. (from #debian dpkg bot)

apt list packages from specific origin/repository (eg. kxStudio): `ls  /var/lib/apt/lists/*kx*Packages | xargs cat | grep ^Package | sort --unique`

debian close bug on bts 664742-done@bugs.debian.org

count how many files in directory `ls -rAa1 | wc -l`

Virtualbox convert VDI disk image to raw `VBoxManage internalcommands converttoraw Win7AfterSysprep-disk1.vdi output.img`

highlight a word in command output (here 'waiting'): `egrep --color=always '^|running|waiting'`

libvirt Select Virtio display output instead of QNX if image is not properly scaled/larger than display

libvirt keyboard not working: set the proper keymap in VM settings

open .mozlz4: `apt-get install liblz4-dev; git clone https://github.com/andikleen/lz4json.git; cd lz4json; make; ./lz4jsoncat ~/.mozilla/firefox/*/bookmarkbackups/*.jsonlz4`

bash increment variable `var=$((var+1))` OR `((var=var+1))` OR `((var+=1))` OR `((var++))`

bash docs: Use error-if-unset `${placeholders?}` and join commands with `&&` to make it easier and safer to copy-paste shell commands from technical documentation.

python md5 hash string `import hashlib; hashlib.md5('chaine à hasher').hexdigest()`

Force running handler even if triggering tasks have not `changed`: `--force-handler` or `force_handlers = True` in ansible.cfg; and task `- meta: flush_handlers` to fire your handlers at a specific point

Ansible check if shell command changed a file: `stat: path=... get_md5=yes; register: before; shell...; stat...; register: after` then compare md5s

>DECOMPOSE. THE. PROBLEM.

iptables open OUTGOING port `iptables -A OUTPUT -p TCP --dport 6881:6999 \ -m state --state NEW -j ACCEPT`

pulseaudio change output channels/mode: pacmd set-card-profile INDEX PROFILE

RAID create device: `mdadm --create /dev/md4 --level=1 --raid-devices=2 /dev/sd[ab]8`
RAID stop: `mdamd --stop /dev/md4`
RAID remove a physical device `mdadm --fail /dev/md4 /dev/sdc8; raid --remove /dev/md4 /dev/sdc8`
RAID re-add a physical device `mdadm --add /dev/md4 /dev/sdc1`

http://xmodulo.com/limit-network-bandwidth-linux.html `trickle -d 300 firefox %u`

rename/remove file extensions recursively `rename "s:\.::" **`

https://www.cyberciti.biz/faq/how-to-test-the-network-speedthroughput-between-two-linux-servers/ `iperf -s`; `iperf -c 192.168.0.19`

split files into individual words `fmt -1 < words.txt`


Youtube channel RSS Feed: `https://www.youtube.com/feeds/videos.xml?channel_id=$channel_external_id`


tmux Command mode: `Ctrl+b`
tmux `%` séparer la fenêtre en deux gauche et droite
tmux `"` séparer la fenêtre en deux haut et bas
tmux  flèche droite, gauche` etc : changer de pane.
tmux `d` détacher la session (comme screen)
tmux attach se rattacher à une session tmux existante

Virtualbox exit scale mode `Host key + C`

https://stackoverflow.com/questions/20318770 send mail from linux terminal in one line `echo "My message" | mail -s subject user@gmail.com`

print 25th line of file: `sed 25!d file.txt `

keep only file extension  `echo $FILE | sed 's/.*\./``/`

replace newlines with spaces in a file `sed -i 's/\ //g/' $FICHIER`

replace 4th character in a string `echo 'ABTKAKTSQ' | sed -re 's/(.{4})A/\1Z/'` = 	`ABTKZKTSQ`

sed remove 1st an 4th lines in a file `sed '1d;4d' file.txt`

sed remove lines matching regex `sed '/^#/d' file.txt`

sed remove lines between 2 regex matches (including matched lines) `sed '/pattern1/d;/pattern2/d' file.txt`

sed remove lines by number AND regex `sed '/1d;/^#/d' test.txt`

sed only show lines matching regex `sed --quiet '/^#/p' file.txt`

sed replace matched characters with other set of characters `sed 'y/éèëê/eeee'`

sed replace characters + replace word on lines matchign pattern `sed '/pattern/ {y/éêëè/eee/;s/before/after/g}' file.txt`

sed in-place replace and create backup of original file `for f in *.php; do sed -i.bak -e 's/before/after/' "$f"; done`

remove all lines starting with `#` or blank lines `sed -e '/^[ ]*#/d' -e '/^$/d' /etc/samba/smb.conf`

https://stackoverflow.com/questions/2181712/ Simple way to convert HH:MM:SS (hours:minutes:seconds.split seconds) to seconds `echo "00:20:40.25" | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }'`

coonvert a directory of .GIG (GigaSampler) files to WAV: `for i in *.gig; do name="$(basename $i .gig)"; mkdir $name; gigextract "$i" "$name/"; done`

convert all *.bin *.mdf... to .iso (FILENAMES WITHOUT SPACES ONLY) `for i in $(find ./ -maxdepth 1 -iname "*.bin"); do iat "$i" > "$i.iso"; done`

add crontab to run script/Makefile from current directory `(crontab -l ; echo '11 11 * * 0 cd $(CURDIR) && make all') | crontab -`

Burn MPEG-1/VCD to CD: `cdrdao write --device 0,1,0 -n vcd.toc #vcd.toc from mkvcdfs`

Firewire config for DV video cameras: `modprobe ieee1394 ohci1394 raw1394 video1394 #possibly mknod -m 666 /dev/video1394 c 172 0`

find images less than 1400px wide/high: `find ./ -iname "*.jpg" -type f -exec identify -format '%W %h %i' '{}' \; -print | awk '$1 < 1400 && $2 < 1400 {print}'`

alsa set card index by kernel module name: `/etc/modprobe.d: options snd-hda-intel index=0 `

alsa set card indexes when multiple cards are using the same module: `lsmod; modinfo snd-usb-audio; lsusb; /etc/modprobe.d: options snd-usb-audio index=1,2,3 vid=0x046d,0x046d,0x0d8c pid=0x0a29,0x0a13,0x000e`

convert AVI to MP4: `$ ffmpeg -b 1250k -i japantrip_01.avi japantrip_01.mp4`

convert AVI to M4V: `ffmpeg -i input.avi -acodec libfaac -ab 128k -ar 44100 -vcodec mpeg4 -b 1250K output.m4v`

convert AVI tio MOV: `ffmpeg -i "input.avi" -acodec libmp3lame -ab 192 "output.mov"`

crop video to 720px x 600px and aligned 240px from the top: `avconv -i input.webm -vf crop=720:600:0:240 output.mpeg`

list ansible tags: `ansible-playbook site.yml --list-tags 2>/dev/null | awk -F '[' '{ print $2 }' |tail -n1 | sed -e 's/, /\n/g' | pr -3 -t`

find images larger than 1280px wide: `find . -name '*.png' -exec file {} \; | sed 's/\(.*png\): .* \([0-9]* x [0-9]*\).*/\2 \1/' | awk 'int($1) > 1280 {print}'`

test disk reading speed `hdparm -t * 3` (real speed)

test disk reading speed `hdparm -T * 3` (linux buffers speed)

show disk status (active, idle...) `hdparm -C /dev/sdx`

display disk acoustic settings (128=slow/quiet 254=fast/loud) `hdparm -M /dev/sdx`

set a partition read-only `hdparm -r1 /dev/sdxx`, r0 to remove

put a disk to idle (low power mode) `hdparm -S0 /dev/sdx`

stop a disk (spindown) `hdparm -y /dev/sdx`

put a disk to idle,spindown after 21 minutes `hdparm -S252 /dev/sdx`

detect installed operating systems `sudo os-prober; sudo update-grub`

fix GRUB error `symbol 'grub_calloc' not found`: run live system, `sudo mount /dev/sda1  /mnt`, `sudo grub-install --root-directory=/mnt/  /dev/sda`

backup luks-encrypted disk header  `cryptsetup luksHeaderBackup --header-backup-file `<file>` `<device>`

FIX apt impossible de reconstruire le cache des paquets_: `sudo rm -r /var/lib/apt/lists/*`

show disk usage, exclute tmpfs filesystems `df -h -x tmpfs`

disk write speed test `dd if=/>dd bs=1024 count=5M if=/dev/zero of=$REPERTOIRE/speedtestfile.tx`

disk transfer speed test `hdparm -t /dev/sdX`

disk read speed tests `dd if=$REPERTOIRE/speedtestfile.tx of=/dev/null`

watch for file modifications in a directory `inotifywait -rm --event modify --event moved_to $REPERTOIRE/`

force disk verification on next startup/reboot `touch /forcefsck`

create empty file `touch emptyfile` or `> emptyfile`

python get all attributes/variables for an object: `from pprint import pprint; pprint(vars(object))`

rename all .txt to .wiki in a directory (rename extension)  `rename 's/.txt$/.wiki/' *.txt`


```
#Redhat network configuration: /etc/sysconfig/network-scripts/ifcfg-{device_name}:
DEVICE={device_name}
BOOTPROTO=none
ONBOOT=yes
PREFIX=24 or NETMASK=255.255.255.0
IPADDR=10.0.0.1
GATEWAY=10.0.0.254
DNS1=...
DNS2=...
```

Rescan SCSI bus: `echo "- - -" > /syc/class/scsi_host/hostXXX/scan`

crontab fields: `min hour day_of_mth mth day_of_wk command`

Problem resolution: read the docs, test, isolate problem, implement solution, test/verify solution, document

compress a directory to a .tar.gz archive `tar -pczf $NAME_OF_YOUR_ARCHIVE.tar.gz $DIRECTORY`

find broken symbonlic links in a directory `find $DIRECTORY -type l ! -exec test -r {} \; -print`

find files modified since 60 minutes `find $DIRECTORY -mmin 60` -print

find empty directories `find $DIRECTORY -maxdepth 1 -type d -empty`

find the target for a symlink: `$FILE | awk '{print $6}`

display the full executable path for a command `which $COMMAND`

enter a directory, add to dir stack `pushd`, go back in the dir stack `popd`

prevent modifications on a file `chattr -i $FILE`

prevent overwriting a file `chattr +a $FILE`

create multiple directories `mkdir -p /home/user/{test,test1,test2}`



HTML5 details tag `<details> <summary>This is shown by default</summary> <p>Anything else in the element is hidden until you click the summary.</p> </details>`

obiwan traceroute traceroute -m 254 -q1 `obiwan.scrye.net`

locate files and move them to specified directory `locate -0 -i *barthes* | xargs -0 mv -t ~/Books/Barthes/`

>firewall **iptables -m** The -m options loads a feature that isn't part of the core filtering. -m == --match. (MATCH EXTENSIONS) The state module allows you to keep track of state in your rules. This is basically required when you want to permit traffic in one direction but not the other. If a packet has a state of NEW that means the packet doesn't belong to any existing connections (There is a state table in memory that keeps track of the full socket details. See  `/proc/net/ip_conntrack`). For a TCP connection this would almost always match the SYN packet sent as part of the three way handshake. http://redd.it/23mqi7. `iptables --match state [INVALID|ESTABLISHED|NEW|RELATED|UNTRACKED`

ssh `socat -d -d TCP-L:22,reuseaddr,fork SYSTEM:"nc \$SOCAT_PEERADDR 22"` Confuse people SSHing to your host with a redirect back to theirs.

################################################################################

quick permission fix: `find $dir -type d -print0 | xargs -0 chmod 0770; find $dir -type f -print0 | xargs -0 chmod 0660`

extract still images from video: `ffmpeg -i input_file.mp4 -r 1 image_%4d.png`

install xfce from netinstall: ajouter le paramètre desktop=xfce aux options de boot de l'installeur

backup and reinstall manually installed packages: `aptitude search --disable-columns -F%p '~i!~M!~v' > package_list; xargs aptitude --schedule-only install < package_list`

`optipng -nc -nb -o7 -full file.png` optimize a PNG image @cli @images

find files/dirs newer than x `touch -t 197001010000 ./tmp && find . -newer ./tmp && rm -f ./tmp` @cli

filter expression for WiFi probe requests in Wireshark `wlan.fc.type_subtype == 0x04` @netsec @wifi (probe requests are sent by clients searching for their know/registered access points and leak info about what APs these clients were previously connected to)

Take a snapshot from your webcam using mplayer. Assumes your webcam is at /dev/video0. `mplayer tv:// -tv driver=v4l2:width=640:height=480:device=/dev/video0 -fps 15 -vf screenshot ` @cli @video

output your microphone to a remote computer's speaker `dd if=/dev/dsp | ssh -c arcfour -C username@host dd of=/dev/dsp` @audio @cli

Find largest files in directory and subdirectories  `find . -printf '%s %p\n'|sort -nr|head`


CLI connect to WEP wifi network: `iwconfig wlan0; iw dev wlan0 scan, ip link set wlan0 up; iw dev wlan0 connect [network SSID] key 0:[WEP key]`

find duplicate files `$ find . -type f -exec md5sum '{}' ';' | sort | uniq --all-repeated=separate -w 24`

bash forkbomb `:(){ :|:& };:`

bash: generate a random number between 0 and 5 `echo $(($RANDOM %6))`

invert screen colors`xcalib -i -a`

check video direct rendering/hardware acceleration `glxinfo | grep -i "direct rendering"`

DIsplay number of workspaces `wmctrl -d`

Define number of workspaces `wmctrl -n $NOMBRE_BUREAUX`

Start network interface configuration/de-configuration (from /etc/network/interfaces): `ifup/ifdown eth0`

NetworkManager create bridge `nmcli con add ifname br0 type bridge con-name br0; nmcli con modify br0 bridge.stp no; nmcli con add type bridge-slave ifname enp0s31f6 master br0`

check DNS servers in use by Network Manager `nmcli dev list iface eth0 | grep IP4`

get list of wifi networks: `nmcli dev wifi list | awk '{print $1 }'`

get current wifi network name: `nmcli -t -f name con status`

list networkmanager network interfaces `nmcli dev status`

set network link (level 2) status to UP/DOWN: `ip link set dev eth0 up/down`

show network link statistics `ip -s link ls dev eth0`

show network interface/device statistics `sudo ethtool -S eth0`

list network interface IP addresses `ip addr ls dev eth0`

add/remove IP address to interface: `ip addr add/del 172.21.19.254/22 dev eth0` or `ip addr add/del 10.0.0.1/29 brd + dev eth0`

add/remove IPv6 address to network interface  `ip -6 addr add/del 2001:db8:ca:fe::1/64 dev eth0`

create network namespace `ip ns add mynamespace`

list network namespaces `ip netns ls`

create a virtual network interface (veth1) linked to the default namespace veth0 interface: `ip link add veth1 type veth peer name veth0`

attach a virtual network interface to a namespace: `ip link set veth1 netns mynamespace`

ping IPv6 network neighbors (ROUTERS) on interface eth0: `ping ff02::1%eth0`

ping IPv6 network neighbors (HOSTS) on interface eth0: `ping ff02::2%eth0`

list network interface neighbors from ARP table `ip -4 nei ls dev eth0`

flush network interface ARP table/cache `ip nei flush dev eth0`

list network interface Ipv6 neighbors from NDP `ip -6 nei ls dev eth0`

add IP route: `ip route add 10.1.2.3 via 192.168.1.0` add it to `post-up` interface directive in /etc/network/interfaces to make it permanent

show IPv4 network routing table `ip route ls`

show IPv6 network routing table `ip -6 route ls`

show network routing decision `ip route get 8.8.8.8; ip route get 2620:fe::fe`

**subnets** If you use a regular 255.255.255.0 subnet for a group that will have a maximum of 50 users, you're going to waste 204 addresses. If you used 255.255.255.192 for example, then you'd have the ability to make four networks with 62 users each. (64-2, .0 .255 are the network address and the broadcast address)

DDOS mitigation: set apache2 `MaxClients` to a lower value (on mpm-prefork, prevents creating processes); switch to apache2-mpm-worker and set `ServerLimit` to 2 (only 2 processes) and and `ThreadsPerChild` to a lower value (implicitely sets `MaxClients` to `ServerLimit * ThreadsPerChild`) (This doesn't affect large DDOS/DNS amplification attacks - you will need a large proxy like cloudflare for that)

DDOS mitigation: Balance network cards IRQs on several CPUs (they are all on CPU0 by default)

DDOS mitigation: Set `net.netfilter.nf_conntrack_max` to a lower value. 

DDOS mitigation nullroute sources: `ip route add blackhole 172.16.1.0/24; ip route show` (this harms network performance if you have a large routing table, but less than iptables `DROP` rules)

bash herestring `while read x; do cmd "$x"; done <<< "string"`

bash herestring `read IFS=: read h m s <<< "12:13:00"`

fun `alias emacs='/usr/bin/vim'; alias vim='/usr/bin/emacs'; echo 'echo "sleep 0.1" >> ~/.bashrc'`

dns: get IP for domain name `nslookup $ADDRESS` or `getent hosts $ADDRESS` or `dig $ADDRESS`

list a samba/windows file server shares `smbclient --user=$USER -L $HOSTNAME`

mount a SAMBA/windows share `smbmount "\\\\$HOSTNAME\\$SHARE" $MOUNTPOINT -o user=$USER`

samba list public shares on a server: $ smbclient -L hostname -U% (or smbtree -b -N)

samba check netbios name: nmblookup -A 192.168.1.1

samba list services: smbclient -L \\SERVER

samba mandatory global options: `workgroup, netbios name, server role, passdb backend, map to guest, guest account`

samba share options: `path, valid users, read only, browseable, read only, guest ok`

samba check config: `testparm -s`; `testparm -sv`

samba add user to SAM database: `pdbedit -a username`

samba change user password: `smpbasswd username`


samba fstab mount entry: `//172.21.24.3/myshare /mnt/mysharemountpoint cifs _netdev,auto,username=xxx,pass=xxx 0 0`

network display routing table `netstat -rn` or `ip r`

scan local network `nmap -sP 192.168.1.0/24`

network Serve the current directory on port 8080 `python -m SimpleHTTPServer 8080`, python3 `python3 -m http.server 8080`

firewall deny requests from 1 IP address `sudo ufw  insert 1 deny from $IP_ADDRESS`

dirsplit (1) - splits directory into multiple with equal size

@fun `telnet towel.blinkenlights.nl`

> Ever since speedtest.net became popular, ISPs have been giving it priority to make themselves look better. @network

Display memory usage `free -mh --total`

export tumblr followings (who you follow)  login -> http://www.tumblr.com/following.opml

Empty caches: free pagecache `sync; echo 1 > /proc/sys/vm/drop_caches`

Empty caches: free dentries and inodes `sync; echo 2 > /proc/sys/vm/drop_caches`

Empty caches: free pagecache, dentries and inodes `sync; echo 3 > /proc/sys/vm/drop_caches`

set linux console to black on white `setterm -background white -foreground black`

convert date to unix timestamp `date --date="10/11/2011 18:22" +%s`

convert unix timestamp to date `date +"%d/%m/%Y %X" -d @$UNIX_TIME`

print a message on all open terminals `echo "Message" | wall`

print previous command return code `echo $?` bash

X11 keylogger (without root) `xinput list; xinput test $INPUT_ID`

change system language `sudo dpkg-reconfigure locales`

debugging: get stacktrace: `gdb programname; (reproduce bug here); thread apply all bt`

translations: convert .po to .mo `msgfmt -cv -o fr_FR.mo fr_FR.po`

show how deep we are in subshells `echo $BASH_SUBSHELL` 

git change branch in bare repo: `git symbolic-ref HEAD refs/heads/mybranchname @git`


`wget --mirror --page-requisites --convert-links http://stackexchange.com` (infinite recursion depth) https://softwarerecs.stackexchange.com/questions/7344/how-to-create-an-offline-copy-of-a-website @scraping

associate mimetype with program/.desktop launcher `xdg-mime default magnet-video-player.desktop x-scheme-handler/magnet`

>greybot (#bash bot): August is the month when all your scripts break because you placed $(date +%m) in a variable and tried to do arithmetic with it, without removing the leading zeros. 08 is considered octal. Use $((10#$month)) to force decimal, or strip the zero.

remove all ACLs recursively for a directory `setfacl -Rb /path/to/dir/`

remove duplicate lines in a file `cat $FILE | sort --unique`

remove 4 first characters from every line in file `cut -b 1-4 --complement $FICHIER`

use newline as separator in cut `cut -d $`

sort lines in a file in-place `sort -o $FICHIER`, remove upicates with `-u`

force color in grep `grep --color=always`

grep multiple patterns `egrep -i "str1|str2" /your/file`

SSH Generate private/public keypair `ssh-keygen -t rsa` or `-t ecdsa`

SSH change ssh private key passphrase `ssh-keygen -p`

SSH authorize a public key on remote ssh server  `ssh-copy-id -i ~/.ssh/id_dsa.pub $LOGIN@$SERVEUR`, on non-standard port: `ssh-copy-id "$LOGIN@$SERVEUR -p $PORT"`

sync directory to remote ssh/sftp server `rsync -avzP directory/ user@server:/path/to/directory`

rsync over ssh with custom port `rsync -av -e "ssh -p 123" example.com:/path/on/remote/server ~/local/path`

show linux kernel entropy `cat /proc/sys/kernel/random/entropy_avail`

show linux kernel CPU info `cat /proc/cpuinfo`

show linux kernel memory info `/proc/meminfo`

show linux kernel mounted filesystems info `/proc/mounts`

linux kernel special files: `/dev/null`, `/dev/zero`, `/dev/full`

show network interfaces MAC addresses `cat /sys/class/net/*/address`

show linux distribution info `cat /etc/issue`

show load average as reported by kernel `cat /proc/loadavg`


bash diff 2 strings: `diff  <(echo "$string1" ) <(echo "$string2")`

show default TCP/UDP port number convention `less /etc/services`

show kernel supported filesystems `cat /proc/filesystems`

mysql show global variables `sudo mysql -e "SHOW GLOBAL VARIABLES;"`

mysql/mariadb show tables information and size (as root) `use information_schema; SELECT table_name, engine, row_format, table_rows, ROUND(((data_length + index_length) / 1024 / 1024), 2) AS "size (mb)" FROM TABLES ORDER BY (data_length + index_length) DESC;`

mysql enable slow query log `SET GLOBAL slow_query_log_file = '/var/log/mysql/slow_query.log';
; SET GLOBAL slow_query_log = 1; SET GLOBAL long_query_time = 0.1; SET GLOBAL log_queries_not_using_indexes = 1;`

mysql enable general query log for 60 seconds `SET GLOBAL general_log = 1; SELECT SLEEP(60); SET GLOBAL general_log = 0;`

mysql generate report with percona-toolkit `sudo pt-query-digest /var/log/mysql/slow_query.log` (slow qusry log) `sudo pt-query-digest --type=genlog query.log > mysql.log.digest` (general query log)

mysql query profiling `SET SESSION profiling = 1;`, run your queries, list gathered profiles `SHOW PROFILES;`, inspect a particular query/profile `SHOW PROFILE CPU FOR QUERY 1;`

mysql show global status/peroformance counters `SHOW GLOBAL STATUS;`

mysql global status: `Innodb_buffer_pool_read_requests`: number of readings taken;  `Innodb_buffer_pool_reads` number of readings taken from disk that cannot be satisfied by the pool buffer; `Created_tmp_disk_tables` number of temporary tables created using the disk, `Created_tmp_tables` total number of temporary tables since the server was started; `Select_scan` number of full table scans performed


mysql export sql database `mysqldump -u root -p db_name [tables] > dumpfile.sql` (or `--all-databases`)

mysql restore from mysqldump `mysql -u root -p db_name < dumpfile.sql`

mysql reset root password. Must be run as root. `service mysql stop; killall mysqld; echo "UPDATE mysql.user SET Password=PASSWORD('MyNewPass') WHERE User='root'; FLUSH PRIVILEGES;" > $HOME/mysql-init; mysqld_safe --init-file=$HOME/mysql-init ; sleep 5; service mysqld stop; rm $HOME/mysql-init`

Login to interactive mysql shell `mysql -u root -p` (or `sudo mysql`)

mysql Run command from shell `mysql -u user -p -e 'SQL Query' database`

mysql List accounts and check for empty passwords `SELECT User, Host, Password FROM mysql.user`

mysql change user password `SET PASSWORD FOR "$USER"@"localhost" = PASSWORD("$PASSWORD");`

mysql Show all data in a table `SELECT * FROM $TABLE_NAME;`

mysql  Create new user account `CREATE USER '$USER'@'localhost' IDENTIFIED BY '$PASSWORD';`

mysql Create new database `CREATE DATABASE $DB_NAME`

mysql List all databases `show databases;`

mysql Switch to a database `use $DB_NAME;`

mysql Show all tables in a database `show tables;`

mysql Show database's fields format `describe $TABLE_NAME;`

mysql Grant all privileges on a database to a user `GRANT ALL ON $DATABASE.* TO '$USER'@'localhost';`

mysql Show privileges for a user `SHOW GRANTS FOR '$USER'@'localhost';`

mysql Revoke all privileges for a user `REVOKE ALL PRIVILEGES, GRANT OPTION FROM '$USER'@'localhost';`

mysql Delete a database `DROP DATABASE $DATABASE;`

mysql Delete a user account `DROP USER '$USERNAME'@'$HOST';`

mysql update/change a value in a table `UPDATE $table SET $field=$newvalue WHERE $anotherfield=value`

mysql: rsync fast **replicate databases** `rsync --progress --delete -avzun /nfs-mysql/* /vm/mysql/` http://www.reddit.com/r/linuxadmin/comments/23s2gh/easiest_way_to_replicate_an_sql_database/

nfs: setup `/etc/exports`, `showmount --exports`

NFS mounts: always use `_netdev`

mysql `GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, INDEX, ALTER, CREATE TEMPORARY TABLES ON 'wiki'.* TO 'wiki'@'localhost'; `

bash -- There are language features you should avoid, they are there for historic reasons; Know the few-ish actual language warts that you need to work around. (pipefail, when subshells are created); Know how field-separation works. Use trap for cleanup. And it's largely because bash is trying to be smart for you: mix that into a language where instructions and data can each become the other, based purely on its position in the command line, and you're just headed for grief.   It's just not a very good design: the things that make it good on the command line make it an unsafe programming language. It is ridiculously easy to make terrible mistakes, things that look perfectly sensible... 




bash filter out file extension: `touch example.list; file=example.list; echo "${file%.*}"`


bash single tab to show ambiguous completions `set show-all-if-ambiguous on`  `(~/.inputrc)`

bash completion: ignore case `set completion-ignore-case on` `(~/.inputrc)`

bash `source` executes the content of the file passed as argument, **in the current shell**.  (whereas `./script` runs the script as an executable file, launching a new shell to run it ") http://superuser.com/questions/46139/what-does-source-do 

bash **options**: `nounset` (do not allow unset variables), errexit (exit on any error), `verbose`, `xtrace` (display commands as they are run), `pipefail` (send any non-zero return code at the end of the pipeline)






LUKS **encrypted swap** `swapoff -a; cryptsetup luksFormat /dev/hda2; cryptsetup luksOpen /dev/hda2 cryptswap; mkswap /dev/mapper/cryptswap; #add to /etct/crypttab: cryptswap /dev/hda2 none swap,luks,timeout=30; #add to /etc/fstab: /dev/mapper/cryptswap none swap sw 0 0; swapon -a; cat /proc/swaps`

power: put computer to sleep during 30 seconds `rtcwake -m mem --seconds 30`

power: turn computer on in 15 minutes `rtcwake -m no --seconds 900`

power: turn computer on at defined time (RTC alarm) `rtcwake -m no --time $UNIX_TIME`

check computer on current time `cat /sys/class/rtc/rtc0/wakealarm`

xfce brightness setting `pkexec /usr/sbin/xfpm-power-backlight-helper --set-brightness 3`

set display brightness `gksu 'echo "7" > ./devices/pci0000:00/0000:00:02.0/backlight/acpi_video0/brightness`

power: display power management information `acpi -abit`

retirer les données EXIF d'une image `mogrify -strip $IMAGE`

convertir un PDF couleur en niveaux de gris `convert -colorspace GRAY original.pdf grayscale.pdf`

ajouter une étiquette en bas d'une image `convert $IMAGE -background Orange label:"$LABEL" -gravity Center -append $NEWIMAGE` (ajouter `+swap` pour ajouter l'étiquette en haut)

crack a password-protected pdf file `pdfcrack -f fichier.pdf; qpdf --password=$PASSWORD --decrypt fichier.pdf nouveaufichier.pdf`

ansible hash password https://stackoverflow.com/questions/19292899 `python -c 'import crypt; print crypt.crypt("This is my Password", "$1$SomeSalt$")'`

force user to change password `chage -d 0 username`

sauvegarder le résultat d'une commande dans une image `$COMMANDE | convert -background black -fill white label:@- $COMMANDE.png`

lire une vidéo sans serveur X (en console) `mplayer -vo fbdev $VIDEOFILE`

Capturer une vidéo de l'affichage (screencast) `ffmpeg -f x11grab -show_region 1 -y -r 25 -s $RESOLUTION -i :0.0+0,0 -b 8000000 screencast.webm`

List all soundcards and digital audio playback/record devices `aplay -l`; `arecord -l`

pulseaudio list output sinks `pacmd list-sinks`

pulseaudio set volume `pacmd set-sink-volume <index> <volume> #where volume=1-65535`

ffmpeg remove first 7 seconds from video file `ffmpeg -i video.mp4 -vcodec copy -acodec copy -ss 7 fin.mp4`

ffmpeg concatenate video files `MP4Box -add debut.mp4 -cat fin.mp4 video_modifiee.mp4`

ffmpeg capture frame at 100 seconds `ffmpeg -i "video.mp4" -vcodec mjpeg -vframes 1 -an -f rawvideo -s 640x360 -ss 100 "capture.jpg"`

ffmpeg keep only 3 first seconds `ffmpeg -i video.mp4 -ss 00:00:00 -t 00:00:03.015 debut.mp4`

Afficher un calendrier `cal`

créer un pdf depuis le manuel d'une commande `man -t $COMMANDE | ps2pdf - > $COMMANDE.pdf`

Voir combien de temps une commande met à se terminer `time $COMMANDE`

chronometer (`Ctrl+C` to stop) `time cat`

Optimiser une image JPG `jpegtran -copy none -optimize $IMAGE temp.jpg; jpegtran -copy none -progressive temp.jpg monimage.jpg`

convertir un fichier video en mp4 `ffmpeg  -i "$FICHIER.avi" "$FICHIER.mp4"`

créer une vidéo à partir d'un morceau en mp3 et de la couverture d'album en jpg `ffmpeg -r 1 -loop 1 -y -i cover.jpg -i audio.mp3 -acodec copy -shortest video.mp4`

rename all .jpeg and .JPG files to .jpg `rename 's/\.jpe?g$/.jpg/i' *`

resize image (but keep ratio) `convert -resize '1024x600^' image.jpg small-image.jpg`

display apache2 traffic in logstalgia `tail -f /var/log/apache2/access.log | logstalgia -640x480 -` @logs

Get HTTP headers with curl `curl -I http://www.example.com`

speedtest with curl `curl -o /dev/null http://speedtest.wdc01.softlayer.com/downloads/test500.zip`

firewall ufw: allow inbound connections on 80/tcp from anywhere `ufw allow 80/tcp`

firewall iptables: allow inbound connections on 80/tcp from anywhere `iptables -A INPUT -i eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT`

firewall iptables: allow outbound traffic for already established 80/tcp connections: `iptables -A OUTPUT -o eth0 -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT`

firewall ufw: drop packets on 80/tcp from anywhere `ufw deny 80/tcp`

firewall ufw: allow 80/tcp only on LAN `ufw allow from 192.168.1.0/24 to any port 80`

firewall iptables: allow 80/tcp only on LAN `iptables -A INPUT -i eth0 -p tcp -s 192.168.1.0/24 --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT; iptables -A OUTPUT -o eth0 -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT`

firewall iptables: delete all rules `Delete all rules`

firewall iptables: Set Default Chain Policies `iptables -P INPUT DROP; iptables -P FORWARD DROP ;iptables -P OUTPUT DROP`

firewall iptables: Block traffic from an IP address `iptables -A INPUT -s $IP -j DROP`

configure username/email for commits:  ``git config --global user.name example; git config --global user.email example@gmail.com ``

git afficher une ancienne révision d'un fichier: ``git show <rev>:path/fo/file.ext``

git ignore changes in already tracked file: ``git update-index --assume-unchanged <file>``. To start tracking changes again: ``git update-index --no-assume-unchanged <file>``

Find the date of the first commit in a git repository: `$ git rev-list --all|tail -n1|xargs git show|grep -v diff|head -n1|cut -f1-3 -d' '`

Generate changelog since a git tag `git log --oneline 0.9.1-mathcore...master | cut -f1 -d" " --complement  |sort`

git checkout a remote branch (and make it a local branch) `git checkout -b test origin/test`

`git diff --cached` to review staged changes

git auto prune remote branches `fetch.prune = true`

git update (pull) all submodules `git submodule update --recursive --init`

git pick only part of a given commit `cherry-pick -n <commit>; git reset; git add -p <file>`

git show differences between two branches for one file: `git diff master -- file`

Doing `git remote set-url --add --push <remote_name> <url>` adds a pushurl for a given remote, which overrides the default URL for pushes. However, you may add multiple pushurls for a given remote, which then allows you to push to multiple remotes using a single git push

You can use rebase to delete a commit, sure: `git rebase $TODELETE --onto $TODELETE^`

git List all merged branches: ``git branch -a --merged``

git List all non-merged branches ``git branch -a --no-merged``

git Delete an already merged remote branch ``git branch -r -d github/already-merged-branch``

git list committers/contributors to a repo `git shortlog -sne` or `git log | grep Author: | sort | uniq`

git remove remote upstream tracking branch `git config branch.branchname.merge ""`

git set upstream remote for a branch `git config branch.branchname.remote origin`

git mirror a Mediawiki wiki locally (no images) `git clone mediawiki:http://url.to/wiki`

git mirror a Mediawiki wiki locally (with images) `git -c remote.origin.mediaImport=true clone mediawiki:http://url.to/wiki`

Virtualization stack on Debian (TODO): sudo aptitude install qemu-launcher virt-manager libvirt-bin lvm2 qemu virt-viewer qemu-kvm bridge-utils; sudo addgroup $USER libvirt

KVM/QEMU enable nesetd virtualization (eg proxmox in libvirt: `options kvm-intel nested=Y` or `options kvm-amd nested=1` in `/etc/modprobe.d/kvm-nested.conf`

Change Android device MAC address `su; busybox ifconfig eth0 hw ether 00:11:22:33:44:55`
Android recovery mode: Power + Vol UP (+Home)

Android download mode: Power + Volume down (+Home)

Android wifi keys storage `/data/misc/wifi/wpa_supplicant.conf`

run VM in headless mode in Virtualbox GUI :`Shift`+ Run

apt remove stale config files `aptitude -y purge ~c`

@regex `grep -E '[0-9]{4}'` matche 4 nombres de 0 à 9 consécutifs @regex

@regex `()` are used to group, to make operators apply to one or more thing. For example, `(ab)+` applies the `+` to `ab`, not just `b`. @regex

@regex `*` matches 0 or more of what's before it. For example, `f\*ck` matches `ck`, `fck`, `ffck`, and so on, with literally any number of `f` characters. @regex

@regex `+` is like `*`, except it matches 1 or more, so `f+ck` would match `fck`, `ffck`, and so on, but not `ck`. Note that if you have `*` you don't need `+`, as `ff*ck` is equivalent to `f+ck`. @regex

@regex `?` matches either 0 or 1 of what came before it. `f?ck` matches either `ck` or `fck`. @regex

@regex `|` is alternation, which picks between alternatives. `(f|d)ck` matches either `fck` or `dck`. @regex

@regex `.` matches any single character. `.ck` will match `ack`, `bck`, `cck`, `dck`, and so on. You usually use `.` in conjunction with `+` or `*` or some other repetition character; for example, `.*` means to match literally anything or nothing at all (any character, 0 or more times) and `.+` matches any non-empty string (any character, 1 or more times). @regex

@regex There are a *lot* of extensions to this basic set; unfortunately, they vary between tool and language. http://en.wikipedia.org/wiki/Perl_Compatible_Regular_Expressions are a fairly common 'extended' regular expression syntax, but by no means universal. @regex

>debian non-free network/wifi card drivers! For your Wi-fi card to work, and if installing Debian, you will need to; either install from the http://cdimage.debian.org/cdimage/unofficial/non-free/cd-including-firmware/ unofficial cd image with included non-free firmwares (Wi-fi will work during the setup procedure); or install using a wired connection. Anyway you have to enable non-free software during setup, and, after initial setup, manually install the firmware-linux-nonfree firmware-atheros packages.

add an apt key `sudo apt-key add $KEYFILE`

add an apt key from remote server `sudo apt-key adv --recv-keys --keyserver $KEYSERVER $FINGERPRINT`

add an apt key to gpg keyring `curl http://mozilla.debian.net/archive.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/rxtx.gpg add -`

show apt package for a file `dpkg -S $FICHIER`

show obsolete apt packages `aptitude search ?obsolete`

search in apt package names/descriptions `apt-cache search $MOTCLE`

show apt package info `apt-cache show $PAQUET`

freeze/hold apt package in its current version `aptitude hold $PAQUET`

create a .deb package from a directory `dpkg-deb --build $REPERTOIRE`

rename a .deb package from control file `dpkg-name $PAQUET`

list installed apt packages, sorted by size `dpkg-query -Wf '${Installed-Size}\t${Package}' | sort -n`

Dennis Ritchie ASCII art `curl -L https://git.io/unix`

Remove old kernels `packages=$(dpkg -l|egrep '^ii  linux-(im|he)'|awk '{print $2}'|egrep -v "($(uname -r)|image-.86|image-amd64)"); aptitude purge $packages`

fire and forget `echo ./program | at now` or `echo 'notify-send "laundry is ready"' | at now + 30 min`

`cd -` takes you to the previously visited directory

@systemd directories `/usr/lib/systemd/system` `/etc/systemd/system` `/etc/lib/systemd/user/` `/etc/systemd/user/`

systemd: unit config directives `include /usr/lib/systemd/system/nfs-secure.service` `CpuShares` (1024=100%), `MemoryLimit`, `BlockIOWeight`, `PrivateTmp=yes`

systemd: View logs with journalctl, eg `journalctl PRIORITY=7 -since=yesterday`, see `man systemd.journal-fields`.

systemd: journaltl by service: `journalctl -u ssh`

systemd: journalctl by date: `journalctl --since="today"`, `journalctl --since="AAAA-MM-JJ hh:mm:ss" --until="AAAA-MM-JJ hh:mm:ss"`

systemd: journalctl for boot `journalctl -xb`

systemd: List units: `systemctl list-units`

systemd: display service status: `systemctl status display-manager.service`

systemd: enable an unit `systemctl enable slim.service`

systemd: start an unit `systemctl start slim.service`

systemd: Look for startup errors `systemctl --failed`

systemd: List startup stages `systemd-analyze blame`

systemd: generate boot time plot: `systemd-analyze plot > plot.svg`

`systemctl stop cups.socket` Fix for CUPS failing to bind port 631 https://ask.fedoraproject.org/en/question/9468/why-systemd-is-listening-on-port-631/ 

>Spending a lot of time learning non-portable technologies isn't a decision to be taken lightly.

allow SSD TRIM operations even when cryptestup is in use: pass `allow-discards` kernel option for the root FS

Fix mouse turning off to often (disable power management) `echo 'CONTROL_USB_AUTOSUSPEND="0"' > /etc/laptop-mode/conf.d/board-specific/no-usb-autosuspend.conf`

Fix mouse horizontal/vertical sensibility/acceleration `xinput --set-prop "SynPS/2 Synaptics TouchPad" "Device Accel Constant Deceleration" 1`

disable keyboard beep: `echo 'options snd_hda_intel beep_mode=0' >> /etc/modprobe.d/alsa-base.conf`

parrallel zipping (faster): `find -type d -print0 | xargs -i -n1 -0 -P4 zip -r {}.zip {}`

Fix native screen resolution not detected in GRUB (eg. netbook monitor) `echo GRUB_TERMINAL=console' >> /etc/default/grub; echo 'GRUB_GFXPAYLOAD_LINUX=1024x600x32' >> /etc/default/grub; sudo update-grub`

`acpi_osi=Linux` in GRUB's kernel command line solves some problems related to backlight handling, volume control keys, power management...


Writing zeros to a usb drive while displaying elapsed time, and a rate of transfer. Update every 2 seconds. `dd if=/dev/zero | pv -ptr -i 2 | dd of=/dev/sdf`

dump failing, unreadable or unmountable hard drive (data recovery) `sudo aptitude install gddrescue; sudo ddrescue /dev/mondisque /media/pointmontage/monimagesauvée.dd /media/pointmontage/monimagesauvée.log -n`

dump failing hard drive, readable sectors first `ddrescue -B -n /dev/old_disk /dev/new_disk rescued.log; ddrescue -B -r 1 /dev/old_disk /dev/new_disk rescued.log`

Fix for chmod -x /bin/chmod  (chmod non exéctuable): `/lib/ld-linux-x86-64.so.2 /bin/chmod +x /bin/chmod` (use the linker to call the chmod syscall) or ``echo -e "#include <sys/stat.h>\nint main(){chmod(\"/bin/chmod\",0755);}" | gcc -xc -; sudo ./a.out `` (rewrite and recompile chmod binary)

Fix for deleted rm binary: `sudo touch /bin/rm && sudo chmod +x /bin/rm; apt-get download coreutils; sudo dpkg --unpack coreutils*`

The "Nethogs" package will always show a fake process called "unknown TCP", that corresponds to everything it can't identify. Notice that it doesn't have a process ID, and the amount of data is shown as 0, indicating that there isn't any unknown traffic

Hide GRUB on boot (unless you press shift) `echo -e 'GRUB_FORCE_HIDDEN_MENU="true"\nexport GRUB_FORCE_HIDDEN_MENU\nGRUB_TIMEOUT=0\nGRUB_HIDDEN_TIMEOUT=5" >> /etc/default/grub`

**Linux physical breach recovery**: stop networking, check `last|less; dmesg|less find -ctime 1 ~ /bin /sbin /usr/bin /usr/sbin /etc |less; less ~/.bash_history`

colorize selected words, print everything else normally `egrep --color=auto 'DOWN|$'` ($ matches end of lines)

generate a random password `pwgen -s 15`

force disk verification at next reboot `touch /forcefsck`

Copy SCSI disk a to SCSI disk b `dd if=/dev/sda | pv -pt | dd of=/dev/sdb`

rsync OS to another drive `rsync -avH /<src-root> /<dst-root>; mount --bind /dev /<dst-root>/dev; chroot /<dst-root>; grub-install /dev/<dst-dev>; #then edit uuids in /etc/fstab`. Or use clonezilla and expand the destination partition with gparted. 

merge several PDF files into one: `pdftk *.pdf cat output all.pdf`

Display a desktop notification over SSH `DISPLAY=:0 notify-send "Hail Satan"`


crypto poor man's steganography: hide a filesystem at the end of a jpg image: `dd if=/dev/urandom of=/disk bs=1M count=1; mkfs.vfat disk; mkdir asfd; mount disk asdf; echo "Place any files you want under 1MB inside asdf and press any key..."; read -n 1; umount asdf; DiskSize=$(du -b disk); echo -n "Enter the filename of the image in which you want to hide the filesystem: "; read ImageFile; cat "$ImageFile" disk > disk.jpg; echo "Done. To extract your filesystem again, run head -c $DiskSize disk.jpg > disk".`

fix debian installer hang after video mode selection on laptop `acpi=off` in grub command line 

print linux kernel command line parameters `cat /proc/cmdline`

firefox enable Ctrl+Tab previews `browser.ctrlTab.previews = true` in about:config

firefox clear bookmarks favicon cache `find ~/ -name "favicons.sqlite*" - exec rm '{}' \;`

firefox force addons compatibility `extensions.checkCompatibility = false` in about:config

fix tearing compton `compton --backend glx --vsync opengl-swc` au cas où on a du tearing

GRUB2: set Super Mario as startup tune `echo "GRUB_INIT_TUNE=\"1000 334 1 334 1 0 1 334 1 0 1 261 1 334 1 0 1 392 2 0 4 196 2\"" | sudo tee -a /etc/default/grub > /dev/null && sudo update-grub #format is tempo [pitch1 duration1] [pitch2 duration2]`

Start command at specified time `echo start_backup.sh | at midnight`

Run jobs in parallel `ls *.png | parallel -j4 convert {} {.}.jpg`

download an URL list `cat urls.txt | wget -i- -T 10 -t 3 --waitretry 1`

simple xss test `</a><script>alert("ICANDOANYTHINGINJS!!!!")</script><imgsrc="http://m.memegen.com/5crl1l.jpg"/><ahref="/test/">`

Fix for touchpad mouse not working `echo synclient TapButton1=1 >> ~/.profile`

Fix reset lost root password: reboot, select desired OS, hit `E`, add `init=/bin/bash` to kernel command line, `mount -o remount,rw / ; passwd; reboot`

change linux user password from a script `echo -e "new_password\nnew_password" | (passwd --stdin $USER)` or `echo "username:password" | chpasswd`

Fix phone not working as USB drive: Enable USB mass storage mode on the phone.

network send files with netcat `netcat -l 12345 > file.pdf` on the server (receiver), `netcat $MY_IP_ADDRESS 12345 < file.pdf` on the client (sender)

attach screenover ssh `ssh user@host -t screen -r`

Compare a remote file with a local file `ssh user@host cat /path/to/remotefile | diff /path/to/localfile -`

simple stopwatch `time read <Ctrl+D>`

Display the top ten running processes. (Sorted by memory usage) `ps aux | sort -nk 4 | tail`

kill all ruby processes `ps aux | grep ruby | awk '{ print $2 }' | xargs kill`

netcat pipe command output to network `nc -q 0 $RECEIVING_HOST 1024`

>Engineering, on the whole, is the art of compromise.

> a good programmer looks both ways before crossing a one way street

display calendar of august 1986 `cal 8 1986`

fix permissions in user home dir @admin @cli `find /home/user -type d -print0 | xargs -0 chmod 0775 find /home/user -type f -print0 | xargs -0 chmod 0664`

parallel tar: `tar cf - |  parallel -j 30 --pipe --recend '' -k lzma -9 > tarfile.txz`

convert an image to 14 colors `mogrify -colors 14 $@` @images

lock the "login" gnome-keyring `python -c "import gnomekeyring;gnomekeyring.lock_sync('login')"` @desktop @password




exclude directories from find output `# find / \( -name excludethis -o -name andthat \) -prune -o -type f -mmin -1`


find multiple file types `$ find . -name "*.png" -o -name "*.jpg" -o -name "*.gif" -type f`


grep text and print 2 following lines `# grep -A2 test /etc/fooserver/file`


find files by user or group `find / -user carla; find / -group admins`

make check if a file or directory exists `$(if $(wildcard $(SRCS)),,$(fatal You have not generated source code...))`

find files by user and change ownership `# find / -user carla -ok chown -v steven {} \;`

x11 get list of windows `xwininfo -tree -root`

send keypress to window based on window name `xdotool key --window "$(xdotool search --class Libreoffice | head -n1)" Down`

fix sound crackles in mpv `--softvol=yes`

limit user processes to 10000 `/etc/security/limits.conf: user hard nproc 10000`


checkout github Pull Requests locally ` fetch = +refs/pull/*/head:refs/remotes/origin/pr/*`

git use hooks directory from local repo `git config core.hooksPath .githook`

list listening ports (from local machine): `netstat -tulp` or `ss -pau`

list listening ports (from remote machine): `nmap -sTU`

detect listening ports (using TCP/UDP sockets from local machine): `lsof -i -n | egrep "COMMAND|LISTEN|UDP"`

list ipv6 listening ports `ss -6pau`

pdf to image `convert -verbose "$i" "$i".jpg`

locate files not owned by any user/group: `find / -path /proc -prune -o -nouser -o -nogroup`

extract public key from private `openssl rsa -in $1 -pubout`

not fun man `echo "echo sleep 0.1 >>~/.bashrc" >> ~/.bashrc`
not fun man `{ crontab -l; echo "@hourly eject; eject -t; }" | crontab`

remove empty directories `find -type d -empty -delete`

find all files owned by an user: `find / -path /proc -prune -o -user <account> -ls`


git shallow submodules `git config -f .gitmodules submodule.<name>.shallow bool`

edit git submodule URL: edit the .gitmodules file and run git submodule sync

Virtualbox create virtual disk linked to raw disk/USB drive: `VBoxManage internalcommands createrawvmdk -filename "</path/to/file>.vmdk" -rawdisk /dev/sda`. User must be in vboxusers group. Unerlying block device must be rw for user.

f = c/lambda
U=RI
P=UI
U=W/q
I=deltaq/t

list possible openers for a file `gvfs-mime --query inode/directory`

change associated program `gvfs --set inode/directory org.gnome.Nautilus.desktop`

virtualbox host-only network: create host-only network in VB preferences, set ip to 192.168.56.1, netmask to 255.255.255.0, no dhcp; add host-only network adapter to VM; in VM, list adapters: `ls /sys/class/net`; `nano /etc/network/interfaces`; setup interface address to 192.168.56.x, netmask, network and broadcast settings; reload networking

NetworkManager: use local caching DNS proxy (dnsmasq/dnscrypt): `/etc/NetworkManager/NetworkManager.conf`: `dns=127.0.0.1`

disable firewire/DMA: blacklist modules firewire_ohci firewire_sbp2 firewire_core yenta_socket pcmcia

isc-dhcp-server dhcpd.conf directives: `subnet netmask {range; default-lease-time; option domain-name-server; option routers; }`

isc-dhcp-relay `/etc/default/isc-dhcp-relay: SERVERS; INTERFACES`

bind/rndc commands: `flush, querylog, reload, status, dumpdb -zones, notify <zonename>`

bind ACLs `/etc/bind/named.conf.options: acl mynetworks { 172.21.16.0/22; 192.168.0.0/16; }; options { ... allow-[query|recursion] { mynetworks; }; ...};`

bind listen only on IPv4 `/etc/systemd/system/multi-user.target.wants/bind9.service: ExecStart: /usr/bin/named -4 -f -u bind`

bind zone definition `/etc/bind/named.conf.local: zone "example.com" { type master/slave/forward; forward only; forwarders {x.x.x.x;}; masters {x.x.x.x;}; allow-transfer {x.x.x.x;}; file "/var/cache/bind/db.example.com";};`

git show changed files between 2 commits: `git diff --name-only SHA1 SHA2`

free disk space charts in HTML: `dfc -c always -p -tmpfs,devtmpfs,cgroup,cgmfs -e html >| /var/log/last-dfc.html`

convert git shallow repository to full: git fetch --unshallow

I've used a chainsaw, and you're simultaneously amazed at (1) how easily it slices through a tree, and (2) that you're dumb enough to use this thing three feet away from your vital organs. This is Unix.

add SSH key to gnome-keyring: /usr/lib/x86_64-linux-gnu/seahorse/seahorse-ssh-askpass id_rsa

show ansible facts: ansible all -m setup -a "filter=ansible_distribution*"

python list builtins: dir(__builtins__)

inotify: inotifywait -m -r -e modify,attrib,close_write,move,create,delete /tmp

LVM: fdisk, pvcreate, vgextend, pvmove, vgreduce/vgsplit

SSL/TLS X509 cert to text: `openssl x509 -in cert.pem -text`

html iframe: <iframe src="https://www.w3schools.com"></iframe>

jack/pulseaudio create multiple PA sinks: pacmd load-module module-jack-sink channels=2

list possible file openers/associations: 'gvfs-mime --query inode/directory'

change file associations: 'gvfs-mime --set inode/directory org.gnome.Nautilus.desktop'

nftable (nft tool) replaces/consolidates iptables + ip6tables + arptables + ebtables + tc

`ip` replaces/consolidates `ifconfig + iwconfig + route + arp + netstat` (net-tools)

show available entropy: cat /proc/sys/kernel/random/entropy_avail

show configured network interfaces IP addresses: `ip -c addr`

setup source NAT (SNAT): `iptables -t nat -A POSTROUTING -o ethpublic0 -j SNAT --to 8.9.10.11`

iptables make rules permanent: `apt install iptables-permanent; iptables-save > /etc/iptables/rules.v4; cat /etc/iptables/rules.v4 | iptables-restore`

extract audio from video without conversion: `ffmpeg -i video.mp4 -vn -acodec copy audio.aac`

build debian APT repo packages index: dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz

mount a specific partition from an ISO/disk image file: `sudo losetup /dev/loop0 blankimg.iso ; sudo losetup /dev/loop1 blankimg.iso -o 1048576; sudo mount /dev/loop1 /mnt/` where 1048576 is fdisk's number of sectors * number of bytes-per-sector (here 2048x512)

detach all loop devices: `losetup -D`

find files not owned by you: find ~ ! -user ${USER}

type unicode character from keyboard in linux: Ctrl + Shift + U, 2b50, Enter

virtualbox change resolution: VBoxManage controlvm "Name of VM" setvideomodehint 1366 768 32

http://xmodulo.com/limit-network-bandwidth-linux.html `trickle -d 300 firefox %u`

https://www.cyberciti.biz/faq/ping-test-a-specific-port-of-machine-ip-address-using-linux-unix/ `nmap -PNp {port} {host}` `nc -vz {host} {port}`

view contents of files matching a pattern, prefixed by the filename: `grep . *.txt`

display contents of all files matching a pattern, separated with decoration and the filenames: `more *.txt | cat`

SSH jumpbox: `ssh -J myuser@jumpbox myuser@securebox`

update debian changelog: `dch -a`

OpenDNS servers: 208.67.222.222 and 208.67.220.220

fix optimus/bumblebee lockup at boot: kernel boot parameters `nouveau.modeset=0 acpi_osi=Linux acpi_osi="!Windows 2015"`

Network classes: A /8 0-127; B /16 128-191; C /24 192-223; D multicast 224-239; E reserved 240-255

Private networks: <https://tools.ietf.org/html/rfc1918>: 24bit/8 10-11 (1xClassA); 20bit/12 172.16-172.31 (16xClassB; 16bit/16 192.168-255 (256xClassC)

Link-local/private networks <https://tools.ietf.org/html/rfc6890> Special-Purpose IP Address Registries: 0/8; 10/8 priv; 100.64/10 carrier; 127/8 loopback; 169.254/16 link-local; 172.16/12; [...] 192.168/16 priv; 198.18/15; 198.51.100/24; 203.0.113/24; 240/4; 255 (testnet,res,doc,bench)

mysql dump/backup AND compress database: `mysqldump -u myuser --password -p -C wallabag > /tmp/wallabag_backup.sql.tgz`

force automatic fsck: kernel boot parameters: `fsck.repair=yes fsck.force=yes`

get public IP address: `curl https://icanhazip.com/`

fix "gave up waiting for suspend/resume device": add `noresume` kernel boot parameter

TCP handshake: A SYN, B SYN-ACK, A ACK, ESTABLISHED

SYN flood/spoofing attack detection: `netstat -n -p TCP` : connections in SYN_RECV state. Or look in TCP statisctics for `tcpHalfOpenDrop` connection (`netstat -s -p TCP | grep tcpHalfOpenDrop`). Protection: turn on syn cookies, or increase TCP backlog queue (`net.ipv4.tcp_max_syn_backlog`), or decrease number of SYN-ACK reply attempts (`tcp_synack_retries`) <https://www.symantec.com/connect/articles/hardening-tcpip-stack-syn-attacks>



docker run command in container `docker run -i -t --entrypoint /bin/bash 95158d7abcde #image ID`

docker list running containers `docker ps -a`

docker resume working in running container `docker start 417c6a8abcde && docker exec -i -t 417c6a8abcde /bin/bash`

copy file from docker container to host: `docker cp f03f4fdabcde:/tmp/loot/myloot.tar.gz ./myloot.tar.gz`

video as desktop background https://github.com/ujjwal96/xwinwrap  `file=$(find /media/EXT4-2TB-A/ARCHIVES/AV/222-VJLOOPS/ -type f | sort -R | tail -n1); xwinwrap -g 350x350+50+320 -ov -ni -s -nf -b -un -argb   -- mpv --loop=inf --wid WID "$file"`

count installed packages: aptitude search ~i | egrep -v '^i A '|wc -l

ansible run setup module agains an inventory: `ansible --connection ssh --user myremoteuser -m setup --private-key keys/id_rsa all`

find packages installed but not vailable in the repositories configured in sources.list: `aptitude search '?narrow(?not(?archive("^[^n][^o].*$")),?version(CURRENT))'`

count installed packages: aptitude search ~i | egrep -v '^i A '|wc -l

find suid files:  `find / -perm 4755 2>/dev/null`

find sticky files: `find / -perm 1755 2>/dev/null`

find sgid files: `find / -perm 2755 2>/dev/null`

check for hardware virtualization support: egrep '(vmx|svm)' /proc/cpuinfo


ufw allow outgoing port 80 to IP address: ufw allow out proto udp from any to 37.48.65.153 port 80


show disk statistics and serial number: inxi -c0 -xx -D | tail -n +2


bash create a directory and cd into it: mkdir -p a/directory/ && cd $_
bash create backup file: cp file.txt{,.bak}
bash diff the output of 2 commands: diff <( command1 ) <( command2)
bash empty a file: > file.txt
bash generate random number between 1 and 10: echo $%%(%%($RANDOM%10))
bash less follow mode (like tail): less +F somelogfile
bash most used commands: history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
bash most used commands: history | awk '{print $2}' | sort | uniq -c | sort -rn | head -n 20
bash replace BEFORE with AFTER in previous command (all): !:gs/BEFORE/AFTER
bash replace BEFORE with AFTER in previous command (last occurrence): ^BEFORE^AFTER^

bash sums: `i=$((2+2))`

do not log commands containing EXAMPLE in bash history `HISTIGNORE="*EXAMPLE*"`



Display process tree `pstree -p`

Find a process PID by command name `pidof COMMAND`

Kill a process by PID `kill PID` or by command `killall COMMAND`

Return the PWD of any PID you pass to it `pwdx -`

Sends SIGKILL to all processes except itself and init `kill -9 -1`


convert image to data: URL (base64): base64 IMAGE.jpg


mount qcow2 disk: sudo modprobe nbd max_part=8; sudo qemu-nbd --connect /dev/nbd0 /path/to/disk.qcow2; sudo mount /dev/nbd0p1 /mnt; sudo umount /mnt; sudo qemu-nbd --disconnect /dev/nbd0



ansible readable output: `stdout_callback = debug` in ansible.cfg


Apache trace mod_rewrite rules `LogLevel warn rewrite:trace3`


make: check if a file or directory exists: ` $(if $(wildcard $(SRCS)),,$(fatal You have not generated source code...))`


Unlock keepass with gnome-keyring password: secret-tool lookup database Nextcloud.kbdx | /usr/bin/keepassxc --pw-stdin /path/to/db.kdbx


install rubygem per-user: ` sudo apt install ruby ruby-dev; gem install --user-install gem_name`


shrink sparse qcow2 disk image: qemu-convert -p -O qcow2 source.qcow2 dest-shrunk.qocw2


set pulseaudio volume: pactl set-sink-volume @DEFAULT_SINK@ +5%


openssl show certificate info: `echo | openssl s_client -showcerts -servername google.com -connect gnupg.org:443 2>/dev/null | openssl x509 -inform pem -noout -text`


packet capture on remote machine and display in local wireshark: ssh root@remoteserver "tcpdump -c 1000 -nn -w - not port 22" | wireshark -k -i -


SSH copy local folder to remote: tar -cvj /datafolder | ssh remoteserver "tar -xj -C /datafolder"


ss equivalent to netstat -pltuna: ss -aptu


systemd edit unit file: systemctl --edit nginx.service


strace filter syscalls: strace -e openat,getdents command


strace command: strace command


strace attach to process: strace -p PID


strace profiling: strace -c command


temporarily change debconf frontend: sudo DEBIAN_FRONTEND="gnome" dpkg-reconfigure debconf


raspberry pi disable HDMI 25mA power saving: `/usr/bin/tvservice -o`


adb tail androind logs: `adb logcat -v color`


adb android show ERROR log messages: `adb logcat *:E`

linux Get all extensions and their respective file count in a directory https://serverfault.com/questions/183431/ `find ./ -type f | grep -E ".*\.[a-zA-Z0-9]*$" | sed -e 's/.*\(\.[a-zA-Z0-9]*\)$/\1/' | sort | uniq -c | sort -n`

