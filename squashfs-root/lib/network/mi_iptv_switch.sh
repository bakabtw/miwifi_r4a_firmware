#!/bin/sh
# mi_iptv_switch.sh, should be included in switch.sh

mi_iptv_lock="/var/run/mi_iptv.lock"

#iptv
internet_tag=$(uci -q get mi_iptv.settings.internet_tag)
internet_vid=$(uci -q get mi_iptv.settings.internet_vid)
lan_port1=$(uci -q get mi_iptv.settings.lan_port1)
lan_port2=$(uci -q get mi_iptv.settings.lan_port2)
priority=$(uci -q get mi_iptv.settings.priority)

#wan internet
data_tag=$(uci -q get mi_iptv.settings.data_tag)
data_vid=$(uci -q get mi_iptv.settings.data_vid)
data_priority=$(uci -q get mi_iptv.settings.data_priority)
wan_port=$(uci -q get misc.sw_reg.sw_wan_port)

#lan and wan vid
lan_vid=$(uci -q get mi_iptv.vid.lan)
wan_vid=$(uci -q get mi_iptv.vid.wan)

#fid
lan_fid="1"
wan_fid="2"
iptv_fid="3"

#lan port id
lan1_port="1"
lan2_port="2"

#set dft vid if null
[ -z "$lan_vid" ] && lan_vid="1"
[ -z "$wan_vid" ] && wan_vid="2"

[ "$lan_port1" != "1" ] && lan_port1="0"
[ "$lan_port2" != "1" ] && lan_port2="0"

iptv_logger() {
    echo "mi_iptv: $1" > /dev/console
    logger -t mi_iptv "$1"
}

#check if vlan id valid
check_if_vid_valid(){
    vid=$1
    vid_msg=$2
    [ $vid -le 0 -o $vid -gt 4094 ] && {
        iptv_logger "invalid vid: $vid, $vid_msg"
        exit -1
    }
}

#set lan and wan vid to valid value
verify_all_vlan_id(){
    local changed=""
    #internet vid must not equal to iptv id
    if [ -n "$internet_tag" -a -n "$data_tag" -a -n "$internet_vid" -a -n "$data_vid" ]; then
        if [ "$internet_tag" == "1" -a "$data_tag" == "1" -a "$internet_vid" == "$data_vid" ]; then
            iptv_logger "ERROR: internet_vid:$internet_vid == data_vid:$data_vid, conflict!!!".
            exit -2
        fi
    fi
    
    #adapt wan internet/data id
    if [ -n "$data_tag" -a "$data_tag" == "1" -a -n "$data_vid" -a "$data_vid" != "0" ]; then
        check_if_vid_valid $data_vid "data_vid exceed vlan range, exit!!!"
        
        if [ "$data_vid" != $wan_vid ]; then
            wan_vid=$data_vid
            changed="1"
        fi
    fi
    
    #adapt lan id with iptv
    if [ -n "$internet_tag" -a "$internet_tag" == "1" -a -n "$internet_vid" -a "$internet_vid" != "-1" ]; then
        check_if_vid_valid $internet_vid "internet_vid exceed vlan range, exit!!!"
        
        if [ "$internet_vid" == "$lan_vid" ]; then
            lan_vid=$(($internet_vid + 1))
            changed="1"
        fi
    fi
    
    #adapt lan and wan
    [ -z "$lan_vid" ] && {
        lan_vid="1"
        changed="1"
    }
    
    [ -z "$wan_vid" ] && {
        wan_vid="2"
        changed="1"
    }
    
    if [ "$wan_vid" == "$lan_vid" ]; then
        lan_vid=$(($wan_vid + 1))
        changed="1"
    fi
    
    if [ -n "$changed" ]; then
        check_if_vid_valid $lan_vid "lan_vid exceed vlan range, exit!!!"
        check_if_vid_valid $wan_vid "wan_vid exceed vlan range, exit!!!"
        
        uci -q set mi_iptv.vid=vid
        uci -q set mi_iptv.vid.wan=$wan_vid
        uci -q set mi_iptv.vid.lan=$lan_vid
        uci -q commit mi_iptv
    fi
}

power(){
    base=$1
    index=$2
    val="1"
    for i in $(seq $index);
    do
        val=$(($val*$base))
    done
    echo $val
}

#NOTE: should be called after setup_switch()
#setup iptv and internet-data iptv
setup_switch_for_iptv_internet_vlan(){
    
    #verify_all_vlan_id
    
    #######################################
    #Step1. iptv vlan switch set
    #######################################
    if [ "$internet_tag" == "1" ]; then
        local iptv_vid=$internet_vid
        
        # set vlan priority
        local tmp1=`printf %03X $iptv_vid`
        let tmp2=$priority*2
        local tmp2=`printf %0X $tmp2`
        local priority=1$tmp2$tmp1
        
        wan_p=$wan_port
        iptv_portmap=0
        iptv_eg_portmap=0
        
        #wan: user port + security mode
        switch vlan port-attr $wan_port 0
        switch vlan port-mode $wan_port 3
        
        #wan pvid
        switch vlan pvid $wan_port $wan_vid
        
        #bit, port0
        lan_portmap="1"
        itv_portmap="0"
        
        #port1
        if [ "$lan_port1" == "1" ]; then
            lan_portmap="${lan_portmap}0"
            itv_portmap="${itv_portmap}1"
            
            #set iptv+wan port to  user port/security mode
            switch vlan port-attr $lan1_port 0
            switch vlan port-mode $lan1_port 3
            
            switch vlan pvid $lan1_port $iptv_vid
            
            #port 1 priority
            switch reg w 2114 $priority
            
            # +2^1
            cur_val=$(power 2 $lan1_port)
            iptv_portmap=$(($iptv_portmap+$cur_val))
        else
            lan_portmap="${lan_portmap}1"
            itv_portmap="${itv_portmap}0"
            switch vlan pvid $lan1_port $lan_vid
        fi
        
        #port2
        if [ "$lan_port2" == "1" ]; then
            lan_portmap="${lan_portmap}0"
            itv_portmap="${itv_portmap}1"
            
            #set iptv+wan port to  user port/security mode
            switch vlan port-attr $lan2_port 0
            switch vlan port-mode $lan2_port 3
            
            switch vlan pvid $lan2_port $iptv_vid
            
            #port 2 priority
            switch reg w 2214 $priority
            
            # +2^2
            cur_val=$(power 2 $lan2_port)
            iptv_portmap=$(($iptv_portmap+$cur_val))
        else
            lan_portmap="${lan_portmap}1"
            itv_portmap="${itv_portmap}0"
            switch vlan pvid $lan2_port $lan_vid
        fi
        
        #port3-port7
        lan_portmap="${lan_portmap}00010"
        itv_portmap="${itv_portmap}10000"
        
        #set lan/iptv vid
        switch vlan set $lan_fid $lan_vid $lan_portmap
        #switch vlan set $iptv_fid $iptv_vid $itv_portmap
        
        #set iptv vlan egmap
        #switch vlan vid [vlan idx] [active:0|1] [vid] [portMap] [egtagPortMap] [ivl_en] [fid] [stag]
        cur_val=$(power 2 $wan_port)
        iptv_portmap=$((iptv_portmap + $cur_val))
        iptv_eg_portmap=$((iptv_eg_portmap + $cur_val))
        switch vlan vid $iptv_fid 1 $iptv_vid $iptv_portmap $iptv_eg_portmap 1 $iptv_fid 0
    fi
    
    #######################################
    #Step2. internet-data vlan switch set
    #######################################
    if [ "$data_tag" == "1" ]; then
        local DATA_VID
        local tmp
        
        # set priority and vid
        tmp1=`printf %03X $data_vid`
        let tmp2=$data_priority*2
        tmp2=`printf %0X $tmp2`
        DATA_PRI=1$tmp2$tmp1
        
        tmp=`expr 65536 + $data_vid`
        DATA_VID=`printf %x $tmp`
        
        #mainly to set WAN port switch
        if [ "$wan_port" == "3" ]; then
            #switch reg w 2310 81000400
            #switch reg w 2314 $DATA_VID
            
            #set wan port user port/security mode
            switch vlan port-attr $wan_port 0
            switch vlan port-mode $wan_port 3
            
            #set internet-data vlan membership
            switch vlan set $wan_fid $data_vid 00010100
            #set internet-data wan port's pvid
            switch vlan pvid $wan_port $data_vid
            #switch eg-tag for internet-data vlan on wan port for all vlan
            #switch reg w 2304 20ff0003 #port3, Egress VLAN Tag
            switch vlan eg-tag-pcr $wan_port 2
            #set wan priority
            switch reg w 2514 $DATA_PRI
        else
            echo "not support wan port @ $wan_port"
        fi
    fi
    
    switch clear
}

