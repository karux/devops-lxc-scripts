# script to setup a natted network for lxc guests
CMD_BRCTL=/sbin/brctl
CMD_IFCONFIG=/sbin/ifconfig
CMD_IPTABLES=/sbin/iptables
CMD_ROUTE=/sbin/route
# custom  bridge name for nat network
NETWORK_BRIDGE_DEVICE_NAT=Inetbr1
NETWORK_BRIDGE_VLAN=Inetbr0
# link to existing static bridge
# ? could we instead link directly to interface?
HOST_NETDEVICE=Inetbr0
# set private gateway address for nat bridge
PRIVATE_GW_NAT=10.0.60.1
PRIVATE_GW_VLAN=24.73.153.73
PRIVATE_VLAN_IP=24.73.153.74

PRIVATE_NETMASK=255.255.255.248

PHYS_IFACE=p1p1
# ? using static addressing instead of dchp?

sudo echo 'configuring Inetbr0'
sudo ${CMD_BRCTL} addbr ${NETWORK_BRIDGE_VLAN}
sudo ${CMD_BRCTL} setfd ${NETWORK_BRIDGE_VLAN} 0
sudo ${CMD_IFCONFIG} ${NETWORK_BRIDGE_VLAN} ${PRIVATE_VLAN_IP} netmask ${PRIVATE_NETMASK} promisc up
sudo ${CMD_BRCTL} addif ${NETWORK_BRIDGE_VLAN} ${PHYS_IFACE}
sudo ${CMD_IFCONFIG} ${PHYS_IFACE} 0.0.0.0 up
sudo ${CMD_ROUTE} add default gw ${PRIVATE_GW_VLAN} ${NETWORK_BRIDGE_VLAN}
sudo echo 'configuring Inetbr1'
sudo ${CMD_BRCTL} addbr ${NETWORK_BRIDGE_DEVICE_NAT}
sudo ${CMD_BRCTL} setfd ${NETWORK_BRIDGE_DEVICE_NAT} 0
sudo ${CMD_IFCONFIG} ${NETWORK_BRIDGE_DEVICE_NAT} ${PRIVATE_GW_NAT} netmask ${PRIVATE_NETMASK} promisc up
sudo ${CMD_IPTABLES} -t nat -A POSTROUTING -o ${HOST_NETDEVICE} -j MASQUERADE
sudo echo 1 > /proc/sys/net/ipv4/ip_forward

