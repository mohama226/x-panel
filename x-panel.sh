#!/bin/bash


case $1 in

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

*)

echo "
X-PANEL

start
stop
restart
status
logs

"

;;

esac
