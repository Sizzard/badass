# #!/bin/sh

# # === Interfaces de transport (underlay) ===
# # Adresses IP utilisées pour joindre les différents VTEP
# ip addr add 10.1.1.1/30 dev eth0
# ip addr add 10.1.1.5/30 dev eth1
# ip addr add 10.1.1.9/30 dev eth2

# ip link set eth0 up
# ip link set eth1 up
# ip link set eth2 up

# # === Adresse loopback du routeur ===
# # Cette adresse identifie de manière unique le routeur dans le réseau
# ip addr add 1.1.1.1/32 dev lo
# ip link set lo up


# configure terminal

# # OSPF pour que tout le monde se connaisse
# router ospf
#   network 10.1.1.0/30 area 0
#   network 10.1.1.4/30 area 0
#   network 10.1.1.8/30 area 0
#   network 1.1.1.1/32 area 0

# # BGP avec EVPN
# router bgp 1
#   bgp router-id 1.1.1.1
#   neighbor 1.1.1.2 remote-as 1
#   neighbor 1.1.1.2 update-source lo
#   neighbor 1.1.1.3 remote-as 1
#   neighbor 1.1.1.3 update-source lo
#   neighbor 1.1.1.4 remote-as 1
#   neighbor 1.1.1.4 update-source lo

#   address-family l2vpn evpn
#     neighbor 1.1.1.2 activate
#     neighbor 1.1.1.2 route-reflector-client
#     neighbor 1.1.1.3 activate
#     neighbor 1.1.1.3 route-reflector-client
#     neighbor 1.1.1.4 activate
#     neighbor 1.1.1.4 route-reflector-client
#   exit-address-family

# end
# write memory

/bin/sh -c "/usr/lib/frr/docker-start & sleep 5 && ip addr add 10.1.1.1/30 dev eth0 && ip addr add 10.1.1.5/30 dev eth1 && ip addr add 10.1.1.9/30 dev eth2 && ip addr add 1.1.1.1/32 dev lo && ip link set eth0 up && ip link set eth1 up && ip link set eth2 up && vtysh -c 'configure terminal' -c 'router ospf' -c 'network 10.1.1.0/30 area 0' -c 'network 10.1.1.4/30 area 0' -c 'network 10.1.1.8/30 area 0' -c 'network 1.1.1.1/32 area 0' -c 'router bgp 1' -c 'bgp router-id 1.1.1.1' -c 'neighbor 1.1.1.2 remote-as 1' -c 'neighbor 1.1.1.2 update-source lo' -c 'neighbor 1.1.1.3 remote-as 1' -c 'neighbor 1.1.1.3 update-source lo' -c 'neighbor 1.1.1.4 remote-as 1' -c 'neighbor 1.1.1.4 update-source lo' -c 'address-family l2vpn evpn' -c 'neighbor 1.1.1.2 activate' -c 'neighbor 1.1.1.2 route-reflector-client' -c 'neighbor 1.1.1.3 activate' -c 'neighbor 1.1.1.3 route-reflector-client' -c 'neighbor 1.1.1.4 activate' -c 'neighbor 1.1.1.4 route-reflector-client' -c 'exit-address-family' -c 'end' -c 'write memory' && while true; do sleep 1000; done"