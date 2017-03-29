#!/bin/sh

interface=eth0

[ x$1 = xup ] && interface=tun0

killall dnsmasq
dnsmasq -R -S 8.8.4.4@$interface
