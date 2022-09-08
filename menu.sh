# Getting

#AutoScript by Gugun

clear
dateFromServer=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
biji=`date +"%Y-%m-%d" -d "$dateFromServer"`
#########################

MYIP=$(curl -sS ipinfo.io/ip)
#toilet --gay -f slant -t " Geo Project"
#cat /usr/bin/bannerku | lolcat
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
IPVPS=$(curl -s ipinfo.io/ip )
DOMAIN=$(cat /usr/local/etc/xray/domain)
ISP=$(curl -s ipinfo.io/org | cut -d " " -f 2-10 )
CITY=$(curl -s ipinfo.io/city )
WKT=$(curl -s ipinfo.io/timezone )
IPVPS=$(curl -s ipinfo.io/ip )
jam=$(date +"%T")
hari=$(date +"%A")
tnggl=$(date +"%d-%B-%Y")
	cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo )
	cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
	freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo )
	tram=$( free -m | awk 'NR==2 {print $2}' )
	swap=$( free -m | awk 'NR==4 {print $2}' )
	up=$(uptime|awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }')
 echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
 echo -e "\E[44;1;39m                     ⇱ INFORMASI VPS ⇲                        \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e " ${color1} •${color3}$bd ISP Name          ${color1} :${color3}$bd $ISP"
 echo -e " ${color1} •${color3}$bd City              ${color1} :${color3}$bd $CITY"
 echo -e " ${color1} •${color3}$bd CPU Model         ${color1} :${color3}$bd$cname"
 echo -e " ${color1} •${color3}$bd Number Of Cores   ${color1} :${color3}$bd $cores"
 echo -e " ${color1} •${color3}$bd CPU Frequency     ${color1} :${color3}$bd$freq MHz"
 echo -e " ${color1} •${color3}$bd Total RAM         ${color1} :${color3}$bd $tram MB"
 echo -e " ${color1} •${color3}$bd Waktu             ${color1} :${color3}$bd $jam"
 echo -e " ${color1} •${color3}$bd Hari              ${color1} :${color3}$bd $hari"
 echo -e " ${color1} •${color3}$bd Tanggal           ${color1} :${color3}$bd $tnggl"
 echo -e " ${color1} •${color3}$bd IP VPS            ${color1} :${color3}$bd $IPVPS"
 echo -e " ${color1} •${color3}$bd Domain            ${color1} :${color3}$bd $DOMAIN"
 echo -e " ${color1} •${color3}$bd Version           ${color1} :${color3}$bd Latest Version"
 echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
 echo -e "\E[44;1;39m                     ⇱ MENU  OPTIONS ⇲                        \E[0m"
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo -e "
[\033[0;32m01\033[0m] • XRay Trojan Menu
[\033[0;32m02\033[0m] • Add Or Change Subdomain Host For VPS
[00] • Back to exit Menu \033[1;32m<\033[1;33m<\033[1;31m<\033[1;31m"
echo ""
echo -e "\033[0;34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[0m"
echo ""
echo -ne "Select menu : "; read x

case "$x" in 
   1 | 01)
   clear
   menu-trojan
   ;;
   2 | 02)
   clear
   add-host
   ;;
   0 | 00)
   clear
   exit
   ;;
   *)
   menu
esac

#fim