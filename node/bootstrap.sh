#!/bin/bash
# Methoden definieren

cd /home/pirate/raspberrycloud/
git pull
chmod a+x /home/pirate/raspberrycloud/node/*
/home/pirate/raspberrycloud/node/publish_status.sh &


sleep 1
git reset --hard
git clean -fd