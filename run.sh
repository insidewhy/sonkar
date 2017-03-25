#!/bin/zsh

dns=8.8.8.8

# sudo iptables -P FORWARD ACCEPT
sudo rkt run --insecure-options=image --dns=$dns --net=default --interactive ./*.aci --exec=sh
