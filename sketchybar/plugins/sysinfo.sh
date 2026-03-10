#!/bin/bash

NCPU=$(sysctl -n hw.ncpu)
CPU=$(ps -A -o %cpu | awk -v cores="$NCPU" '{s+=$1} END {printf "%.0f%%", s/cores}')

page_size=$(sysctl -n vm.pagesize)
total=$(sysctl -n hw.memsize)
RAM=$(vm_stat | awk -v ps="$page_size" -v total="$total" '
  /Anonymous pages:/ { gsub(/\./, ""); anon = $NF }
  /Pages purgeable:/ { gsub(/\./, ""); purg = $NF }
  /Pages wired down:/ { gsub(/\./, ""); wired = $NF }
  /Pages occupied by compressor:/ { gsub(/\./, ""); comp = $NF }
  END { printf "%.0f/%.0fG", (anon - purg + wired + comp) * ps / 1073741824, total / 1073741824 }
')

sketchybar --set $NAME \
  icon=󰻠 \
  label="${CPU}  󰍛 ${RAM}"
