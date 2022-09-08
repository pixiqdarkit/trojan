#!/bin/bash

#AutoScript by Gugun

clear
# echo -e "Masukkan sub-domain contoh: id01.wdssh.me"
# read -p "Sub-Domain Kamu " dom
# echo $dom > /root/domain
domain=$(cat /root/domain)
apt install iptables iptables-persistent -y
apt install curl socat xz-utils wget apt-transport-https gnupg gnupg2 gnupg1 dnsutils lsb-release -y 
apt install socat cron bash-completion ntpdate -y
ntpdate pool.ntp.org
apt -y install chrony
timedatectl set-ntp true
systemctl enable chronyd && systemctl restart chronyd
systemctl enable chrony && systemctl restart chrony
timedatectl set-timezone Asia/Jakarta
chronyc sourcestats -v
chronyc tracking -v
date

source /etc/os-release
OS=$ID
ver=$VERSION_ID

# Disable IPv6
sysctl -w net.ipv6.conf.all.disable_ipv6=1
sysctl -w net.ipv6.conf.default.disable_ipv6=1
sysctl -w net.ipv6.conf.lo.disable_ipv6=1
echo -e "net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf

#buat folder xray
mkdir -p /etc/xray
# Install Cert
apt install -y socat
cd /root/
wget https://raw.githubusercontent.com/acmesh-official/acme.sh/master/acme.sh
bash acme.sh --install
rm acme.sh
cd .acme.sh
bash acme.sh --register-account -m gratisan009@gmail.com
bash acme.sh --issue --standalone -d $domain --force
bash acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key
cd
chown -R nobody:nogroup /etc/xray/

# Install nginx Debian / Ubuntu
if [[ $OS == 'debian' ]]; then
	apt install -y gnupg2 ca-certificates lsb-release debian-archive-keyring && curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor > /usr/share/keyrings/nginx-archive-keyring.gpg && printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://nginx.org/packages/mainline/debian `lsb_release -cs` nginx" > /etc/apt/sources.list.d/nginx.list && printf "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900" > /etc/apt/preferences.d/99nginx && apt update -y && apt install -y nginx && mkdir -p /etc/systemd/system/nginx.service.d && printf "[Service]\nExecStartPost=/bin/sleep 0.1" > /etc/systemd/system/nginx.service.d/override.conf
elif [[ $OS == 'ubuntu' ]]; then
	apt install -y gnupg2 ca-certificates lsb-release ubuntu-keyring && curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor > /usr/share/keyrings/nginx-archive-keyring.gpg && printf "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] https://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" > /etc/apt/sources.list.d/nginx.list && printf "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900" > /etc/apt/preferences.d/99nginx && apt update -y && apt install -y nginx && mkdir -p /etc/systemd/system/nginx.service.d && printf "[Service]\nExecStartPost=/bin/sleep 0.1" > /etc/systemd/system/nginx.service.d/override.conf
fi

# Install Xray 
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install
# Setting NGINX
rm -f /etc/nginx/nginx.conf
cat> /etc/nginx/nginx.conf <<END
#AutoScript by Gugun
user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log notice;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    server {
        listen 89; #IPv4,http
        listen [::]:89; #IPv6,http
        return 301 https://xxx; #http
    }

    server {
        listen 127.0.0.1:81; #http/1.1 server
        server_name $domain;

        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always; 
        location / {
            if (yyyy ~* "\d+\.\d+\.\d+\.\d+") { 
                return 400;
            }
            root /var/www/html; 
            index index.html index.htm;
        }
    }

    server {
        listen 127.0.0.1:82 http2; #h2c server，监听本地82端口。
        server_name $domain; #更改为自己的域名

        location /tdngrpc443 { #与trojan+grpc应用中serviceName对应
            if (zzzz != "POST") {
                return 404;
            }
            client_body_buffer_size 1m;
            client_body_timeout 1h;
            client_max_body_size 0;
            grpc_read_timeout 1h;
            grpc_send_timeout 1h;
            grpc_pass grpc://127.0.0.1:2443;
        }

        location /tdngrpc80 {
            if (zzzz != "POST") {
                return 404;
            }
            client_body_buffer_size 1m;
            client_body_timeout 1h;
            client_max_body_size 0;
            grpc_read_timeout 1h;
            grpc_send_timeout 1h;
            grpc_pass grpc://127.0.0.1:8099;
        }

        add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always; #启用HSTS
        location / {
            if (yyyy ~* "\d+\.\d+\.\d+\.\d+") {
                return 400;
            }
            root /var/www/html;
            index index.html index.htm;
        }
    }
}
END
# Repleace Nginx
sed -i 's/xxx/$host$request_uri/g' /etc/nginx/nginx.conf
sed -i 's/yyyy/$host/g' /etc/nginx/nginx.conf
sed -i 's/zzzz/$request_method/g' /etc/nginx/nginx.conf
# Config port 443 trojan tcp tls + trojan ws
cat> /usr/local/etc/xray/config.json <<END
{
  #AutoScript by Gugun
  "log": {
    "loglevel": "warning",
    "error": "/var/log/xray/error.log",
    "access": "/var/log/xray/access.log"
  },
  "inbounds": [
    {
      "port": 443, 
      "protocol": "trojan",
      "settings": {
        "clients": [
          {
            "password":"gugun", 
            "flow": "xtls-rprx-direct", 
            "email": "gugun@gmail.com"
#trojantcp
          }
        ],
        "fallbacks": [
          {
            "alpn": "h2", 
            "dest": 82, 
            "xver": 0 
          },
          {
            "dest": 81, 
            "xver": 0 
          },
          {
            "path": "/trojan-ws", 
            "dest": 1443, 
            "xver": 0 
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "xtls", 
        "xtlsSettings": { 
          "alpn":[
            "h2", 
            "http/1.1" 
          ],
          "minVersion": "1.2", 
          "cipherSuites": "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384:TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256:TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256", 
          "certificates": [
            {
              "ocspStapling": 3600, 
              "certificateFile": "/etc/xray/xray.crt", 
              "keyFile": "/etc/xray/xray.key" 
            }
          ]
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    },
    {
      "listen": "127.0.0.1", 
      "port": 1443, 
      "protocol": "trojan",
      "settings": {
        "clients": [
          {
            "password":"gugun", 
            "email": "1443@gmail.com"
#trojanws
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "/trojan-ws" 
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    },
    {
      "listen": "127.0.0.1",
      "port": 2443, 
      "protocol": "trojan",
      "settings": {
        "clients": [
          {
            "password":"gugun", 
            "email": "2443@gmail.com"
#trojangrpc
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "gun",
        "security": "none",
        "grpcSettings": {
          "serviceName": "tdngrpc443"
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    }
  ],
  "routing": {
    "domainStrategy": "IPIfNonMatch",
    "rules": [
      {
        "type": "field",
        "protocol": [
          "bittorrent"
        ],
        "outboundTag": "blocked"
      }
    ]
  },
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "tag": "blocked",
      "protocol": "blackhole",
      "settings": {}
    }
  ]
}
END
# Config Port 80 Trojan tcp tls + Trojan ws
cat> /usr/local/etc/xray/none.json <<END
{
  #AutoScript by Gugun
  "log": {
    "loglevel": "warning",
    "error": "/var/log/xray/error.log",
    "access": "/var/log/xray/access.log"
  },
  "inbounds": [
    {
      "port": 80,
      "protocol": "trojan",
      "settings": {
        "clients": [
          {
            "password":"gugun", 
            "flow": "xtls-rprx-direct",
            "email": "gugun@gmail.com"
#trojantcp
          }
        ],
        "fallbacks": [
          {
            "alpn": "h2", 
            "dest": 82, 
            "xver": 0 
          },
          {
            "dest": 81, 
            "xver": 0 
          },
          {
            "path": "/trojan-ws", 
            "dest": 8088, 
            "xver": 0 
          }
        ]
      },
      "streamSettings": {
        "network": "tcp",
        "security": "xtls", 
        "xtlsSettings": { 
          "alpn":[
            "h2", 
            "http/1.1" 
          ],
          "minVersion": "1.2", 
          "cipherSuites": "TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384:TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256:TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256",
          "certificates": [
            {
              "ocspStapling": 3600, 
              "certificateFile": "/etc/xray/xray.crt", 
              "keyFile": "/etc/xray/xray.key"
            }
          ]
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    },
    {
      "listen": "127.0.0.1", 
      "port": 8088, 
      "protocol": "trojan",
      "settings": {
        "clients": [
          {
            "password":"gugun", 
            "email": "8088@gmail.com"
#trojanws
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "/trojan-ws" 
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    },
    {
      "listen": "127.0.0.1",
      "port": 8099,
      "protocol": "trojan",
      "settings": {
        "clients": [
          {
            "password":"gugun",
            "email": "8099@gmail.com"
#trojangrpc
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "gun",
        "security": "none",
        "grpcSettings": {
          "serviceName": "tdngrpc80"
        }
      },
      "sniffing": {
        "enabled": true,
        "destOverride": [
          "http",
          "tls"
        ]
      }
    }
  ],
  "routing": {
    "domainStrategy": "IPIfNonMatch",
    "rules": [
      {
        "type": "field",
        "protocol": [
          "bittorrent"
        ],
        "outboundTag": "blocked"
      }
    ]
  },
  "outbounds": [
    {
      "protocol": "freedom",
      "settings": {}
    },
    {
      "tag": "blocked",
      "protocol": "blackhole",
      "settings": {}
    }
  ]
}
END
# Iptables
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT
iptables -I INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 443 -j ACCEPT
iptables -I INPUT -m state --state NEW -m udp -p udp --dport 80 -j ACCEPT
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload
# Restart
systemctl daemon-reload
systemctl enable xray@none.service
systemctl start xray@none.service
systemctl restart nginx
systemctl restart xray

#List akun Trojan
touch /usr/local/etc/xray/akun.conf

# Install fail2ban
apt install -y fail2ban
service fail2ban restart

# Install DDoS Deflate
cd
apt install -y dnsutils tcpdump dsniff grepcidr
wget -qO ddos.zip "https://raw.githubusercontent.com/iriszz-official/autoscript/main/FILES/ddos-deflate.zip"
unzip ddos.zip
cd ddos-deflate
chmod +x install.sh
./install.sh
cd
rm -rf ddos.zip ddos-deflate

# blockir torrent
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

cd
# Install BBR
wget https://raw.githubusercontent.com/pixiqdarkit/trojan/main/bbr.sh && chmod +x bbr.sh && ./bbr.sh
cd /usr/bin
wget -O addtr "https://raw.githubusercontent.com/pixiqdarkit/trojan/main/addtrojan.sh"
wget -O cektr "https://raw.githubusercontent.com/pixiqdarkit/trojan/main/cektrojan.sh"
wget -O deltr "https://raw.githubusercontent.com/pixiqdarkit/trojan/main/deltrojan.sh"
wget -O renewtr "https://raw.githubusercontent.com/pixiqdarkit/trojan/main/renewtrojan.sh"
wget -O menu "https://raw.githubusercontent.com/pixiqdarkit/trojan/main/menu.sh"
wget -O menu-trojan "https://raw.githubusercontent.com/pixiqdarkit/trojan/main/menu-trojan.sh"
wget -O xp-tr "https://raw.githubusercontent.com/pixiqdarkit/trojan/main/xp-tr.sh"
wget -O cert-tr "https://gitlab.com/wid09/cert/-/raw/main/cert.sh"
# Untuk Panel ssh
wget -O newTrojan "https://raw.githubusercontent.com/pixiqdarkit/trojan/main/newTrojan.sh"
wget -O reGenerateTrojan "https://raw.githubusercontent.com/pixiqdarkit/trojan/main/reGenerateTrojan.sh"
wget -O renewTrojan "https://raw.githubusercontent.com/pixiqdarkit/trojan/main/renewTrojan.sh"
wget -O forceDeleteTrojan "https://raw.githubusercontent.com/pixiqdarkit/trojan/main/forceDeleteTrojan.sh"

# download script
cd /usr/bin
if [ -f "/home/email_cf.conf" ]; then
echo "Custom Domain"
  wget -O add-host "https://raw.githubusercontent.com/pixiqdarkit/trojan/main/ccf.sh"
else
echo "Original Domain Script"
  wget -O add-host "https://raw.githubusercontent.com/pixiqdarkit/trojan/main/add-host.sh"
fi

chmod +x add-host
chmod +x addtr
chmod +x cektr
chmod +x deltr
chmod +x renewtr
chmod +x menu
chmod +x menu-trojan
chmod +x xp-tr
chmod +x cert-tr
chmod +x newTrojan
chmod +x reGenerateTrojan
chmod +x renewTrojan
chmod +x forceDeleteTrojan

sed -i -e 's/\r$//' xp-tr
sed -i -e 's/\r$//' addtr
sed -i -e 's/\r$//' cektr
sed -i -e 's/\r$//' deltr
sed -i -e 's/\r$//' renewtr
sed -i -e 's/\r$//' menu
sed -i -e 's/\r$//' menu-trojan
sed -i -e 's/\r$//' newTrojan
sed -i -e 's/\r$//' reGenerateTrojan
sed -i -e 's/\r$//' renewTrojan
sed -i -e 's/\r$//' forceDeleteTrojan

echo "0 4 * * * root reboot" >> /etc/crontab
echo "0 0 * * * root xp-tr" >> /etc/crontab
cd
# install
apt-get --reinstall --fix-missing install -y bzip2 gzip coreutils wget screen rsyslog iftop htop net-tools zip unzip wget net-tools curl nano sed screen gnupg gnupg1 bc apt-transport-https build-essential dirmngr libxml-parser-perl neofetch git lsof
echo "clear" >> .profile
echo "menu" >> .profile

cd
# remove unnecessary files
apt -y autoclean
apt -y remove --purge unscd
apt-get -y --purge remove samba*;
apt-get -y --purge remove apache2*;
apt-get -y --purge remove bind9*;
apt-get -y remove sendmail*
apt autoremove -y

mv /root/domain /usr/local/etc/xray
systemctl restart nginx && systemctl restart xray
history -c
echo "unset HISTFILE" >> /etc/profile
