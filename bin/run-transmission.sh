#!/bin/sh

run_transmission() {
  transmission-daemon -i tun0 -r eth0 -a 172.16.28.1,127.0.0.1 -w /var/torrents -g /var/torrents/.transmission
}

run_tranmission_and_make_sure_it_doesnt_hang() {
  while true ; do
    run_transmission
    sleep 10
    check_transmission_is_running && break
    echo transmission is stuck trying again
    killall transmission-daemon
    sleep 10
  done
}

check_transmission_is_running() {
  timeout -t 10 transmission-remote -l
}

if [ x$1 = xup ] ; then
  # it hangs a lot on startup
  run_tranmission_and_make_sure_it_doesnt_hang
  echo started transmission

  # it hangs a lot so keep it up
  while true ; do
    sleep 10
    if ! check_transmission_is_running ; then
      killall transmission-daemon
      sleep 3
      run_tranmission_and_make_sure_it_doesnt_hang
    fi
  done
else
  killall transmission-daemon
fi
