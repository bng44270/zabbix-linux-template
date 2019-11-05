#!/bin/bash

ZABBIXHOME="ZABBIXHOMEDIR"
ZABBIXBIN="$ZABBIXHOME/bin"
ZABBIXCONF="$ZABBIXHOME/conf"

printf "Creating monitor scripts..."

cat << HEREFILE | openssl enc -base64 -d > $ZABBIXBIN/zabbix-localdisk.sh
LOCALDISKTXT
HEREFILE

cat << HEREFILE | openssl enc -base64 -d > $ZABBIXBIN/zabbix-localfs.sh
LOCALFSTXT
HEREFILE

cat << HEREFILE | openssl enc -base64 -d > $ZABBIXBIN/zabbix-localnet.sh
LOCALNETTXT
HEREFILE

cat << HEREFILE | openssl enc -base64 -d > $ZABBIXBIN/zabbix-localnet-bps.sh
LOCALNETBPSTXT
HEREFILE

printf "done\n"

printf "Modifying zabbix_agentd.conf..."

echo "" >> $ZABBIXCONF/zabbix_agentd.conf

[[ -z "$(grep 'localdisk.discovery' $ZABBIXCONF/zabbix_agentd.conf)" ]] && echo "UserParameter=localdisk.discovery,$ZABBIXBIN/zabbix-localdisk.sh" >> $ZABBIXCONF/zabbix_agentd.conf
[[ -z "$(grep 'localfs.discovery' $ZABBIXCONF/zabbix_agentd.conf)" ]] && echo "UserParameter=localfs.discovery,$ZABBIXBIN/zabbix-localfs.sh" >> $ZABBIXCONF/zabbix_agentd.conf
[[ -z "$(grep 'localnet.discovery' $ZABBIXCONF/zabbix_agentd.conf)" ]] && echo "UserParameter=localnet.discovery,$ZABBIXBIN/zabbix-localnet.sh" >> $ZABBIXCONF/zabbix_agentd.conf

printf "done\n"
