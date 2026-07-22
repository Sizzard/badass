# #!/bin/sh

# #  Interfaces de transport (underlay) 
# # Adresses IP utilisées pour joindre les différents VTEP
# ip addr add 10.1.1.1/30 dev eth0
# ip addr add 10.1.1.5/30 dev eth1
# ip addr add 10.1.1.9/30 dev eth2

# ip link set eth0 up
# ip link set eth1 up
# ip link set eth2 up

# #  Adresse loopback du routeur 
# # Cette adresse identifie de manière unique le routeur dans le réseau
# ip addr add 1.1.1.1/32 dev lo
# ip link set lo up

# configure terminal

# ! OSPF underlay
# ! Provides IP reachability between the RR and all VTEPs.
# router ospf

#   ! Link to VTEP 1
#   network 10.1.1.0/30 area 0

#   ! Link to VTEP 2
#   network 10.1.1.4/30 area 0

#   ! Link to VTEP 3
#   network 10.1.1.8/30 area 0

#   ! Loopback used as the stable identity of the RR
#   network 1.1.1.1/32 area 0


# ! BGP EVPN control plane
# ! The RR receives EVPN routes from the VTEPs
# ! and reflects them to the other VTEPs.
# router bgp 1

#   ! Unique identifier of the Route Reflector
#   bgp router-id 1.1.1.1


#   ! iBGP session with VTEP 1
#   neighbor 1.1.1.2 remote-as 1
#   neighbor 1.1.1.2 update-source lo

#   ! iBGP session with VTEP 2
#   neighbor 1.1.1.3 remote-as 1
#   neighbor 1.1.1.3 update-source lo

#   ! iBGP session with VTEP 3
#   neighbor 1.1.1.4 remote-as 1
#   neighbor 1.1.1.4 update-source lo


#   ! Enable the EVPN address family
#   address-family l2vpn evpn

#     ! Activate EVPN for VTEP 1
#     neighbor 1.1.1.2 activate

#     ! Allow the RR to reflect EVPN routes from VTEP 1
#     neighbor 1.1.1.2 route-reflector-client


#     ! Activate EVPN for VTEP 2
#     neighbor 1.1.1.3 activate

#     ! Allow the RR to reflect EVPN routes from VTEP 2
#     neighbor 1.1.1.3 route-reflector-client


#     ! Activate EVPN for VTEP 3
#     neighbor 1.1.1.4 activate

#     ! Allow the RR to reflect EVPN routes from VTEP 3
#     neighbor 1.1.1.4 route-reflector-client

#   exit-address-family

# end

# ! Save the configuration
# write memory


/bin/sh -c "/usr/lib/frr/docker-start & sleep 5 && ip addr add 10.1.1.1/30 dev eth0 && ip addr add 10.1.1.5/30 dev eth1 && ip addr add 10.1.1.9/30 dev eth2 && ip addr add 1.1.1.1/32 dev lo && ip link set eth0 up && ip link set eth1 up && ip link set eth2 up && vtysh -c 'configure terminal' -c 'router ospf' -c 'network 10.1.1.0/30 area 0' -c 'network 10.1.1.4/30 area 0' -c 'network 10.1.1.8/30 area 0' -c 'network 1.1.1.1/32 area 0' -c 'router bgp 1' -c 'bgp router-id 1.1.1.1' -c 'neighbor 1.1.1.2 remote-as 1' -c 'neighbor 1.1.1.2 update-source lo' -c 'neighbor 1.1.1.3 remote-as 1' -c 'neighbor 1.1.1.3 update-source lo' -c 'neighbor 1.1.1.4 remote-as 1' -c 'neighbor 1.1.1.4 update-source lo' -c 'address-family l2vpn evpn' -c 'neighbor 1.1.1.2 activate' -c 'neighbor 1.1.1.2 route-reflector-client' -c 'neighbor 1.1.1.3 activate' -c 'neighbor 1.1.1.3 route-reflector-client' -c 'neighbor 1.1.1.4 activate' -c 'neighbor 1.1.1.4 route-reflector-client' -c 'exit-address-family' -c 'end' -c 'write memory' && while true; do sleep 1000; done"