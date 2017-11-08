#!/bin/bash
# Methoden definieren

cd /home/pi/raspberrycloud/
git pull
chmod +x /home/pi/raspberrycloud/observer/publish/PrivateCloudWatcher
chmod +x /home/pi/raspberrycloud/observer/start_server.sh
/home/pi/raspberrycloud/observer/start_server.sh

git reset --hard
git clean -fd