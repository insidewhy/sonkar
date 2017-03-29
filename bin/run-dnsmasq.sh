#!/bin/sh

interface=eth0

if [ x$1 = xup ] ; then
  interface=tun0
  # dnsmasq -h/-H options are broken under alpine so...
  echo "# aliases below" >> /etc/hosts
  cat /var/vpn-config/hosts >> /etc/hosts
else
  sed -e '/^# aliases below/ { N; d; }' -i /etc/hosts
fi

killall dnsmasq
dnsmasq -q -R -S 8.8.4.4@$interface
