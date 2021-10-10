#!/bin/sh
set -e

# Code generated by tunneler.io DO NOT EDIT.
# pushd /tmp/

curl -s https://api.github.com/repos/tunnelerio/binaries/releases/latest \
| grep "browser_download_url.*tunneler-client[^extended].*_Linux_x86_64\.tar\.gz" \
| cut -d ":" -f 2,3 \
| tr -d \" \
| wget -qi -

tarball="$(find . -name "*Linux_x86_64.tar.gz")"
tar -xzf $tarball

chmod +x tunneler-client

mv hugo /usr/local/bin/

popd

location="$(which tunneler-client)"
echo "tunneler-client binary location: $location"

# version="$(tunneler-client version)"
# echo "tunneler-client binary version: $version"

echo "install openvpn"
apt-get install openvpn

echo "setting up iptables"
iptables -I INPUT -p udp --dport 1194 -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.8.0.0/24 -o eth0 -j MASQUERADE
sysctl -w net.ipv4.ip_forward=1