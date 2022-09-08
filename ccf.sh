#!/bin/bash

#AutoScript by Gugun

red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- icanhazip.com);
IZIN=$( wget -qO- icanhazip.com | grep $MYIP )
if [ $MYIP = $IZIN ]; then
echo -e "${green}PermissionAccepted...${NC}"
else
echo -e "${red}Permission Denied!${NC}"
echo -e "Please Contact Admin"
echo -e "+6281357879215"
rm -f setup.sh
exit 0
fi
clear
source /home/email_cf.conf
read -rp "Generate Your Wilcard Cloudflare :" -e sub
SUB_DOMAIN=${sub}.$DOMAIN
set -euo pipefail
IP=$(wget -qO- icanhazip.com);
echo "Updating DNS for ${SUB_DOMAIN}..."
ZONE=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones?name=${DOMAIN}&status=active" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

RECORD=$(curl -sLX GET "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records?name=${SUB_DOMAIN}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" | jq -r .result[0].id)

if [[ "${#RECORD}" -le 10 ]]; then
     RECORD=$(curl -sLX POST "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}' | jq -r .result.id)
fi

RESULT=$(curl -sLX PUT "https://api.cloudflare.com/client/v4/zones/${ZONE}/dns_records/${RECORD}" \
     -H "X-Auth-Email: ${CF_ID}" \
     -H "X-Auth-Key: ${CF_KEY}" \
     -H "Content-Type: application/json" \
     --data '{"type":"A","name":"'${SUB_DOMAIN}'","content":"'${IP}'","ttl":120,"proxied":false}')
echo "Host Wilcard : [sub].$SUB_DOMAIN"
sleep 3
echo $SUB_DOMAIN > /root/domain