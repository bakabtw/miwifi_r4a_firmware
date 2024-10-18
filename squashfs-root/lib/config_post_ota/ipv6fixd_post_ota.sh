#!/bin/sh
# Copyright (C) 2016 Xiaomi

flag=$(uci -q get ipv6.settings.enabled)
mode=$(uci -q get ipv6.settings.mode)



hardware=$(cat /usr/share/xiaoqiang/xiaoqiang_version | grep "option HARDWARE" |  awk 'NR==1 {print $3}')
version=$(cat /usr/share/xiaoqiang/xiaoqiang_version | grep "option ROM" | awk 'NR==1 {print $3}')

version=$(echo "$version" | sed "s/'//g")
hardware=$(echo "$hardware" | sed "s/'//g")

if [ "$hardware" != "RM2100" -a "$hardware" != "R4AV2" ]; then
    exit 0
fi

ap_mode=$(uci -q get xiaoqiang.common.NETMODE)
if [ "$ap_mode" == "wifiapmode" -o "$ap_mode" == "lanapmode" ]; then
    echo "AP mode do not enable ipv6"
    cat /etc/config/.network.mode.router | grep wan6
    if [ $? != 0 ]; then
        exit 0
    else
        if [ "$flag" == "1" ]; then
            cp /etc/config/.network.mode.router /etc/config/tmpnetwork

uci -q batch <<-EOF >/dev/null
            delete tmpnetwork.wan6
            del_list tmpnetwork.lan.ip6class=wan6
            delete tmpnetwork.lan.ip6addr
            delete tmpnetwork.lan.ip6assign
            commit tmpnetwork
EOF
            cp /etc/config/tmpnetwork /etc/config/.network.mode.router
        fi
    fi
fi


cat /etc/config/network | grep wan6
if [ $? != 0 ]; then
   exit 0
fi


uci -q batch <<-EOF >/dev/null
    delete network.wan6
    del_list network.lan.ip6class=wan6
    delete network.lan.ip6addr
    delete network.lan.ip6assign
    commit network
EOF

