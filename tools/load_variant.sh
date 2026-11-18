#!/usr/bin/env bash
set -euo pipefail
variant="${1:-fashion}"
root='E:/Hermes Projekte/Garmin-iQ-DisplayDesign'
sdk='C:/Users/holge/AppData/Roaming/Garmin/ConnectIQ/Sdks/connectiq-sdk-win-9.3.0-2026-10-20-95888f262'
java='C:/Program Files/PDF24/jre/bin/java.exe'
"$root/tools/build_variant.sh" "$variant"
pids=$(ps -W | awk '/shell\.exe|\/java$/ {print $1}')
if [ -n "${pids:-}" ]; then
  kill -9 $pids 2>/dev/null || true
fi
"$java" -classpath "$sdk/bin/monkeybrains.jar" com.garmin.monkeybrains.monkeydodeux.MonkeyDoDeux \
  -f "$root/bin/GolfStyle-${variant}.prg" \
  -d approachs7042mm \
  -s "$sdk/bin/shell.exe"
