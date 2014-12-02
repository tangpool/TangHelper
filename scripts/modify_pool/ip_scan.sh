#!/bin/bash
set -eu

DEFAULT_MAX_CONCURRENT=100

usage() {
    echo "
Usage: `basename $0` [OPTIONS] file ip_range_start ip_range_end args...

批量修改矿池设置

OPTIONS
    -m, --max_concurrent="$DEFAULT_MAX_CONCURRENT"
        最大同时执行数，设为 0 则不限制

ARGUMENTS
    file
        要执行的文件路径，需要为 shell 文件
    ip_range_start=str
        起始 IP 地址
    ip_range_end=str
        终止 IP 地址
    args...
        传给 process.sh 参数列表
"
    exit
}

ip_to_int() {
    local a b c d
    IFS='.' read a b c d <<< "$1"
    echo $(( 256 ** 3 * a + 256 ** 2 * b + 256 * c + d ))
}

int_to_ip() {
    local dot= ip int=$1
    for e in {3..0}; do
        (( value = $int / (256 ** e) ))
        (( int -= $value * 256 ** e ))
        ip+=$dot$value
        dot='.'
    done
    echo "$ip"
}

main() {
    local ip_range_end_int=`ip_to_int "$ip_range_end"`
    local ip="$ip_range_start"
    local pids=()
    while true; do
        /bin/bash "$process_file" "$ip" $* >miner."$ip"."$process_file".log 2>&1 &

        # 排队
        if [[ "$max_concurrent" -ne 0 ]]; then
            pids[$!]=1
            if [[ "${#pids[@]}" -eq "$max_concurrent" ]]; then
                while true; do
                    has_done=0
                    for pid in "${!pids[@]}"; do
                        if ! kill -0 "$pid" 2>/dev/null; then # done
                            unset pids[$pid]
                            has_done=1
                        fi
                    done
                    [[ "$has_done" -eq 1 ]] && {
                        break;
                    }
                    sleep 1
                done
            fi
        fi

        # iterate next ip
        ip_int=`ip_to_int "$ip"`
        if [[ "$ip_int" -ge "$ip_range_end_int" ]]; then
            break
        fi
        (( ip_int += 1))
        ip=`int_to_ip "$ip_int"`
    done

    while true; do
        for pid in "${!pids[@]}"; do
            if ! kill -0 "$pid" 2>/dev/null; then # done
                unset pids[$pid]
            fi
        done
        if [[ ${#pids[@]} -eq 0 ]]; then
            break;
        fi
        echo "waiting for ${#pids[@]} to be done..."
        sleep 1
    done

    echo "done"

    exit 0
}

if ! which sshpass >/dev/null 2>&1; then
    echo "请安装 sshpass 后再执行本程序：
sudo apt-get install -y sshpass" >&2
    exit 1
fi

cwd=$(cd "$(dirname "$0")"; pwd)
if [[ ! -f "$cwd"/process.sh ]]; then
    echo "目录 $cwd 下找不到 process.sh" >&2
    exit 2
fi

ARGS=`getopt -o m: -l max: -- "$@"`
[ $? -ne 0 ] && usage
eval set -- "${ARGS}"

max_concurrent=

while true; do
    case "$1" in
        -m|--max_concurrent)
            max_concurrent="$2"
            shift
            ;;
        --)
            shift
            break
            ;;
    esac
shift
done

[[ $# -lt 3 ]] && usage;
if [[ -z "$max_concurrent" ]]; then
    max_concurrent="$DEFAULT_MAX_CONCURRENT"
fi

process_file="$1"; shift
process_file=`readlink -e "$process_file"`

ip_range_start="$1"; shift
ip_range_end="$1"; shift

main $*