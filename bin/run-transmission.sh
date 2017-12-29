#!/bin/sh

check_interval=10
wait_for_death=3

run_transmission() {
  transmission-daemon -i tun0 -r eth0 -a 172.16.28.1,127.0.0.1 -w /var/torrents -g /var/torrents/.transmission
}

run_tranmission_and_make_sure_it_doesnt_hang() {
  while true ; do
    run_transmission
    sleep $check_interval
    check_transmission_is_running && break
    echo transmission is stuck trying again
    killall transmission-daemon
    sleep $check_interval
  done
}

check_transmission_is_running() {
  timeout -t $check_interval transmission-remote -l
}

if [ x$1 = xup ] ; then
  # it hangs a lot on startup
  run_tranmission_and_make_sure_it_doesnt_hang
  echo started transmission

  # it hangs a lot so keep it up
  while true ; do
    sleep $check_interval
    if ! check_transmission_is_running ; then
      killall transmission-daemon
      sleep $wait_for_death
      run_tranmission_and_make_sure_it_doesnt_hang
    fi
  done
else
  killall transmission-daemon
fi
