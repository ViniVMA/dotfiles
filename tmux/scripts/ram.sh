#!/bin/bash
page_size=$(sysctl -n vm.pagesize)
total=$(sysctl -n hw.memsize)
used=$(vm_stat | awk -v ps="$page_size" -v total="$total" '
  /Pages free:|Pages inactive:|Pages purgeable:/ {
    gsub(/\./, ""); free += $NF
  }
  END { printf "%.0f", (total - free * ps) / 1073741824 }
')
printf "%s/%.0fG" "$used" "$(echo "$total / 1073741824" | bc)"
