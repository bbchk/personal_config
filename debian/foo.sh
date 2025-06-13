#!/usr/bin/env bash

# sudo -S true

p="paru"

sudo pacman -S "$p" > /dev/null 2>&1 &
pid=$!

./ellipsis.sh $pid $p

wait $pid
status=$?
