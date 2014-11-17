#!/bin/bash
set -eu

ip="$1"
pool1url="$2"
pool1user="$3"
pool2url="$4"
pool2user="$5"

if ! sshpass -p root \
    ssh -T -o StrictHostKeyChecking=no -o ConnectTimeout=20 \
    root@"$ip" "
( uci set cgminer.default.pool1url=$pool1url;
  uci set cgminer.default.pool1user=$pool1user;
  uci set cgminer.default.pool2url=$pool2url;
  uci set cgminer.default.pool2user=$pool2user;
  uci commit;
  /etc/init.d/cgminer restart;
) >/dev/null 2>&1 "
then
    echo "操作 $ip 失败，请检查" >&2;
    echo "-=-=-=-=-=-=-==-=-=-=-=-=-=-" >&2;
    exit 1
fi
