#!/bin/bash

#AutoScript by Gugun
# ==========================================
data=($(cat /usr/local/etc/xray/akun.conf | awk '{print $1}'))
	data2=($(netstat -anp | grep ESTABLISHED | grep tcp6 | grep xray | grep -w 443 | awk '{print $5}' | cut -d: -f1 | sort | uniq))
	domain=$(cat /usr/local/etc/xray/domain)
	clear
	echo -e ""
	echo -e "========================="
	echo -e "   Xray Login Monitor"
	echo -e "-------------------------"
	for user in "${data[@]}"
	do
		touch /tmp/iptrojan.txt
		for ip in "${data2[@]}"
		do
			total=$(cat /var/log/xray/access.log | grep -w ${user}@gmail.com | awk '{print $3}' | cut -d: -f1 | grep -w $ip | sort | uniq)
			if [[ "$total" == "$ip" ]]; then
				echo -e "$total" >> /tmp/iptrojan.txt
			fi
		done
		total=$(cat /tmp/iptrojan.txt)
		if [[ -n "$total" ]]; then
			total2=$(cat /tmp/iptrojan.txt | nl)
			echo -e "$user :"
			echo -e "$total2"
		fi
		rm -f /tmp/iptrojan.txt
	done
	echo -e "========================="
	echo -e ""
