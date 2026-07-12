#!/bin/bash

set -e

APP_NAME="x-panel"
INSTALL_DIR="/opt/x-panel"

ZIP_URL="https://YOUR_DOMAIN.com/x-panel/x-panel.zip"


echo "========================="
echo "      X-PANEL INSTALL"
echo "========================="


if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi


echo "[1/8] Installing requirements..."

apt update

apt install -y \
python3 \
python3-pip \
python3-venv \
postgresql \
postgresql-contrib \
curl \
unzip


echo "[2/8] Downloading package..."


rm -rf /tmp/x-panel
mkdir -p /tmp/x-panel


curl -L "$ZIP_URL" -o /tmp/x-panel.zip


echo "[3/8] Extracting..."


rm -rf $INSTALL_DIR

mkdir -p $INSTALL_DIR


unzip /tmp/x-panel.zip -d /tmp/x-panel


cp -r /tmp/x-panel/x-panel/* $INSTALL_DIR



echo "[4/8] Creating Python environment..."


cd $INSTALL_DIR


python3 -m venv venv


source venv/bin/activate


pip install --upgrade pip


pip install -r requirements.txt




echo "[5/8] Setting PostgreSQL..."


sudo -u postgres psql <<EOF

DO \$\$

BEGIN

IF NOT EXISTS (
SELECT FROM pg_roles WHERE rolname='xpanel'
)

THEN

CREATE USER xpanel WITH PASSWORD 'xpanel';

END IF;

END

\$\$;


CREATE DATABASE xpanel OWNER xpanel;

EOF



echo "[6/8] Installing service..."


cp systemd/x-panel.service /etc/systemd/system/x-panel.service


systemctl daemon-reload


systemctl enable x-panel


systemctl restart x-panel




echo "[7/8] Installing command..."


cp x-panel.sh /usr/local/bin/x-panel


chmod +x /usr/local/bin/x-panel




echo "[8/8] Complete"


echo "

================================

X-PANEL INSTALLED

Panel:
http://SERVER-IP:2096


Command:

x-panel

================================

"
