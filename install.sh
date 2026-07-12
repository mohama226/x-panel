#!/bin/bash

set -e


apt update

apt install -y \
python3 \
python3-venv \
python3-pip \
git \
postgresql


mkdir -p /opt


cd /opt


git clone https://github.com/USERNAME/x-panel.git


cd x-panel/backend


python3 -m venv venv


source venv/bin/activate


pip install -r ../requirements.txt



cp ../x-panel.sh /usr/local/bin/x-panel

chmod +x /usr/local/bin/x-panel


echo "X-PANEL installed"

echo "Run:"
echo "x-panel"
