#!/bin/bash

echo "{"
echo "  \"data\":"
echo "    ["
df | grep '^/dev' | sed 's/^.*%[ \t]*//g' | while read line; do
echo "      {\"{#LOCALFS}\":\"$line\"},"
done | sed '$s/,$//g'
echo "    ]"
echo "}"
