#!/bin/bash
# Methoden definieren
createJson(){
  cat <<EOF
{
  'ClientInfo': {
    'Hostname': '$HOSTNAME',
    'Ip': '$IP'
  },
  'CpuUsage': {
    'Usage': $CPU_USAGE
  },
  'RamUsage': {
    'Usage': $RAM_USAGE
  },
  'DockerInfo': {
    'RunningContainers': []
  }
}
EOF
}

# Schritt 1: Master finden
TARGETS=`nmap -PN -p 80 --open -oG - 192.168.0.* | awk '$NF~/http/{print $2}'`
MASTER_IP=""

while read line
do
   content=$(wget http://$line -q -O -)
   if [ "$content" == "master" ]; then
     MASTER_IP=`echo $line`
     break
   fi
done <<< "$(echo -e "$TARGETS")"

if [ "$MASTER_IP" = "" ]; then
   echo "MASTER NOT FOUND!"
   exit 1;
fi

echo "MASTER FOUND AT $MASTER_IP"

# Schritt 2: Infos an Master schicken
while true
do
  CPU_USAGE=`grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage}'`
  RAM_USAGE=`free -m | awk 'NR==2{printf "%.2f", $3*100/$2 }'`
  IP=`/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1`
  RUNNING_CONTAINER=`docker ps --format="{{ json .Names }}" | sed 's/"//g'`

  echo $(createJson)
 echo "http://$MASTER_IP/api/status"
  curl -i -H "Accept: application/json" -H "Content-Type:application/json" -X POST --data "$(createJson)" "http://$MASTER_IP/api/status"
  sleep 1
done
