#!/usr/bin/env bash
set -euo pipefail
variant="${1:-fashion}"
case "$variant" in
  fashion) style=1 ;;
  sport) style=2 ;;
  data) style=3 ;;
  *) echo "Usage: $0 [fashion|sport|data]" >&2; exit 2 ;;
esac
root='E:/Hermes Projekte/Garmin-iQ-DisplayDesign'
sdk='C:/Users/holge/AppData/Roaming/Garmin/ConnectIQ/Sdks/connectiq-sdk-win-9.3.0-2026-10-20-95888f262'
java='C:/Program Files/PDF24/jre/bin/java.exe'
mkdir -p "$root/bin"
cat > "$root/resources/strings/test_variant.xml" <<XML
<resources>
    <string id="TestVariant">${style}</string>
</resources>
XML
"$java" -Xms1g -Dfile.encoding=UTF-8 -Dapple.awt.UIElement=true \
  -cp "$sdk/bin/monkeybrains.jar" com.garmin.monkeybrains.Monkeybrains \
  -f "$root/monkey.jungle" \
  -o "$root/bin/GolfStyle-${variant}.prg" \
  -y "$root/.keys/developer_key.der" \
  -d approachs7042mm \
  -w
cp "$root/bin/GolfStyle-${variant}.prg" "$root/bin/GolfStyle.prg"
echo "$root/bin/GolfStyle-${variant}.prg"
