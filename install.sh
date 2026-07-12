#!/bin/bash

set -e

echo "======================"
echo "   X-PANEL INSTALL"
echo "======================"


INSTALL_DIR="/opt/x-panel"

ZIP_URL="https://YOUR-DOMAIN/x-panel/x-panel.zip"



if [ "$EUID" -ne 0 ]; then
    echo "Run as root"
    exit 1
fi


echo "[1/6] Installing packages"


apt update

apt install -y \
python3 \
python3-pip \
python3-venv \
postgresql \
postgresql-contrib \
unzip \
curl



echo "[2/6] Downloading ZIP"


rm -rf /tmp/x-panel.zip
rm -rf $INSTALL_DIR


curl -L $ZIP_URL -o /tmp/x-panel.zip



mkdir -p $INSTALL_DIR


unzip /tmp/x-panel.zip -d /tmp/x-panel



cp -r /tmp/x-panel/* $INSTALL_DIR



echo "[3/6] Python setup"


cd $INSTALL_DIR


python3 -m venv venv


source venv/bin/activate


pip install --upgrade pip


pip install -r requirements.txt




echo "[4/6] PostgreSQL"


sudo -u postgres psql <<EOF

CREATE DATABASE xpanel;

CREATE USER xpanel WITH PASSWORD 'xpanel';

GRANT ALL PRIVILEGES ON DATABASE xpanel TO xpanel;

EOF




echo "[5/6] Service"


cp systemd/x-panel.service /etc/systemd/system/x-panel.service


systemctl daemon-reload

systemctl enable x-panel

systemctl restart x-panel




echo "[6/6] Finished"


echo "
========================
 X-PANEL INSTALLED

 URL:
 http://SERVER-IP:2096

 Command:
 x-panel

========================
"
