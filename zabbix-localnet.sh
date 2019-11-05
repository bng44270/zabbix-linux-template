#!/bin/bash

echo "{"
echo "  \"data\":"
echo "    ["
ifconfig | egrep -v '^[ \t]|^$' | awk '{ print $1 }' | sed 's/://g' | while read line; do
echo "      {\"{#LOCALIF}\":\"$line\"},"
done | sed '$s/,$//g'
echo "    ]"
echo "}"
