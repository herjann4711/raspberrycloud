#!/bin/bash
# Methoden definieren

cd /home/pirate/raspberrycloud/
git reset --hard
git clean -fd
git pull
chmod +x /home/pirate/raspberrycloud/node/publish_status.sh
/home/pirate/raspberrycloud/node/publish_status.sh &