# sudo lxc-create -n $1 -t ubuntu-cloud -- -r raring -T http://cloud-images.ubuntu.com/saucy/current/saucy-server-cloudimg-amd64-root.tar.gz
sudo lxc-create -n $1 -t ubuntu-cloud -- -r saucy

