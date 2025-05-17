#!/bin/bash

LOG_DIR="./system_monitor"
CSV_DIR="$LOG_DIR/csv"
LOG_FILE="$LOG_DIR/performance_$(date +'%Y-%m-%d_%H-%M-%S').log"
CSV_FILE="$CSV_DIR/performance_report.csv"
THRESHOLD_CPU=90
THRESHOLD_MEM=80
THRESHOLD_DISK=10

mkdir -p "$LOG_DIR" "$CSV_DIR"

log() {
    echo -e "$1" | tee -a "$LOG_FILE"
}

log_csv() {
    echo -e "$1" >> "$CSV_FILE"
}

compress_logs() {
    find "$LOG_DIR" -type f -name "*.log" -mtime +7 -print | while read log_file; do
        if [ -f "$log_file" ]; then
            gzip "$(basename "$log_file")"
            log "Compressed $(basename "$log_file")"
    	else
            echo "No log files older than 7 days to compress."
        fi
    done
}

check_cpu() {
    CPU_USAGE=$(top -b -n 1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    log "CPU Usage: $CPU_USAGE%"
    if (( $(echo "$CPU_USAGE > $THRESHOLD_CPU" | bc -l) )); then
        log "High CPU usage detected: $CPU_USAGE% (Threshold: $THRESHOLD_CPU%)"
    fi
}

check_memory() {
    MEM=$(free -m | awk '/^Mem/ {print $3/$2 * 100.0}')
    log "Memory Usage: $MEM%"
    if (( $(echo "$MEM > $THRESHOLD_MEM" | bc -l) )); then
        log "High memory usage detected: $MEM% (Threshold: $THRESHOLD_MEM%)"
    fi
}

check_disk() {
    DISK=$(df / | awk '/\// {print $5}' | sed 's/%//')
    log "Disk Usage: $DISK%"
    if (( DISK > THRESHOLD_DISK )); then
        log "Low disk space detected: $DISK% free (Threshold: $THRESHOLD_DISK%)"
    fi
}

generate_summary() {
    SUMMARY="Summary:\nCPU: $CPU_USAGE%\nMemory: $MEM%\nDisk: $DISK%\n"
    log "\n--- Summary ---\n$SUMMARY"
}

generate_csv_report() {
    if [ ! -f "$CSV_FILE" ]; then
        log_csv "Timestamp,CPU_Usage,Memory_Usage,Disk_Usage"
    fi

    log_csv "$(date),$CPU_USAGE,$MEM,$DISK"
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

log "\n--- More stats: ---"
check_cpu
check_memory
check_disk
generate_summary
compress_logs
generate_csv_report

log "\nMonitoring Complete: $(date)"
log "------------------------------------------"
