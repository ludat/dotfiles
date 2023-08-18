#!/usr/bin/env bash

set -x

pactl set-default-sink bluez_output.D0_8A_55_FD_FB_6F.a2dp-sink


pactl set-default-sink   bluez_output.D0_8A_55_FD_FB_6F.headset-head-unit
pactl set-default-source bluez_input.D0_8A_55_FD_FB_6F.headset-head-unit
