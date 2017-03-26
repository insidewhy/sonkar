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

acbuild begin
acbuild dependency add quay.io/chilon/alpine-3.5
# acbuild dependency add quay.io/aptible/busybox
acbuild set-name $name
copy_bin_from_net https://github.com/ohjames/smell-baron/releases/download/v0.4.2/smell-baron.musl /bin/smell-baron

sudo acbuild run apk update
sudo acbuild run apk add openvpn bind
sudo acbuild run mv /etc/bind/named.conf{.recursive,}
sudo acbuild run apk add -- dante-server \
  --update-cache --repository http://dl-3.alpinelinux.org/alpine/edge/testing/ --allow-untrusted
sudo acbuild copy cfg/sockd.conf /etc/sockd.conf
sudo acbuild copy bin/run-sockd.sh /bin/run-sockd.sh

sudo acbuild set-exec -- smell-baron openvpn /var/vpn-config/cfg.ovpn --- run-sockd.sh --- named -f

sudo acbuild write --overwrite $dest_aci
