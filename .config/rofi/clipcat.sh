#!/bin/bash

if [ -z "$@" ]; then
    clipcatctl list | awk -F': ' '{printf "%s\0info\x1f%s\n", $2, $1}'
else
    clipcatctl promote $ROFI_INFO > /dev/null 2>&1
fi