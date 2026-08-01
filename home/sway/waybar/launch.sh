#!/usr/bin/env bash
killall -q waybar
waybar >>/tmp/waybar.log 2>&1 &
