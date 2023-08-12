#!/bin/bash
# duckdns-ipv6.sh
# Example
# ~/duckdns/duckdns-ipv6.sh mydomain.duckdns.org 00000000-0000-0000-0000-000000000000 eth0 ~/duckdns/duckdns.log
#
# Only IPv6 at the moment

domain=$1
token=$2
interface=$3
logfile=$4

service=duckdns.org

currentdate=$(date -Is)
if [ -z "${logfile}" ]; then
        echo "empty log file name"
        exit 1
fi


if [[ "${domain}" != *"${service}"* ]]; then
        echo -e "${currentdate} Expected format : mydomain.${service}" >>${logfile}
        exit 1
fi

if [[ "${token}" != *"-"* ]]; then
        echo -e "${currentdate} Expected format : 00000000-0000-0000-0000-000000000000" >>${logfile}
        exit 1
fi

testinterface=$(ip -o link show | awk '{print $2,$9}' | grep ${interface})

if [ -z "${testinterface}" ]; then
        echo -e "${currentdate} interface not found ${interface}" >>${logfile}
        exit 1
fi


ipv6addr=$(ip addr show dev ${interface} | grep global | sed -e's/^.*inet6 \([^ ]*\)\/.*$/\1/;t;d')

if [ -z "${ipv6addr}" ]; then
        echo -e "${currentdate} empty IPv6 address for ${interface}" >>${logfile}
        exit 1
fi

apiurl="https://www.duckdns.org/update?domains=${domain}&token=${token}&ipv6=${ipv6addr}"
curlresult=$(curl -s ${apiurl})
echo -e "${currentdate} ${apiurl} ${curlresult}"  >>${logfile}