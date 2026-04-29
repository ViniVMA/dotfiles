#!/bin/bash
top -l 2 -n 0 -s 1 | grep "CPU usage" | tail -1 | awk '{gsub(/%/,""); printf "%.0f%%", $3+$5}'
