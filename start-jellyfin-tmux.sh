#!/bin/bash

SESSION="jellyfin"

# If tmux session exists, attach instead of starting another
if tmux has-session -t "$SESSION" 2>/dev/null; then
    echo "Jellyfin is already running in tmux session: $SESSION"
    echo "Attaching..."
    tmux attach -t "$SESSION"
    exit 0
fi

echo "Starting Jellyfin in tmux session: $SESSION"

tmux new -d -s "$SESSION" "
export DOTNET_GCHeapHardLimit=268435456
export DOTNET_GCHeapHardLimitPercent=0
export COMPlus_GCHeapHardLimit=268435456
export COMPlus_GCHeapCount=1
export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
export ASPNETCORE_URLS=http://0.0.0.0:8096
export DOTNET_SYSTEM_NET_DISABLEIPV6=1

exec jellyfin \
  --datadir /root/jellyfin-data \
  --cachedir /root/jellyfin-cache \
  --logdir /root/jellyfin-log \
  --webdir /usr/share/jellyfin/web \
  --nonetchange \
  --ffmpeg /usr/share/jellyfin-ffmpeg/ffmpeg
"

echo "Jellyfin started."
echo "Attach with: tmux attach -t $SESSION"
