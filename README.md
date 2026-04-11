# Jellyfin Server on Android (Termux + proot)

This guide explains how to run a **Jellyfin media server on an Android phone** using **Termux + proot Linux**.

## Tested
* Android 14
* 8GB RAM
* Dimensity 6080

## Result
* Worked Smoothly
* Startup time 3 Minites

---

## 📌 Requirements

* Android phone (Minimum - 4 GB Ram)
* Termux (recommended from F‑Droid)
* At least 3–4 GB free storage
* Termux Must have full file access
  
---

##  1. Setup (Termux)

### 1.1 Update Termux

```bash
pkg update && pkg upgrade -y
```

### 1.2 Install proot and OpenSSH

```bash
pkg install proot-distro openssh -y
```

### 1.3 Give Storage Permission

```bash
termux-setup-storage
```

Allow the permission prompt.

### 1.4 Enable Termux Wake Lock

```bash
termux-wake-lock
```

Prevents the session from stopping.

---

##  2. Install Linux (Debian)

> Ubuntu is not used here because of LTS Issues. As proot-distro only installs the latest version of ubuntu and that causes installation issue with jellyfin.

### Install Debian (recommended)

```bash
proot-distro install debian
proot-distro login debian
```
w
### Inside Linux environment

```bash
apt update && apt upgrade -y
apt install curl wget sudo nano tmux -y
```

---

##  3. Install Jellyfin

Inside your Linux environment:

```bash
apt install jellyfin -y
```

Jellyfin will be installed but **do not start it yet**.

---

##  4. Important Fixes (Required for Android/Termux)

Jellyfin needs special environment settings to run in proot.

Create data folders:

```bash
mkdir -p /root/jellyfin-data /root/jellyfin-cache /root/jellyfin-log
```

---

##  5. Running Jellyfin with tmux (Working Command with environment variables Set)

screen failed to work with [start-jellyfin.sh](start-jellyfin.sh)

``` 
chmod -x [start-jellyfin-tmux.sh](start-jellyfin-tmux.sh)
```

Run this script [start-jellyfin-tmux.sh](start-jellyfin-tmux.sh)
```
./start-jellyfin-tmux.sh 
```


OR

Use this exact command:

```bash
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
```

### Why this works

* `--nonetchange` avoids a crash caused by blocked network monitoring in proot
* Environment variables limit .NET memory usage

The Environment Variables need to be set everytime you run the command.
  
---

##  6. Access Jellyfin

Open your browser on the phone:

```
http://127.0.0.1:8096
```

OR
Your device IPv4
```
http://192.168.XXX.XXX:8096
```


If the web interface loads, Jellyfin is running correctly.

---


##  Troubleshooting

### ❌ `GC heap initialization failed`

Increase or adjust memory limits using the environment variables above.

### ❌ `NetworkChange.CreateSocket Permission denied`

Always run Jellyfin with:

```
--nonetchange
```

### ❌ Cannot open web UI

Check if Jellyfin is listening:

```bash
ss -tuln | grep 8096
```

### To check if jellyfin is running or not

```bash
ps aux | grep jellyfin
```

### To kill a session from tmux

```bash
tmux kill-session -t jellyfin
```

### To Kill jellyfin session from outside of tmux
```bash
pkill -f jellyfin
```

### To see tmux sessions list
```bash
tmux ls
```

### Connect to tmux session
```bash
tmux attach -t jellyfin
```

### To access Phone Storage
```bash
cd /storage/emulated/0
ls
```

---

##  Notes

* Keep the terminal session open while Jellyfin runs
* For LAN access, change bind address later if needed
* If you don't want to run usin tmux then use [start-jellyfin.sh](start-jellyfin.sh)
* To detach from tmux session **Ctrl + B, then D**

---

Happy self‑hosting!
