#!/bin/bash

#AutoScript by Gugun
# ==========================================
# Getting
# uuid=$(cat /proc/sys/kernel/random/uuid)
sed -i '/#trojantcp$/a\#tcp '"$1 $2"'\
},{"password": "'""$3""'","flow": "xtls-rprx-direct","level": '"0"',"email": "'""$1@gmail.com""'"' /usr/local/etc/xray/config.json /usr/local/etc/xray/none.json
sed -i '/#trojanws$/a\#ws '"$1 $2"'\
},{"password": "'""$3""'","email": "'""$1@gmail.com""'"' /usr/local/etc/xray/config.json /usr/local/etc/xray/none.json
sed -i '/#trojangrpc$/a\#grpc '"$1 $2"'\
},{"password": "'""$3""'","email": "'""$1@gmail.com""'"' /usr/local/etc/xray/config.json /usr/local/etc/xray/none.json
echo -e "${1}\t${3}\t${2}" >> /usr/local/etc/xray/akun.conf
systemctl restart xray.service
systemctl restart xray@none.service
service cron restart
