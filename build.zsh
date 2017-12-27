#!/bin/zsh

name=sonkar
version=0.0.1
dest_aci=$name-$version.aci

mkdir -p .resources

# ensure the build gets finished no matter what
finish() {
  sudo acbuild end
}
trap finish EXIT TERM

copy_bin_from_net() {
  fname=$(basename $2)
  wget -c $1 -O .resources/$fname
  chmod a+x .resources/$fname
  sudo acbuild copy .resources/$fname $2
}

acbuild begin docker://alpine
# acbuild begin
# acbuild dependency add quay.io/chilon/alpine-3.5
# # acbuild dependency add quay.io/aptible/busybox

acbuild set-name $name
acbuild port add proxy tcp 1080
acbuild port add transmission tcp 9091
copy_bin_from_net https://github.com/ohjames/smell-baron/releases/download/v0.4.2/smell-baron.musl /bin/smell-baron

sudo acbuild run mkdir /var/torrents
sudo acbuild run apk update
sudo acbuild run apk add openvpn dnsmasq transmission-daemon transmission-cli
sudo acbuild run apk add -- dante-server \
  --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted
sudo acbuild copy cfg/sockd.conf /etc/sockd.conf
sudo acbuild copy bin/run-sockd.sh /bin/run-sockd.sh
sudo acbuild copy bin/run-dnsmasq.sh /bin/run-dnsmasq.sh
sudo acbuild copy bin/run-transmission.sh /bin/run-transmission.sh

sudo acbuild set-exec -- smell-baron \
  -c run-dnsmasq.sh --- \
  openvpn --config /var/vpn-config/cfg.ovpn --script-security 2 --ping 5 --ping-restart 10 --up-restart --up '/bin/run-dnsmasq.sh up' --down /bin/run-dnsmasq.sh --- \
  run-sockd.sh --- \
  run-transmission.sh up

sudo acbuild write --overwrite $dest_aci
