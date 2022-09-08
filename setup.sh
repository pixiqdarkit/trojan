#!/bin/bash

#AutoScript by Gugun

if [ "${EUID}" -ne 0 ]; then
  echo "You need to run this script as root"
  exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
  echo "OpenVZ is not supported"
  exit 1
fi
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
rm -f /root/setup.sh
exit 0
fi
clear
if [ -f "/usr/local/etc/xray/v2ray/domain" ]; then
echo "Script Already Installed"
exit 0
fi
mkdir /var/lib/premium-script;
echo "IP=" >> /var/lib/premium-script/ipvps.conf
custom(){
wget https://raw.githubusercontent.com/pixiqdarkit/trojan/main/email-cf.sh && chmod +x email-cf.sh && sed -i -e 's/\r$//' email-cf.sh && ./email-cf.sh && rm -f /root/email-cf.sh
wget https://raw.githubusercontent.com/pixiqdarkit/trojan/main/ccf.sh && chmod +x ccf.sh && sed -i -e 's/\r$//' ccf.sh && ./ccf.sh && rm -f /root/ccf.sh
clear
echo "Mempersiapkan install custom domain..."
sleep 5
Install_sc
log_install
}

onscript(){
wget https://raw.githubusercontent.com/pixiqdarkit/trojan/main/add-host.sh && chmod +x add-host.sh && sed -i -e 's/\r$//' add-host.sh && ./add-host.sh && rm -f /root/add-host.sh
Install_sc
log_install
}
Install_sc(){
#install v2ray
wget https://raw.githubusercontent.com/pixiqdarkit/trojan/main/xray.sh && chmod +x xray.sh && screen -S v2ray ./xray.sh && rm -f /root/xray.sh
wget https://raw.githubusercontent.com/pixiqdarkit/trojan/main/set-br.sh && chmod +x set-br.sh && sed -i -e 's/\r$//' set-br.sh && ./set-br.sh && rm -f /root/set-br.sh
}
log_install(){
history -c
echo "1.2" > /home/ver
clear
echo " "
echo "Installation has been completed!!"
echo " "
echo "=================================-Autoscript Premium-===========================" | tee -a log-install.txt
echo "" | tee -a log-install.txt
echo "--------------------------------------------------------------------------------" | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Service & Port"  | tee -a log-install.txt
echo "   - XRAYS Trojan TCP        : 443"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   >>> Server Information & Other Features"  | tee -a log-install.txt
echo "   - Timezone                : Asia/Jakarta (GMT +7)"  | tee -a log-install.txt
echo "   - Fail2Ban                : [ON]"  | tee -a log-install.txt
echo "   - Dflate                  : [ON]"  | tee -a log-install.txt
echo "   - IPtables                : [ON]"  | tee -a log-install.txt
echo "   - Auto-Reboot             : [ON]"  | tee -a log-install.txt
echo "   - IPv6                    : [OFF]"  | tee -a log-install.txt
echo "   - Autoreboot On 05:00 GMT +7" | tee -a log-install.txt
echo "   - Auto Delete Expired Account" | tee -a log-install.txt
echo "   - Full Orders For Various Services" | tee -a log-install.txt
echo "   - White Label" | tee -a log-install.txt
echo "   - Installation Log --> /root/log-install.txt"  | tee -a log-install.txt
echo ""  | tee -a log-install.txt
echo "   - Telegram                : T.me/tatsumaru"  | tee -a log-install.txt
echo "   - Whatsapp                : 6281357879215"  | tee -a log-install.txt
echo "------------------Script Mod By Gugun09-----------------" | tee -a log-install.txt
echo ""
history -c
rm -f setup.sh
echo "Sistem akan reboot wait..."
sleep 15
reboot
}
clear
menu(){
clear
echo "================================"
echo "What do you want to do?"
echo -e ""
echo -e "[1] Custom your domain"
echo -e "[2] Use Default domain script"
echo "================================"
read -p "Choose an option from (1-2): " x
case $x in
	1)
	custom
	;;
	2)
	onscript
	;;
	*)
	exit 1
	;;
esac
}
menu
