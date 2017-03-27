#!/bin/zsh
#
die() {
  echo $*
  exit 1
}

setopt nullglob
aci=$(echo *.aci)
[[ -f "$aci" ]] || die "run ./build.zsh first"

prefix=/usr
cp $aci $prefix/share
cp sonkar $prefix/bin
