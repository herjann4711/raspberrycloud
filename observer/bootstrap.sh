#!/bin/bash
rm -r /home/pi/raspberrycloud
cd /home/pi/
git clone https://github.com/herjann4711/raspberrycloud.git
chmod +x /home/pi/raspberrycloud/observer/start_server.sh
/home/pi/raspberrycloud/observer/start_server.sh