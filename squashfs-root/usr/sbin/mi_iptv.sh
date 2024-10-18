#!/bin/sh
# mi_iptv


mi_iptv_lock="/var/run/mi_iptv.lock"

log() {
    echo "mi_iptv: $1" > /dev/console
    logger -t mi_iptv "$1"
}

run_with_lock()
{
    {
        log "$$, ====== TRY locking......"
        flock -x -w 60 1000
        [ $? -eq "1" ] && { log "$$, ===== lock failed. exit 1" ; exit 1 ; }
        log "$$, ====== GET lock to RUN."
        $@
        flock -u 1000 #??
        log "$$, ====== END lock to RUN."
    } 1000<>$mi_iptv_lock
}

verify_all_vlan_id(){}
setup_switch(){}

setup_iptv_for_switch(){
    
    #make sure lan/wan with diff vid with iptv
    . /lib/network/mi_iptv_switch.sh
    verify_all_vlan_id
    
    #include setup_switch script
    . /lib/network/switch.sh
    setup_switch
}

run_with_lock setup_iptv_for_switch
return 0
