#!/bin/bash
set -eu

ip="$1"

sshpass -p root \
    ssh -T -o UserKnownHostsFile=/dev/null \
        -o StrictHostKeyChecking=no \
        -o ConnectTimeout=30 \
    root@"$ip" "
sed -i '/if ( ! has_ssh_pubkey/,/then/d; /fi/d' /etc/init.d/telnet;
sed -i '3a FAILSAFE=1' /bin/login.sh;
/etc/init.d/telnet start;
"
