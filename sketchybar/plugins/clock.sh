#!/bin/bash

LOCAL="$(date '+%a %b %d %Y %H:%M')"
UTC="$(TZ=UTC date '+%H:%M') UTC"

sketchybar --set $NAME \
  label="${LOCAL}  │  ${UTC}" \
  icon="" icon.color=0xffff9cbe
