#!/bin/bash
# ipv64dns-ipv6.sh
# Example
# ~/ipv64dns/ipv64dns-ipv6.sh mydomain.ipv64.net 0000000000
#
# Only IPv6 at the moment

basedir=$(dirname $0)

domain=$1
token=$2
logfile=${basedir}/ipv64dns.log

service=.ipv64.net
mintokenlength=10
expectedformat=0000000000

currentdate=$(date -Is)
lastipv6file=${basedir}/lastipv6.txt


if [ -z "${logfile}" ]; then
        echo "empty log file name"
        exit 1
fi

# check TLD  
if [[ "${domain}" != *"${service}"* ]]; then
        echo -e "${currentdate} Expected format : mydomain${service}" >>${logfile}
        exit 1
fi

# min length
if [ ${#token} -lt ${mintokenlength} ]; then
        echo -e "${currentdate} Expected format : ${expectedformat}" >>${logfile}
        exit 1
fi

# get ip
ipv6addr=$(curl -6 -s "https://api6.ipify.org")

if [ -z "${ipv6addr}" ]; then
        echo -e "${currentdate} empty IPv6 address" >>${logfile}
        exit 1
fi

apiurl="https://ipv64.net/update.php?key=${token}&domain=${domain}&ipv6=${ipv6addr}"

if [ ! -f "$lastipv6file" ]; then
        # update and store the last known IPv6 address
        curlresult=$(curl -s ${apiurl})
        echo -e "${currentdate} set  ${apiurl} ${curlresult}"  >>${logfile}
        echo ${ipv6addr} >${lastipv6file}
        exit 0
fi

lastipv6value=$(<${lastipv6file})

if [[ "${lastipv6value}" == "${ipv6addr}" ]]; then
        # IPv6 unchanged : don't call the api   
        echo -e "${currentdate} $ipv6addr unchanged." >>${logfile}
else
        # IPv6 has changed
        curlresult=$(curl -s ${apiurl})
        echo -e "${currentdate} update ${apiurl} ${curlresult}"  >>${logfile}
        echo ${ipv6addr} >${lastipv6file}
fi

exit 0
