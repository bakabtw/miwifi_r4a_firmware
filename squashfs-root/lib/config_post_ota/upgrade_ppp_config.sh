#!/bin/sh
#enable all user's specdial as default if OTA

wan_proto=$(uci -q get network.wan.proto)
[ "$wan_proto" = "pppoe" ] && {
    uci -q set network.wan.special=1
    uci commit network
}
