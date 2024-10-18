#!/bin/sh

mode=$(uci -q get ipv6.settings.mode)
ipv4mode=$(uci -q get network.wan.proto)
if [ "$mode" == "nat" ]; then
    status_wan_6=$(/sbin/ifstatus wan_6 | grep up | awk 'NR==1 {print $2}' | sed -e 's/,//')
    status_wan6=$(/sbin/ifstatus wan6 | grep up | awk 'NR==1 {print $2}' | sed -e 's/,//')
    [ "$status_wan6" = "false" ] && {
        exit 0
    }
    [ "$ipv4mode" = "pppoe" ] && [ "$status_wan_6" = "false" -o "$status_wan_6" = "" ] && {
        exit 0
    }
fi
exit 1
