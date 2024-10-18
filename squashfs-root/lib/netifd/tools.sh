#!/bin/bash

get_wan_mtu(){
    local wan_dev=`uci -q get network.wan.ifname`
    local wan_proto=`uci -q get network.wan.proto`
    if [ "$wan_proto" = "pppoe" ]; then
        wan_dev="pppoe-wan"
    fi

    local wan_mtu=`ip a show dev $wan_dev |grep -o "mtu\s*[0-9]*"|awk '{print $2}'`
    echo $wan_mtu
}

