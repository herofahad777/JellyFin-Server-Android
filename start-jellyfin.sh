#!/bin/bash

export DOTNET_GCHeapHardLimit=268435456
export DOTNET_GCHeapHardLimitPercent=0
export COMPlus_GCHeapHardLimit=268435456
export COMPlus_GCHeapCount=1
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
export ASPNETCORE_URLS=http://0.0.0.0:8096
export DOTNET_SYSTEM_NET_DISABLEIPV6=1

jellyfin \
  --datadir /root/jellyfin-data \
  --cachedir /root/jellyfin-cache \
  --logdir /root/jellyfin-log \
  --webdir /usr/share/jellyfin/web \
  --nonetchange \
  --ffmpeg /usr/share/jellyfin-ffmpeg/ffmpeg
