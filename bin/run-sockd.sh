#!/bin/sh

# when the vpn is down tun0 won't exist and the server won't run
while ! sockd ; do sleep 1 ; done
