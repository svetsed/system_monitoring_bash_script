#!/bin/bash

# 1. Настройка директории и лог-файла
LOG_DIR="/var/log/monitoring"
mkdir -p "$LOG_DIR"
chmod 755 "$LOG_DIR"

LOG_FILE="$LOG_DIR/system_monitoring_$(date +\%Y\%m\%d).log"
sudo touch "$LOG_FILE"
echo "" >> "$LOG_FILE"
echo "======== $(date) ========" >> "$LOG_FILE"

# 2. Мониторинг CPU (только если нагрузка > 50%)
echo "🔹 CPU Load (filtered > 50%):" >> "$LOG_FILE"
CPU_LOAD=$(top -bn1 | grep "%Cpu(s)" | awk '{print int($2)}')
if [ "$CPU_LOAD" -gt 50 ]; then
    top -bn1 | head -5 >> "$LOG_FILE"
    echo "CPU load is high, "$CPU_LOAD"%!!!" >> "$LOG_FILE"
else
    echo "CPU load is normal, "$CPU_LOAD"%" >> "$LOG_FILE"
fi
echo "" >> "$LOG_FILE"

# 3. Проверка диска (только разделы > 50% заполнения)
echo "🔹 Disk Usage (filtered > 20%):" >> "$LOG_FILE"
df -h | awk 'NR==1 || $5 > "20%" {print}' >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

# 4. Проверка сети (ping + netstat + интерфейсы + маршруты)
echo "🔹 Network Check (ping google.com):" >> "$LOG_FILE"
if ping -c 4 google.com >/dev/null 2>&1; then
    echo " Ping: OK (0% packet loss)" >> "$LOG_FILE"
else
    echo " Ping: FAILED (packet loss detected)" >> "$LOG_FILE"
    echo "Detailed ping results:" >> "$LOG_FILE"
    ping -c 4 google.com >> "$LOG_FILE" 2>&1
fi
echo "" >> "$LOG_FILE"

echo "🔹 Listening Ports:" >> "$LOG_FILE"
netstat -tuln | grep LISTEN | awk '{printf "%-10s %-15s %-10s\n", $1, $4, $6}' >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "🔹 Active connections:" >> "$LOG_FILE"
netstat -tunp | grep ESTABLISHED >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "🔹 Network Interfaces:" >> "$LOG_FILE"
ip -br a >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "🔹 Routing Table:" >> "$LOG_FILE"
ip route >> "$LOG_FILE"
echo "" >> "$LOG_FILE"

echo "====================== END ======================" >> "$LOG_FILE"

echo "Monitoring completed. Log saved to "$LOG_FILE""

# Ротация логов (храним 10 дней)
find "$LOG_DIR" -name "*.log" -mtime +10 -delete