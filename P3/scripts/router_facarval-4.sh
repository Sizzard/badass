# #!/bin/sh

# # === Interface de transport (underlay) ===
# # Adresse IP utilisée pour joindre les autres VTEP
# ip addr add 10.1.1.10/30 dev eth2
# ip link set eth2 up

# # === Adresse loopback du VTEP ===
# # Cette adresse identifie de manière unique le VTEP
# ip addr add 1.1.1.4/32 dev lo
# ip link set lo up

# # === Création de l'interface VXLAN (VNI = 10) ===
# # Utilisation de l'adresse loopback comme IP source des paquets VXLAN
# ip link add vxlan10 type vxlan \
#     id 10 \
#     dstport 4789 \
#     local 1.1.1.4 \

# ip link set vxlan10 up

# # === Création du bridge ===
# # Ce bridge relie l'interface VXLAN au réseau local
# ip link add br0 type bridge
# ip link set br0 up

# # === Association des interfaces au bridge ===
# # - vxlan10 : trafic encapsulé VXLAN
# # - eth1    : interface connectée au réseau local
# ip link set vxlan10 master br0
# ip link set eth0 master br0


# configure terminal

# router ospf
#   network 10.1.1.8/30 area 0
#   network 1.1.1.4/32 area 0

# router bgp 1
#   bgp router-id 1.1.1.4
#   neighbor 1.1.1.1 remote-as 1
#   neighbor 1.1.1.1 update-source lo

#   address-family l2vpn evpn
#     neighbor 1.1.1.1 activate
#     advertise-all-vni
#   exit-address-family

# end
# write memory


/bin/sh -c "/usr/lib/frr/docker-start & sleep 5 && ip addr add 10.1.1.10/30 dev eth2 && ip addr add 1.1.1.4/32 dev lo && ip link set eth2 up && ip link add vxlan10 type vxlan id 10 dstport 4789 local 1.1.1.4 && ip link set vxlan10 up && ip link add br0 type bridge && ip link set br0 up && ip link set vxlan10 master br0 && ip link set eth0 master br0 && vtysh -c 'configure terminal' -c 'router ospf' -c 'network 10.1.1.8/30 area 0' -c 'network 1.1.1.4/32 area 0' -c 'router bgp 1' -c 'bgp router-id 1.1.1.4' -c 'neighbor 1.1.1.1 remote-as 1' -c 'neighbor 1.1.1.1 update-source lo' -c 'address-family l2vpn evpn' -c 'neighbor 1.1.1.1 activate' -c 'advertise-all-vni' -c 'exit-address-family' -c 'end' -c 'write memory' && while true; do sleep 1000; done"