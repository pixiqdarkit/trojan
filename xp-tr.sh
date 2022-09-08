#!/bin/bash

#AutoScript by Gugun
# Trojan
data=( `cat /usr/local/etc/xray/config.json | grep '^#tcp' | cut -d ' ' -f 2`);
now=`date +"%Y-%m-%d"`
for user in "${data[@]}"
do
exp=$(grep -w "^#tcp $user" "/usr/local/etc/xray/config.json" | cut -d ' ' -f 3)
d1=$(date -d "$exp" +%s)
d2=$(date -d "$now" +%s)
exp2=$(( (d1 - d2) / 86400 ))
if [[ "$exp2" = "0" ]]; then
sed -i "/^#tcp $user $exp/,/^},{/d" /usr/local/etc/xray/config.json /usr/local/etc/xray/none.json
sed -i "/^#ws $user $exp/,/^},{/d" /usr/local/etc/xray/config.json /usr/local/etc/xray/none.json
sed -i "/^#grpc $user $exp/,/^},{/d" /usr/local/etc/xray/config.json /usr/local/etc/xray/none.json
fi
done
systemctl restart xray.service
systemctl restart xray@none.service
service cron restart
