#!/bin/bash


SERVICE="x-panel"


case "$1" in


start)

systemctl start $SERVICE
;;


stop)

systemctl stop $SERVICE
;;


restart)

systemctl restart $SERVICE
;;


status)

systemctl status $SERVICE
;;


logs)

journalctl -u $SERVICE -f
;;


update)

cd /opt/x-panel
git pull
systemctl restart $SERVICE
;;


uninstall)

systemctl stop $SERVICE
systemctl disable $SERVICE
rm -rf /opt/x-panel
rm /usr/local/bin/x-panel
;;


*)

echo "
X-PANEL

start
stop
restart
status
logs
update
uninstall

"

;;

esac
