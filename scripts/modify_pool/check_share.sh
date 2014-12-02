#!/bin/bash
set -eu

ip="$1"
threshold="$2"

sshpass -p root \
    ssh -T -o UserKnownHostsFile=/dev/null \
        -o StrictHostKeyChecking=no \
        -o ConnectTimeout=30 \
    root@"$ip" "
threshold=$threshold;
share=\`/usr/bin/cgminer-api | sed -n 's| \+\[GHS av\] => \([[:digit:]]\+\).\+|\1|gp'\`;
if [[ \"\$share\" -lt \"\$threshold\" ]]; then
    echo lower than expected \"\$threshold\", restarting... >&2 ;
    /etc/init.d/cgminer restart ;
fi
"
