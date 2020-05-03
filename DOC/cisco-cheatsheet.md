```
! Help
?

! Enter privilegied mode
enable
! Enter configuration mode
conf terminal

! Change hostname
hostname SW1

! Set privilegied mode password
enable secret cisco   !MD5
enable password cisco !cleartext

! Secure console port
line console 0
password cisco
! Enforce console login prompt
login

! Secure terminal lines (telnet/ssh)
! line vty <TAB> to see the number of vtys
line vty 0 4
password cisco
! Enforce vty passwords
login
! Set timeout to 10min 30min (?)
exec-timeout 10 30
! Display log messages on console
logging synchronous

! Encrypt console/vty passwords
service password-encryption

! Set banner
banner motd ^UNAUTHORIZED ACCESS IS PROHIBITED^

! Give the switch an IP address (SVI interface)
interface vlan 1
ip address 10.10.10.1

! Save configuration
copy running-config startup-config

! Disable domain lookups on command not found
no ip domain-lookup

! Configure SSH username/password
username admin password cisco

! Generate rsa keys
crypto key generate rsa

! Define SSH version
ip ssh version 2

! Enable SSH on VTY lines
line vty 0 4
login local
transport input ssh

! Layer 1 interface options
int fa0/1
! or it range fa0/1-24
description LINK TO ROUTER
speed 100
duplex full

! Basic data
show version
show run
show start
show history

! Layer 1/2/3 information
show ip interface brief
show interface fa0/1
show interfaces description

! Show SSH public key
show crypto mypubkey rsa

! Show DHCP leases
show dhcp lease

!!!! VLAN
! Make the switch port an access port
switchport mode access
! Enable port security
switchport port-security
! Set the max. number of MAC addresses allowed for the port to 2
switchport port-security maximum 2
! Define the action to take when violation occurs
switchport port-security violation shutdown
switchport port-security violation protect
switchport port-security violation restrict
! Specify allowed MAC addresses (sticky: remember connected MACs)
switchport port-security mac-address sticky
! Show MAC addresses table
show mac-address-table
! Show overview of port security
show port-security
! Show detail port security info for a port
show port-security interface fa0/5

! Create a VLAN
vlan 10
name SALES
! Assign an interface to a VLAN
int fa0/5
switchport mode access
switchport access vlan 15
! Auxiliary voice VLAN for IP phones
int fa0/5
switchport access vlan 10         !data
switchport voice vlan 12          !voip

! Configure trunks
int fa0/1
switchport mode trunk                   !trunk,auto,dynamic desirable
! Set allowed vlans on trunk     
switchport trunk allowed vlan 10        !add,remove,all,except


! DIsable unused interfaces
int range fa0/12-24
shutdown

! Disable trunk auto-negotation (DTP) on the interface
nonegotiate
switchport mode access

! assign the port ot an unused vlan (blackhole)
switchport access vlan 222

! List all trunks
show interfaces trunk

! Show VLAN info
show vlan !brief,id,name,summary

!!!! SPANNING TREE/STP/ETHERCHANNEL
! Define the root bridge
spanning-tree vlan 1 root primary
! Define the secondary root bridge
spanning-tree vlan 1 root secondary
! Set bridge priority
spanning tree vlan 1 priority 8192 !multiple of 4096
! Change the STP mode
spanning-tree mode rapid-pvst
! Enable Portfast (switch to FORWARDING state quickly)
spanning-tree portfast
! Enable BPDU guard
spanning-tree bdpuguard enable
! Change spanning tree port cost
spanning-tree clan 1 cost 25
! Show spanning tree details
show spanning-tree
show spanning-tree interface fa0/2
show spanning-tree vlan 1
show spanning-tree vlan 1 root !show info about the root bridge
show spanning-tree vlan 1 bridge !show info about the local bridge
! Add an etherchannel
channel-group 1 mode on
! show state of etherchannels
show etherchannel 1
! info about changes in STP topology
debug spanning-tree events

!! CDP
! enable cdp globally
cdp run
! disable cdp on an interface
no cdp enable
! show global CDP inforamtion
show cdp
! show info about CDP on an interface
show cdp interface fa0/2
! show info about directly connected CDP/cisco devices (device address, IOS version)
show cdp neighbors !detail,entry


!!!! ROUTER ON A STICK
int fa0/0.10
encapsulation dot1q 10
ip address 192.168.10.0 255.255.255.0
int fa0/0.20
encapsulation dot1q 20
ip address 192.168.20.0 255.255.255.0
int fa0/0.30
encapsulation dot1q 30
ip address 192.168.30.0 255.255.255.0
int fa0/0
no shutdown

!!!! Static routing
! using nexthop
ip route 10.2.1.0 255.255.255.0 10.10.0.254
! using exit interface
ip route 10.2.1.0 255.255.255.0 serial0/0/0 !Point-to-point only, no multiple access links!!!
! default route
ip route 0.0.0.0 0.0.0.0 199.0.0.1

!!!! RIP
router rip
version 2
network 10.0.0.0 !classful
no auto-summary
passive-interface s0/0/0

!!!! SHOW DYNAMIC ROUTING INFO
show ip protocols

! show routing table
show ip route
show ip route rip
show ip route 10.2.1.0

!!!! OSPF
router ospf 10
router id 1.1.1.1
network 10.0.0.0 0.255.255.255 area 0
network 192.168.0.0 0.0.255.255 area 1
network 172.16.0.0 0.0.4.255 area 2

!!! CONFIGURE A LOOPBACK INTERFACE
interface loopback 0
ip address 1.1.1.1 255.255.255.255

! change ospf hello and dead intervals
ip ospf hello-interval 2
ip ospf dead-interval 6

! change ospf cost
ip ospf cost 55

! change interface bandwidth
bandwidth 128 !kbps

! change bandwidth reference for cost calculation
auto-cost reference bandwidth 1000 !mbps

! disable ospf on an interface

!!! TODO


!!!!!!!!!!!!!!!!!!!!!!!!!


! NAT
! https://www.cisco.com/c/en/us/support/docs/ip/network-address-translation-nat/13772-12.html#topic2
!                       | address pool | (no overload)
!                       | 172.16.10.1  |
!                       | ......       |
!                       | 172.16.10.63 |
!        10.10.10.1/24       |
! Ḋ_Ḋ_Ḋ___________           |
!  Ḋ Ḋ           |           |
!              e0|         __|      OUTSIDE
!         ḊḊḊḊḊḊḊḊḊḊḊḊḊ    |
! INSIDE  Ḋ    R1   ḊḊḊ-------------Z
!         ḊḊḊḊḊḊḊḊḊḊḊḊḊ   |        Z                   WAN / INET
!              e1|        |       Z----------------- - - - --  -
!                |        |   
! Ḋ_Ḋ_Ḋ__________|       | address     | (overload)
!  Ḋ Ḋ  10.10.20.1/24    | 172.16.10.1 |
!
!
!
!
!
! cisco nat router
!----------------------------------------------------------
!----- INSIDE/OUTSIDE INTEFACES DEFINITIONS
!----------------------------------------------------------
!--- Defines Ethernet 0 with an IP address and as a NAT inside interface.
interface ethernet 0
 ip address 10.10.10.1 255.255.255.0
 ip nat inside

!--- Defines Ethernet 1 with an IP address and as a NAT inside interface.
interface ethernet 1
 ip address 10.10.20.1 255.255.255.0
 ip nat inside

!--- Defines serial 0 with an IP address and as a NAT outside interface.
interface serial 0
 ip address 172.16.10.64 255.255.255.0
 ip nat outside

!----------------------------------------------------------
!- Configuring NAT to Allow Internal Users to Access the Internet 
!-------------------
!--- Defines a NAT pool named no-overload with a range of addresses
!--- 172.16.10.1 - 172.16.10.63. 
ip nat pool no-overload 172.16.10.1 172.16.10.63 prefix 24

!--- Access-list 7 permits packets with source addresses ranging from
!--- 10.10.10.0 through 10.10.10.31 and 10.10.20.0 through 10.10.20.31.
access-list 7 permit 10.10.10.0 0.0.0.31
access-list 7 permit 10.10.20.0 0.0.0.31

!--- Indicates that any packets received on the inside interface that
!--- are permitted by access-list 7 has
!--- the source address translated to an address out of the
!--- NAT pool "no-overload".
ip nat inside source list 7 pool no-overload 

!----------------------------------------------------------
!- Configuring NAT to Allow Internal Users to Access the Internet Using Overloading
!-----

!--- Defines a NAT pool named ovrld with a range of a single IP
!--- address, 172.16.10.1.
!--- the NAT pool "ovrld" only has a range of one address
ip nat pool ovrld 172.16.10.1 172.16.10.1 prefix 24

!--- Access-list 7 permits packets with source addresses ranging from
!--- 10.10.10.0 through 10.10.10.31 and 10.10.20.0 through 10.10.20.31.
access-list 7 permit 10.10.10.0 0.0.0.31
access-list 7 permit 10.10.20.0 0.0.0.31

!--- Indicates that any packets received on the inside interface that
!--- are permitted by access-list 7 has the source address
!--- translated to an address out of the NAT pool named ovrld.
!--- Translations are overloaded, which allows multiple inside
!--- devices to be translated to the same (single) valid IP address.
ip nat inside source list 7 pool ovrld overload


! variation of this command:
! configures NAT to overload on the address that is assigned to the serial 0 interface.  
ip nat inside source list 7 interface serial 0 overload
```