#!/bin/sh

wan_port=$(uci -q get misc.sw_reg.sw_wan_port)
ip6_enabled=$(uci -q get ipv6.settings.enabled)
mode=$(uci -q get xiaoqiang.common.NETMODE)
status=$(ifstatus wan_6 | grep up | awk 'NR==1 {print $2}' | sed "s/.$//")
[ -n $wan_port ] || exit 0
[ $wan_port = $PORT_NUM -a $LINK_STATUS = "linkup" ] && {
    if [ "$ap_mode" != "wifiapmode" -a "$ap_mode" != "lanapmode" -a "$ap_mode" != "whc_re" ]; then
        if [ "$ip6_enabled" == "1" ]; then
            ifup wan_6
        fi
    fi
    logger -p warn -t "link_status_notify" "to sleep to check flash up"
}
[ $wan_port = $PORT_NUM -a $LINK_STATUS = "linkdown" ] && {
    if [ "$ap_mode" != "wifiapmode" -a "$ap_mode" != "lanapmode" -a "$ap_mode" != "whc_re" ]; then
        if [ "$ip6_enabled" == "1" ]; then
            if [ -n $status -a "$status" == "true" ]; then
                ifdown wan_6
            fi
        fi
    fi
    logger -p warn -t "link_status_notify" "to sleep to check flash down"
}

exist=`ps | grep "wwdog" | grep -v grep`
[ -z "$exist" ] || exit 0

/usr/sbin/wwdog taskdaemon &
exit 0
