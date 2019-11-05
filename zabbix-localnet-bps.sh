#!/bin/bash

s1=$(ifconfig $1 | grep 'RX.*bytes' | sed 's/^.*bytes[ \t]* //g;s/[ \t].*$//g')
sleep 1
s2=$(ifconfig $1 | grep 'RX.*bytes' | sed 's/^.*bytes[ \t]* //g;s/[ \t].*$//g')
echo $s2-$s1 | bc
