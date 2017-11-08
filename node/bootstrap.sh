#!/bin/bash
# Methoden definieren

rm -r /home/pirate/raspberrycloud
cd /home/pirate/
git clone https://github.com/herjann4711/raspberrycloud.git
chmod +x /home/pirate/raspberrycloud/node/publish_status.sh
/home/pirate/raspberrycloud/node/publish_status.sh