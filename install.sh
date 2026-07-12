#!/bin/bash

set -e


echo "======================"
echo "   X-PANEL INSTALL"
echo "======================"


INSTALL_DIR="/opt/x-panel"

REPO="https://github.com/USERNAME/x-panel.git"



if [ "$EUID" -ne 0 ]; then

echo "Run as root"

exit 1

fi



echo "[1/7] Installing packages..."


apt update


apt install -y \
python3 \
python3-pip \
python3-venv \
postgresql \
postgresql-contrib \
git




echo "[2/7] Downloading X-PANEL..."



rm -rf $INSTALL_DIR


git clone $REPO $INSTALL_DIR




echo "[3/7] Creating Python env..."



cd $INSTALL_DIR



python3 -m venv venv



source venv/bin/activate



pip install --upgrade pip



pip install -r requirements.txt




echo "[4/7] PostgreSQL..."



sudo -u postgres psql <<EOF

CREATE DATABASE xpanel;

CREATE USER xpanel WITH PASSWORD 'xpanel';

GRANT ALL PRIVILEGES ON DATABASE xpanel TO xpanel;

EOF




echo "[5/7] Installing command..."



cp x-panel.sh /usr/local/bin/x-panel


chmod +x /usr/local/bin/x-panel




echo "[6/7] Installing service..."



cp systemd/x-panel.service /etc/systemd/system/x-panel.service



systemctl daemon-reload


systemctl enable x-panel


systemctl restart x-panel




echo "[7/7] DONE"


echo "

X-PANEL Installed

URL:
http://SERVER-IP:2096

Command:
x-panel

"
