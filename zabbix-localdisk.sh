#!/bin/bash

echo "{"
echo "  \"data\":"
echo "    ["
df | awk '{ print $1 }' | grep '^/dev/' | grep -v 'mapper' | sed 's/^\/dev\///g;s/[0-9]*$//g' | while read line; do
echo "      {\"{#LOCALDISK}\":\"$line\"},"
done | sed '/,$/{;N;s/,$//}'
echo "    ]"
echo "}"
