#!/bin/bash


case "$1" in


start)

systemctl start x-panel

;;


stop)

systemctl stop x-panel

;;


restart)

systemctl restart x-panel

;;


status)

systemctl status x-panel

;;


logs)

journalctl -u x-panel -f

;;


update)

cd /opt/x-panel

git pull

systemctl restart x-panel

;;


uninstall)


systemctl stop x-panel

systemctl disable x-panel

rm /etc/systemd/system/x-panel.service

rm -rf /opt/x-panel

rm /usr/local/bin/x-panel


systemctl daemon-reload


echo "Removed"

;;


*)

echo "
X-PANEL Manager

1) x-panel start
2) x-panel stop
3) x-panel restart
4) x-panel status
5) x-panel logs
6) x-panel update
7) x-panel uninstall

"

;;

esac
