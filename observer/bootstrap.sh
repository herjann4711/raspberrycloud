#!/bin/bash
cd /home/pi/raspberrycloud/
git reset --hard
git clean -fd
git pull
chmod +x /home/pi/raspberrycloud/observer/start_server.sh
/home/pi/raspberrycloud/observer/start_server.sh