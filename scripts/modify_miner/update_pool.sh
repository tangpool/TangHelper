#!/bin/bash
set -eu

ip="$1"
pool1url="$2"
pool2url="$3"

sshpass -p root \
    ssh -T -o UserKnownHostsFile=/dev/null \
        -o StrictHostKeyChecking=no \
        -o ConnectTimeout=30 \
    root@"$ip" <<EOF
sed -i "s|\(option pool1url '\)\(.\+\)'$|\1${pool1url}'|g" /etc/config/cgminer
sed -i "s|\(option pool2url '\)\(.\+\)'$|\1${pool2url}'|g" /etc/config/cgminer
/etc/init.d/cgminer restart;
EOF
