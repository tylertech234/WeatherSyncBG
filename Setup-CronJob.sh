#!/bin/bash

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SCRIPT_PATH="$SCRIPT_DIR/Set-WeatherWallpaper.ps1"

# Check if cron job already exists
CRON_JOB="0 * * * * pwsh $SCRIPT_PATH"
CRON_FILE="/tmp/weather_cron"

crontab -l > $CRON_FILE 2>/dev/null
grep -qxF "$CRON_JOB" $CRON_FILE || echo "$CRON_JOB" >> $CRON_FILE
crontab $CRON_FILE
rm $CRON_FILE

echo "Cron job created to update wallpaper every hour."
