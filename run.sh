#!/bin/zsh

sudo rkt run --insecure-options=image --interactive ./*.aci --exec=sh
