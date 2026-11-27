#!/usr/bin/env bash
pkill waybar
waybar >>/tmp/waybar.log 2>&1 &
