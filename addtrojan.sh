#!/bin/bash

#AutoScript by Gugun
# ==========================================
# Color
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHT='\033[0;37m'
# ==========================================
# Getting
MYIP=$(wget -qO- ipinfo.io/ip);
domain=$(cat /usr/local/etc/xray/domain)
tr="$(cat ~/log-install.txt | grep -w "Trojan TCP" | cut -d: -f2|sed 's/ //g')"
until [[ $user =~ ^[a-zA-Z0-9_]+$ && ${user_EXISTS} == '0' ]]; do
		read -rp "Password : " -e user
		user_EXISTS=$(grep -w $user /usr/local/etc/xray/config.json | wc -l)

		if [[ ${user_EXISTS} == '1' ]]; then
			echo ""
			echo -e "Username ${RED}${user}${NC} Already On VPS Please Choose Another"
			exit 1
		fi
	done
uuid=$(cat /proc/sys/kernel/random/uuid)
read -p "Expired (Days) : " masaaktif
exp=`date -d "$masaaktif days" +"%Y-%m-%d"`
sed -i '/#trojantcp$/a\#tcp '"$user $exp"'\
},{"password": "'""$uuid""'","flow": "xtls-rprx-direct","level": '"0"',"email": "'""$user@gmail.com""'"' /usr/local/etc/xray/config.json /usr/local/etc/xray/none.json
sed -i '/#trojanws$/a\#ws '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user@gmail.com""'"' /usr/local/etc/xray/config.json /usr/local/etc/xray/none.json
sed -i '/#trojangrpc$/a\#grpc '"$user $exp"'\
},{"password": "'""$uuid""'","email": "'""$user@gmail.com""'"' /usr/local/etc/xray/config.json /usr/local/etc/xray/none.json
echo -e "${user}\t${uuid}\t${exp}" >> /usr/local/etc/xray/akun.conf
systemctl restart xray.service
systemctl restart xray@none.service
trojanlink="trojan://${uuid}@${domain}:${tr}#Trojan+TCP+TLS+${user}"
trojanxtls="trojan://${uuid}@${domain}:${tr}/?security=xtls&flow=xtls-rprx-direct#Trojan+TCP+XTLS+${user}"
trojanwslink="trojan://${uuid}@${domain}:${tr}?path=%2Ftrojan-ws&security=tls&host=${domain}&type=ws&sni=${domain}#Trojan+WS+TLS+${user}"
trojangrpclink="trojan://${uuid}@${domain}:${tr}?mode=gun&security=tls&type=grpc&serviceName=tdngrpc443&sni=${domain}#Trojan+gRPC+TLS+${user}"
service cron restart
echo -e "======-XRAYS/TROJAN-======"
echo -e "======-SUPPORT CDN-======"
echo -e "Remarks  : ${user}"
echo -e "IP/Host  : ${MYIP}"
echo -e "Address  : ${domain}"
echo -e "Port     : ${tr}"
echo -e "Port     : 80"
echo -e "Key      : ${uuid}"
echo -e "Expired  : $exp"
echo -e "=========================="
echo -e "Link TR TLS    : ${trojanlink}"
echo -e "=========================="
echo -e "Link TR XTLS   : ${trojanxtls}"
echo -e "=========================="
echo -e "Link TR WS     : ${trojanwslink}"
echo -e "=========================="
echo -e "Link TR gRPC   : ${trojangrpclink}"
echo -e "=========================="
