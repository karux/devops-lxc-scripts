# for dmzmacMaster1, use bridgename lxcbr1
sudo brctl addbr $1
sudo ifconfig $1 up
sudo brctl show
