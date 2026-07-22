# #!/bin/sh

# #  Interface de transport (underlay) 
# # Adresse IP utilisée pour joindre les autres VTEP
# ip addr add 10.1.1.6/30 dev eth1
# ip link set eth1 up

# #  Adresse loopback du VTEP 
# # Cette adresse identifie de manière unique le VTEP
# ip addr add 1.1.1.3/32 dev lo
# ip link set lo up

# #  Création de l'interface VXLAN (VNI = 10) 
# # Utilisation de l'adresse loopback comme IP source des paquets VXLAN
# ip link add vxlan10 type vxlan \
#     id 10 \
#     dstport 4789 \
#     local 1.1.1.3 \

# ip link set vxlan10 up

# #  Création du bridge 
# # Ce bridge relie l'interface VXLAN au réseau local
# ip link add br0 type bridge
# ip link set br0 up

# #  Association des interfaces au bridge 
# # - vxlan10 : trafic encapsulé VXLAN
# # - eth0    : interface connectée au réseau local
# ip link set vxlan10 master br0
# ip link set eth0 master br0

# configure terminal

# ! OSPF underlay
# ! Provides IP reachability to the other routers and their loopbacks.
# router ospf

#   ! Underlay link connected to the Route Reflector
#   network 10.1.1.4/30 area 0

#   ! Loopback used as the stable identity of this VTEP
#   network 1.1.1.3/32 area 0


# ! BGP EVPN control plane
# ! All routers belong to AS 1.
# router bgp 1

#   ! Unique identifier of this router
#   bgp router-id 1.1.1.3

#   ! iBGP session with the Route Reflector
#   neighbor 1.1.1.1 remote-as 1

#   ! Use the loopback as the source of the BGP session
#   neighbor 1.1.1.1 update-source lo


#   ! Enable the EVPN address family
#   address-family l2vpn evpn

#     ! Activate EVPN exchange with the Route Reflector
#     neighbor 1.1.1.1 activate

#     ! Advertise the locally configured VXLAN VNIs
#     advertise-all-vni

#   exit-address-family

# end

# ! Save the configuration
# write memory



/bin/sh -c "/usr/lib/frr/docker-start & sleep 5 && ip addr add 10.1.1.6/30 dev eth1 && ip addr add 1.1.1.3/32 dev lo && ip link set eth1 up && ip link add vxlan10 type vxlan id 10 dstport 4789 local 1.1.1.3 && ip link set vxlan10 up && ip link add br0 type bridge && ip link set br0 up && ip link set vxlan10 master br0 && ip link set eth0 master br0 && vtysh -c 'configure terminal' -c 'router ospf' -c 'network 10.1.1.4/30 area 0' -c 'network 1.1.1.3/32 area 0' -c 'router bgp 1' -c 'bgp router-id 1.1.1.3' -c 'neighbor 1.1.1.1 remote-as 1' -c 'neighbor 1.1.1.1 update-source lo' -c 'address-family l2vpn evpn' -c 'neighbor 1.1.1.1 activate' -c 'advertise-all-vni' -c 'exit-address-family' -c 'end' -c 'write memory' && while true; do sleep 1000; done"