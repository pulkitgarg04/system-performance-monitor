#!/bin/bash

LOG_DIR="./system_monitor"
LOG_FILE="$LOG_DIR/performance_$(date +'%Y-%m-%d_%H-%M-%S').log"

mkdir -p "$LOG_DIR"

log() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

log "------------------------------------------"
log "System Performance Monitoring - $(date)"
log "------------------------------------------"

log "\n--- TOP Command Snapshot ---"
top -b -n 1 | head -n 20 | tee -a "$LOG_FILE"

log "\n--- VMStat Snapshot ---"
vmstat 1 5 | tee -a "$LOG_FILE"

log "\n--- Disk Usage (df -h) ---"
df -h | tee -a "$LOG_FILE"

log "\n--- Memory Usage (free -h) ---"
free -h | tee -a "$LOG_FILE"

log "\n--- Processes Summary (ps aux --sort=-%cpu | head) ---"
ps aux --sort=-%cpu | head -n 10 | tee -a "$LOG_FILE"

log "\nMonitoring Complete: $(date)"
log "------------------------------------------"