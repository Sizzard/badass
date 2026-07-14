# Sur routeur-1
ping 10.1.1.2      # ping routeur-2 (transport)
ping 30.1.1.2      # ping bridge routeur-2 (vxlan)

# Sur host-1
ping 30.1.1.1      # ping bridge routeur-1
ping 30.1.1.20     # ping host-2