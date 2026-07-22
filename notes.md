# BADASS

| Protocol | Typical Usage                     | Scope                   |
| -------- | --------------------------------- | ----------------------- |
| OSPF     | Enterprise networks               | Inside one organization |
| IS-IS    | Large enterprise and ISP networks | Inside one organization |
| BGP      | Internet and ISP interconnections | Between organizations   |


## 1- BGPD

Use Border Gateway Protocol (RFC 1771)

In FRR:

bgpd
├── TCP sessions to neighbors
├── Receives route advertisements
├── Applies routing policies
├── Selects best paths
└── Installs routes into the kernel

### A- Autonomous Systems

Autonomous System (AS): Connected group of one or more IP prefixes run by one or more network operators which has a SINGLE and CLEARLY DEFINED routing policy.

ASN : Identifying number associated with each AS.

ASN is one of the essential elements of BGP. BGP is a distance vector routing protocol, and the AS-Path framework provides distance vector metric and loop detection to BGP.

### B- Address Families

BGP supports an Address Family Identifier (AFI) for IPv4 and IPv6.

### C- Route Selection

0. Admin distance check (prefer the route with a lower admin distance)
1. Wight check (prefer higher local preference routes to lower)
2. Local preference check (prefer higher local preference routes to lower)
3. Local route check (prefer local routes to received routes)
4. AS path lenght check (prefer shortest hop-count AS_PATHS)
5. Origin check (prefer the lowest origin type route)
6. MED Check
7. External check
8. IGP cost check (prefer the route with the lower IGP cost)
9. Multi-Path check (If multi-pathing is enabled, then check whether the routes not yet distinguished in preference may be considered equal)
10. Already-selected external check (Where both routes were received from eBGP peers, then prefer the route which is already selected)
11. Router-ID check (Prefer the route with the lowest router-ID.)
12. Cluster-List length check (The route with the shortest cluster-list length is used.)
13. Peer address (Prefer the route received from the peer with the higher transport layer address, as a last-resort tie-breaker.)

## OSPFD

OSPF is a link-state routing protocol. In contrast to distance-vector protocols such as BGP, routers instead describe the state of their links to their immediate neighboring routers.

LSA: Message in which each router describes their link-state information. It is propagated through to all other routers in a link-state routing domain ==> process called flooding.

A link-state protocol can use less bandwidth and converge more quickly than others protocols (need to distribute only one link-state message when a link on any singler given router changes state). Disadvantage is that the process of computing the best paths can be relatively intensive.

Uses IP protocol 89 (Not TCP or UDP).

### A- Hello protocol

Quickly detect changes in two-way reachability between routers on a link. Also used to propagate certain state between routers sharing a link.

### B- LSAs

The core objects in OSPF are LSAs. Everything else in OSPF revovles around detecting what to describe in LSAs, when to update them, how to flood them throughout a network and how to calculate routes from them.

- LSA Header : Type and Advertising router, LSA ID, Age (Number to allow stale LSAs to be purged by routers from their LSBDs), Sequence number
- Link-State LSAs: Router LSA, Network LSA
- External LSAs: describe routing information which is entirely external to OSPFm and is "injected into OSPF".
- Summary LSAs: Summary LSAs are created by ABRs to summarise the destinations abailable within one area to other areas.

## IS-IS

ISIS is an IGP. Compared with RIP, ISIS can provide scalable network support and faster convergence times like OSPF. ISIS is widely used in large networks such as ISP and carrier backbone networks.

IS-IS is very similar to OSPF.

It is also:

Link-state
Uses shortest-path calculations
Maintains a topology database
Converges quickly

The difference is mostly historical and architectural.

OSPF was designed by the IP world.

IS-IS came from the OSI networking world and was later adapted to IP.

## Zebra

zebra is an IP routing manager. It provides kernel routing table updates, interface lookups, and redistribution of routes between different routing protocols.

All above protocols do not directly modify the routing table. They talk their optimal route to Zebra, it collects all candidate routes then it decides which one is installed.

The Linux kernel forwards packets. Zebra tells the kernel which routes exist, and the routing daemons tell zebra which routes they have learned.


## VLAN

Virtual Local Area Network ==> Split one physical Ethernet network into multiple isolated logical networks.

Imagine a switch with four PCs:

PC1 ----+
        |
PC2 ----+--- Switch
        |
PC3 ----+
        |
PC4 ----+

Without VLANs, all ports belong to the same Layer 2 network.

Consequences:

Everyone can send ARP requests to everyone.
Everyone shares the same broadcast domain.
A DHCP server can answer every machine.
Users and servers are mixed together.

The switch treats VLANs as separate Layer 2 networks. To communicate, they need a router ==> Inter-VLAN Routing

## VxLAN (RFC 7348)

### A- Concept

In the case VMS in a data center are grouped according to their Virtual LAN, one might need thousands of VLANs to partition the traffic. The current VLAN limit of 4094 is inadequate in such situations.

VXLAN uses a 24 bit VXLAN Network Identifier (VNI) ==> 16,777,216 possible virtual networks.

VXLAN allows you to extend Layer 2 networks over a Layer 3 network by encapsulating Ethernet frames inside UDP packets.

Instead of sending:

Ethernet Frame directly, we encapsulate it inside an IP packet:

Ethernet Frame
        ↓
VXLAN Header
        ↓
UDP
        ↓
IP
        ↓
Ethernet

The routers only see:

IP + UDP

and happily forward it.

The original Ethernet frame is hidden inside.

### B- VTEP

VTEP = VXLAN Tunnel Endpoint

The VTEP performs:

Encapsulation

Receives:

Ethernet Frame

Creates:

IP + UDP + VXLAN + Ethernet Frame

and sends it.

Decapsulation

Receives:

IP + UDP + VXLAN + Ethernet Frame

Removes:

IP
UDP
VXLAN

and forwards the original Ethernet frame.

## BGP EVPN (RFC 7432)


|                               | OSPF                              | BGP EVPN                               |
| ----------------------------- | --------------------------------- | -------------------------------------- |
| Layer/purpose                 | Underlay                          | Overlay control plane                  |
| Knows about                   | Routers and IP networks           | Hosts, MACs, IPs, VTEPs                |
| Main question                 | "How do I reach that VTEP?"       | "Which VTEP has that host?"            |
| Used by                       | All routers in the underlay       | RR and VTEPs                           |
| Example route                 | `10.0.0.3/32 via ...`             | `MAC B → VTEP 10.0.0.3`                |
| Used for                      | IP connectivity                   | MAC/IP reachability                    |
| Carries user Ethernet frames? | No                                | No                                     |
| Enables VXLAN?                | Yes, by providing IP reachability | Yes, by providing endpoint information |
