#!/bin/zsh

name=sonkar
version=0.0.1
dest_aci=$name-$version.aci

# ensure the build gets finished no matter what
finish() {
  acbuild end
}
trap finish EXIT

acbuild begin
acbuild dependency add quay.io/coreos/alpine-sh
acbuild set-name $name

rm $dest_aci
acbuild write $dest_aci
