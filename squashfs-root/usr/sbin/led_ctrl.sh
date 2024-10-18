#!/bin/sh
blink_led_blue() {
    gpio 1 1
    gpio 2 1
    gpio 3 1
    gpio l 5 3
}

blink_led_red() {
    gpio 2 1
    gpio 3 1
    gpio 1 0
}
