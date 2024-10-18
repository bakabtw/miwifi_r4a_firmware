#!/bin/sh
append DRIVERS "mt7663"

. /lib/wifi/ralink_common.sh

prepare_mt7663() {
	prepare_ralink_wifi mt7663
}

scan_mt7663() {
	scan_ralink_wifi mt7663 mt7663
}

disable_mt7663() {
	disable_ralink_wifi mt7663
}

enable_mt7663() {
	enable_ralink_wifi mt7663 mt7663
}

detect_mt7663() {
	detect_ralink_wifi mt7663 mt7663
}


