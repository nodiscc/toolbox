# nmap cheatsheet

```
nmap -v host1 host2 192.168.1.1 #scan hosts (verbose)
nmap 192.168.1.0-20             #scan addresses range
name 192.168.1.0/24             #scan subnet
nmap -iL /path/to/addresses/list.txt #get addresses from a text file
nmap 192.168.1.0/24 --exclude 192.168.1.5,192.168.1.254 # exclude addresses from scanning
nmap -iL /tmp/scanlist.txt --excludefile /tmp/exclude.txt # exclude addresses in a text file
nmap -v -A 192.168.1.1          # -A switch: try to detect OS and version
nmap -sA 192.168.1.254          # -sA: find if host is firewalled
nmap -PN 192.168.1.1            # scan a firewalled host
nmap -6 2607:f0d0:1002:51::4    # scan an IPv6 address
nmap -sn 192.168.1.0/24         # network discovery/ping scan (replaces deprecated -sP)
nmap -F 192.168.1.1             # fast scan
nmap --reason 192.168.1.1       # Display the reason a port is in a particular state
nmap --open 192.168.1.1         #only show open ports
nmap --packet-trace 192.168.1.1 # show all sent/received packets
nmap -p 80,443 192.168.1.1      # scan specific ports
nmap -p 80-200 192.168.1.1      # scan port range
nmap -p U:53 192.168.1.1        # scan UDP port
nmap -p U:53,111,137,T:21-25,80,139,8080 192.168.1.1 #combine port scan options
nmap --top-ports 5 192.168.1.1  #scan most-common ports
nmap -T5 192.168.1.0/24         # fast open port scan (aggressive, may miss results)
nmap -T4 192.168.1.0/24         # faster scan, slower but more reliable than T5
nmap -v -O --osscan-guess 192.168.1.1 # identify remote host OS and apps
nmap -O 192.168.1.1             # standalone OS detection
nmap -sV 192.168.1.1            #detect remote services versions
nmap --version-intensity [0-9] 192.168.1.1 # control version detection aggressiveness (0=light, 9=try all)
nmap -PS 80,21,443 192.168.1.1  #-PS: TCP SYN ping scan
nmap -PA 80,21,443 192.168.1.1  #-PA: TCP ACK ping scan
nmap -PU 2000.2001 192.168.1.1  #-PU: UDP ping scan
nmap -sS 192.168.1.1            # stealth (SYN) scan
nmap -sT 192.168.1.1            # find most common ports using TCP connect scan
nmap -sA 192.168.1.1            # find most common ports using TCP ACK scan.
nmap -sW 192.168.1.1            # TCP window scan
nmap -sM 192.168.1.1.1          # TCP Maimon scan
nmap -sU 192.168.1.1            # scan for UDP listeners
nmap -sO 192.168.1.1            # scan for IP protocols support (ICP,IGMP,TCP...)
nmap -sN 192.168.1.254          # TCP null scan. -sF: TCP FIN scan, -sX: Sets the FIN, PSH, and URG flags
nmap --script=default 192.168.1.1 # run NSE scripts from the default category
# NSE scripts path: /usr/share/nmap/scripts/
# available NSE script categories: auth/broadcast/brute/default/discovery/dos/exploit/external/fuzzer/info/intrusive/malware/safe/version/vuln
nmap -f fw2.nixcraft.net.in     # fragment TCP packets (avoid IDS/DPI), set --mtu 32to set packet size
nmap -n -Ddecoy-ip1,decoy-ip2,your-own-ip,decoy-ip3,decoy-ip4 remote-host-ip #create decoy scanners from other IP addresses
nmap -sV -oN scan.txt 192.168.1.1            # save normal output to file
nmap -sV -oX scan.xml 192.168.1.1            # save XML output to file
nmap -sV -oG scan.gnmap 192.168.1.1          # save grepable output to file
nmap -sV -oS scan.txt 192.168.1.1            # save script kiddie (simple text) output to file

# Timing templates: T0 (paranoid/slowest) to T5 (insane/fastest) affect parallelism, host group size, RTT timeouts, retransmission rate

```
