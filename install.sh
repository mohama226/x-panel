#!/bin/bash

set -e

echo "======================"
echo "   X-PANEL INSTALL"
echo "======================"


INSTALL_DIR="/opt/x-panel"


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


echo "[2/7] Installing panel files..."


mkdir -p $INSTALL_DIR


cp -r ./* $INSTALL_DIR/


echo "[3/7] Creating Python env..."


cd $INSTALL_DIR


python3 -m venv venv


source venv/bin/activate


pip install --upgrade pip


pip install -r requirements.txt



echo "[4/7] Config PostgreSQL..."


sudo -u postgres psql <<EOF

CREATE DATABASE xpanel;

CREATE USER xpanel WITH PASSWORD 'xpanel';

GRANT ALL PRIVILEGES ON DATABASE xpanel TO xpanel;

EOF



echo "[5/7] Installing command..."



cp x-panel.sh /usr/local/bin/x-panel

chmod +x /usr/local/bin/x-panel



echo "[6/7] Installing service..."



cp systemd/x-panel.service /etc/systemd/system/


systemctl daemon-reload


systemctl enable x-panel

systemctl restart x-panel



echo "[7/7] Finished"


echo ""
echo "================================="
echo " X-PANEL Installed"
echo " Port : 2096"
echo " Command : x-panel"
echo "================================="
