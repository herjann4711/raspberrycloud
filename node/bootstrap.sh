#!/bin/bash
# Methoden definieren

cd /home/pirate/raspberrycloud/
git reset --hard
git clean -fd
git pull
chmod a+x /home/pirate/raspberrycloud/node/*
/home/pirate/raspberrycloud/node/publish_status.sh &