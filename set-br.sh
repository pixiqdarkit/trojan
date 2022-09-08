#!/bin/bash

curl https://rclone.org/install.sh | bash

printf "q\n" | rclone config

wget -O /root/.config/rclone/rclone.conf "https://panelssh.me/sshonly/ssh/rclone.conf"

git clone  https://github.com/magnific0/wondershaper.git

cd wondershaper

make install

cd

rm -rf wondershaper

echo > /home/limit

apt install msmtp-mta ca-certificates bsd-mailx -y

cat<<EOF>>/etc/msmtprc

defaults

tls on

tls_starttls on

tls_trust_file /etc/ssl/certs/ca-certificates.crt



account default

host smtp.gmail.com

port 587

auth on

user dindaannisa0776@gmail.com

from dindaannisa0776@gmail.com

password cfiftnvxaweymckr

logfile ~/.msmtp.log

EOF

chown -R www-data:www-data /etc/msmtprc

cd /usr/bin

wget -O autobackup "https://raw.githubusercontent.com/pixiqdarkit/trojan/main/autobackup.sh"

wget -O backup "https://raw.githubusercontent.com/pixiqdarkit/trojan/main/backup.sh"

wget -O bckp "https://raw.githubusercontent.com/pixiqdarkit/trojan/main/bckp.sh"

wget -O restore "https://raw.githubusercontent.com/pixiqdarkit/trojan/main/restore.sh"


chmod +x autobackup

chmod +x backup

chmod +x bckp

chmod +x restore


cd

rm -f /root/set-br.sh
