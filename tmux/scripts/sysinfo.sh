#!/bin/bash
fastfetch --structure CPUUsage:Memory:Battery --format json 2>/dev/null | jq -r '
  (.[0].result | add / length | round | tostring) + "%" as $cpu |
  ((.[1].result.used / 1073741824 * 10 | round / 10 | tostring) + "/" + (.[1].result.total / 1073741824 | round | tostring) + "G") as $ram |
  (.[2].result[0].capacity | round | tostring) + "%" as $bat |
  "󰻠 " + $cpu + "  󰒋 " + $ram + "  󰁹 " + $bat
'
