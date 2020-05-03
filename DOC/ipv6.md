# IPv6

https://en.wikipedia.org/wiki/IPv6

### Addressing

* 128bits: 8x16bits (hextets) separated by `:`  
* Leading zeros can be abbreviated to one  
* No broadcast address
* Increased address space (10^36)
* Simplified packet handling (8 headers instead of 12)
* Removes need for NAT

#### Global unicast

```
48          16       64
GlobalPrefix SubnetID InterfaceID /PrefixLength
```

#### Multicast

* `FF:...`
* `FF02::1` All nodes
* `FF02::2` All routers
* Used for RIPv2/RIPng dynamic routing `FFO2::9` (IPv4 224.0.0.9)


#### Link-local

`FE80::/10`, only on same link (subnet/broadcast domain)  
`FE80 <-> FEBF`


#### Other

 * Loopback `::1/128`
 * Unspecified `::/128`
 * Unique local `FC00::/7 - FDFF::/7`


### Packet

```
| Version (4) | Traffic class (8) | Flow label (QoS) (20) |
| Data length (16)   | NextHeader (8) | HopLimit (8)      |
|               Source address (128)                      |
|               Dest. address (128)                       |
|                   Data ...                              |
```

### NDP

Neighbor Discovery Protocol: replacement for ARP

Solicited Node Multicast Address: `FF02:0:0:0:01:FF0::XX:XXXX` where  XX:XXX = last 24 bits of global unicast address

To get the MAC of a host, client sends a NS (neighbor solicitation) to host's Solicited Node Address, host replies with MAC.


### Autoconfiguration

**SLAAC:**

  * Client sends RS (Router Solicitation ICMPv6) to [multicast](#multicast) `FF02::2`
  * Router repsonds with RA (Router Advertisement)
    * Prefix
    * Prefix length
    * Default gateway (source of RA)
    * No DNS
  * Client generates its Interface ID
    * Randomly
    * Using EUI64 method: `| 48bit MAC OUI (7th reversed) | FFFE (16) | 24bit MAC DeviceID |`
  * Client runs DAD (Duplicate Address Detection): sends a packet to it's own Solicited Node address, if no reply, address is unique.

**Other options:**
 * **SLAAC + Stateless DHCPv6**: Same as above but clients requests _options_ from a DHCPv6 sever (DNS, NTP...)
 * **Stateful DHCPv6**: DHCPv6 is used for addressing + options


#### ICMPv6
 
 * Used for RS/RA (SLAAC) and NDP
 * Encapsulation directly in IPv6 packets


### DHCPv6

 * DHCPv6 messages: Solicit, Advertise, Informations, Request, Reply

#### Cisco commands IPv6

    #ipv6 unicast-routing
    #ipv6 address FE80::1 link-local
    >show ipv6 interface brief ([up/up] = [layer1/layer2])
    >show ipv6 route
```
