#!/bin/bash
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
MYIP=$(wget -qO- icanhazip.com);
echo "This Feature Can Only Be Used According To Vps Data With This Autoscript"
echo "Please input link to your vps data backup file."
echo "You can check it on your email if you run backup data vps before."
read -rp "Link File: " -e url
wget -O backup.zip "$url"
unzip backup.zip
rm -f backup.zip
sleep 1
echo Start Restore
cd /root/backup
cp -r xray /usr/local/etc/
rm -rf /root/backup
rm -f backup.zip
echo Done

