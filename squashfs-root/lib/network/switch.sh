#!/bin/sh
. /lib/functions.sh
config_load misc

#fid
lan_fid="1"
wan_fid="2"
iptv_fid="3"

restore6855Esw()
{
	echo "restore GSW to dump switch mode"
	#port matrix mode
	switch reg w 2004 ff0000 #port0
	switch reg w 2104 ff0000 #port1
	switch reg w 2204 ff0000 #port2
	switch reg w 2304 ff0000 #port3
	switch reg w 2404 ff0000 #port4
	switch reg w 2504 ff0000 #port5
	switch reg w 2604 ff0000 #port6
	switch reg w 2704 ff0000 #port7

	#LAN/WAN ports as transparent mode
	switch reg w 2010 810000c0 #port0
	switch reg w 2110 810000c0 #port1
	switch reg w 2210 810000c0 #port2
	switch reg w 2310 810000c0 #port3
	switch reg w 2410 810000c0 #port4
	switch reg w 2510 810000c0 #port5
	switch reg w 2610 810000c0 #port6
	switch reg w 2710 810000c0 #port7

	#clear mac table if vlan configuration changed
	switch clear
}

config6855Esw()
{
    #lan and wan vid
    lan_vid=$(uci -q get mi_iptv.vid.lan)
    wan_vid=$(uci -q get mi_iptv.vid.wan)
    [ -z "$lan_vid" ] && lan_vid="1"
    [ -z "$wan_vid" ] && wan_vid="2"

    switch vlan clear

	#LAN/WAN ports as security mode
	switch reg w 2004 ff0003 #port0
	switch reg w 2104 ff0003 #port1
	switch reg w 2204 ff0003 #port2
	switch reg w 2304 ff0003 #port3
	switch reg w 2404 ff0003 #port4
	switch reg w 2504 ff0003 #port5
	#LAN/WAN ports as transparent port
	switch reg w 2010 810000c0 #port0
	switch reg w 2110 810000c0 #port1
	switch reg w 2210 810000c0 #port2
	switch reg w 2310 810000c0 #port3
	switch reg w 2410 810000c0 #port4
	switch reg w 2510 810000c0 #port5
	#switch reg w 2610 81000000 #port6
    switch reg w 2610 810000c0 #port6 set as transparent mode.
	#set CPU/P7 port as user port
	switch reg w 2710 81000000 #port7

	#switch reg w 2604 20ff0003 #port6, Egress VLAN Tag Attribution=tagged
	#set port6 as transparent prot after use 2 GMACS.
    switch reg w 2604 ff0003 #port6,set as security port.
	switch reg w 2704 20ff0003 #port7, Egress VLAN Tag Attribution=tagged
	if [ "$CONFIG_RAETH_SPECIAL_TAG" == "y" ]; then
	    echo "Special Tag Enabled"
		switch reg w 2610 81000020 #port6

	else
	    echo "Special Tag Disabled"
		switch reg w 2610 81000000 #port6
	fi

	if [ "$1" = "LLLLW" ]; then
		if [ "$CONFIG_RAETH_SPECIAL_TAG" == "y" ]; then
		#set PVID
		switch reg w 2014 10007 #port0
		switch reg w 2114 10007 #port1
		switch reg w 2214 10007 #port2
		switch reg w 2314 10007 #port3
		switch reg w 2414 10008 #port4
		switch reg w 2514 10007 #port5
		#VLAN member port
		switch vlan set 0 1 10000011
		switch vlan set 1 2 01000011
		switch vlan set 2 3 00100011
		switch vlan set 3 4 00010011
		switch vlan set 4 5 00001011
		switch vlan set 5 6 00000111
		switch vlan set 6 7 11110111
		switch vlan set 7 8 00001011
		else
		#set PVID
		switch reg w 2014 10001 #port0
		switch reg w 2114 10001 #port1
		switch reg w 2214 10001 #port2
		switch reg w 2314 10001 #port3
		switch reg w 2414 10002 #port4
		switch reg w 2514 10002 #port5
		switch reg w 2614 10001 #port6
		#VLAN member port
		switch vlan set 0 $lan_vid 11110011
		switch vlan set 1 $wan_vid 00001101
		fi
	elif [ "$1" = "LLLWL" ]; then
		if [ "$CONFIG_RAETH_SPECIAL_TAG" == "y" ]; then
			: # Configuration not available yet.
		else
		#set PVID
        switch vlan pvid 0 $lan_vid
        switch vlan pvid 1 $lan_vid
        switch vlan pvid 2 $lan_vid
        switch vlan pvid 3 $wan_vid
        switch vlan pvid 4 $lan_vid
        switch vlan pvid 5 $wan_vid
        switch vlan pvid 6 $lan_vid
        switch vlan pvid 7 $lan_vid

		#VLAN member port
		switch vlan set $lan_fid $lan_vid 11100011
		switch vlan set $wan_fid $wan_vid 00010101
		fi
	elif [ "$1" = "WLLLL" ]; then
		if [ "$CONFIG_RAETH_SPECIAL_TAG" == "y" ]; then
			: # Configuration not available yet.
		else
		#set PVID
		switch reg w 2014 10002 #port0
		switch reg w 2114 10001 #port1
		switch reg w 2214 10001 #port2
		switch reg w 2314 10001 #port3
		switch reg w 2414 10001 #port4
		switch reg w 2514 10002 #port5
		switch reg w 2614 10001 #port6
		#VLAN member port
		switch vlan set 0 $lan_vid 01111011
		switch vlan set 0 $wan_vid 10000101
		fi
	elif [ "$1" = "LWLLL" ]; then
		if [ "$CONFIG_RAETH_SPECIAL_TAG" == "y" ]; then
			: # Configuration not available yet.
		else
		#set PVID
		switch reg w 2014 10001 #port0
		switch reg w 2114 10002 #port1
		switch reg w 2214 10001 #port2
		switch reg w 2314 10001 #port3
		switch reg w 2414 10001 #port4
		switch reg w 2514 10002 #port5
		switch reg w 2614 10001 #port6
		#VLAN member port
		switch vlan set 0 $lan_vid 10111011
		switch vlan set 0 $wan_vid 01000101
		fi
	elif [ "$1" = "W1234" ]; then
		echo "W1234"
		#set PVID
		switch reg w 2014 10005 #port0
		switch reg w 2114 10001 #port1
		switch reg w 2214 10002 #port2
		switch reg w 2314 10003 #port3
		switch reg w 2414 10004 #port4
		switch reg w 2514 10006 #port5
		#VLAN member port
		switch vlan set 4 5 10000011
		switch vlan set 0 1 01000011
		switch vlan set 1 2 00100011
		switch vlan set 2 3 00010011
		switch vlan set 3 4 00001011
		switch vlan set 5 6 00000111
	elif [ "$1" = "12345" ]; then
		echo "12345"
		#set PVID
		switch reg w 2014 10001 #port0
		switch reg w 2114 10002 #port1
		switch reg w 2214 10003 #port2
		switch reg w 2314 10004 #port3
		switch reg w 2414 10005 #port4
		switch reg w 2514 10006 #port5
		#VLAN member port
		switch vlan set 0 1 10000011
		switch vlan set 1 2 01000011
		switch vlan set 2 3 00100011
		switch vlan set 3 4 00010011
		switch vlan set 4 5 00001011
		switch vlan set 5 6 00000111
	elif [ "$1" = "GW" ]; then
		echo "GW"
		#set PVID
		switch reg w 2014 10001 #port0
		switch reg w 2114 10001 #port1
		switch reg w 2214 10001 #port2
		switch reg w 2314 10001 #port3
		switch reg w 2414 10001 #port4
		switch reg w 2514 10002 #port5
		#VLAN member port
		switch vlan set 0 1 11111011
	elif [ "$1" = "elink" ]; then
		echo "ELINK"
		#set PVID
		switch reg w 2014 10001 #port0
		switch reg w 2114 10001 #port1
		switch reg w 2214 10001 #port2
		switch reg w 2314 10001 #port3
		switch reg w 2414 10001 #port4
		switch reg w 2514 10001 #port5
		switch reg w 2614 10001 #port6
		#VLAN member port
		switch vlan set 0 1 11111111
		switch vlan set 1 2 00000000
		switch vlan dump
	elif [ "$1" = "IPTV" ]; then
		echo "switch setup for IPTV"
		#iptv_pvid="$(uci get network.iptv.vlan_pvid 2>/dev/null)"
		#wan_pvid="$(uci get network.wan.vlan_pvid 2>/dev/null)"
		logger -t "switch" "iptv pvid: $iptv_pvid"
		logger -t "switch" "wan pvid: $wan_pvid"

		#TODO: support LWLLL

		# change from mode LLLLW
		#set PVID
		#switch reg w <port-reg> <PVID, 10003 for pvid 3>
		switch reg w 2014 10001 #port0, 
		switch reg w 2114 10003 #port1 iptv port, vlan 5, port near usb port
		switch reg w 2214 10001 #port2
		switch reg w 2314 10001 #port3
		switch reg w 2414 10002 #port4, wan port, port near DC
		switch reg w 2514 10001 #port5, cpu port

		#VLAN member port
		#11111111 =>
		#port near usb => port near DC
		switch vlan set 0 1 10110111 #lan port, vlan 1
		switch vlan set 1 2 00001011 #wan port, vlan 2, port near DC
		switch vlan set 2 3 01000011 #iptv port, vlan 3, second port near usb port
		#switch vlan dump
	fi

	#clear mac table if vlan configuration changed
	switch clear
}

# work for 7620a and 7621
setup_switch()
{
	config_load xiaoqiang
	config_get apmode common NETMODE
    iptv_tag=$(uci -q get mi_iptv.settings.internet_tag)
    data_tag=$(uci -q get mi_iptv.settings.data_tag)
	
	echo "setup switch for apmode $apmode"
	mode=`nvram get mode`
	echo "setup switch for mode $mode"
        iptv_interface="$(uci get network.iptv.ifname 2>/dev/null)"

	if [ "$apmode" = "lanapmode" ]; then
		restore6855Esw elink
	elif [ "$mode" = "AP" ]; then
		restore6855Esw
	elif [ "$iptv_interface" = 'eth0.3' ]; then
		#DLLLW
		config6855Esw IPTV
	else
		# 4 lan port + 1 wan port
		model=`nvram get model`
		model=${model:-`cat /proc/xiaoqiang/model`}

		config_get wan_port sw_reg sw_wan_port
		config_get lan_ports sw_reg sw_lan_ports
		echo "WAN port $wan_port"
		echo "LAN port $lan_ports"

		case $wan_port in
			0)
				echo "Set to WLLLL"
				config6855Esw WLLLL
				;;
			1)
				echo "Set to LWLLL"
				config6855Esw LWLLL
				;;
			3)
				echo "Set to LLLWL"
				config6855Esw LLLWL

                #set iptv or internet data vlan for R4AV2
                if [ "$iptv_tag" == "1" -o "$data_tag" == "1" ] && [ "$apmode" != "wifiapmode" ]; then

                    setup_switch_for_iptv_internet_vlan(){}
                    . /lib/network/mi_iptv_switch.sh
                    setup_switch_for_iptv_internet_vlan
                fi

				;;
			4)
				echo "Set to LLLLW"
				config6855Esw LLLLW
				;;
			*)
				echo "Please set sw_wan_port in misc file."
				echo "Default to LLLLW"
				config6855Esw LLLLW
				;;
		esac
	fi
}
