# Setup: Garmin Connect IQ für Golf Style by PrayForPar.club

## Aktueller Stand
Das Projekt ist als Connect-IQ-Watchface vorbereitet und wurde lokal mit SDK 9.3.0 für `approachs7042mm` gebaut. `monkeyc.bat` findet aktuell kein globales `java`; der erfolgreiche Build lief direkt über die Java-Runtime aus PDF24.

## Installieren
1. Garmin Developer Account erstellen: https://developer.garmin.com/
2. Connect IQ SDK Manager herunterladen: https://developer.garmin.com/connect-iq/sdk/
3. SDK Manager installieren und aktuelles SDK installieren.
4. In VS Code die Garmin **Monkey C** Extension installieren.
5. In VS Code `Monkey C: Verify Installation` ausführen.
6. Developer Key erzeugen lassen oder vorhandenen Key konfigurieren.

## Projekt öffnen
VS Code-Projektordner:
`E:\Hermes Projekte\Garmin-iQ-DisplayDesign`

## Zielgerät
- Approach S70 42mm
- 390 × 390 px
- Manifest-Produkt-ID: `approachs7042mm`
- SDK-Gerätereferenz vorhanden unter `resources/device-reference/approachs7042mm`.

## Build nach SDK-Installation
Beispiel, sobald `monkeyc` und Developer Key verfügbar sind:

```bash
"C:/Program Files/PDF24/jre/bin/java.exe" -Xms1g -Dfile.encoding=UTF-8 -Dapple.awt.UIElement=true -cp "C:/Users/holge/AppData/Roaming/Garmin/ConnectIQ/Sdks/connectiq-sdk-win-9.3.0-2026-10-20-95888f262/bin/monkeybrains.jar" com.garmin.monkeybrains.Monkeybrains -f "E:/Hermes Projekte/Garmin-iQ-DisplayDesign/monkey.jungle" -o "E:/Hermes Projekte/Garmin-iQ-DisplayDesign/bin/GolfStyle.prg" -y "E:/Hermes Projekte/Garmin-iQ-DisplayDesign/.keys/developer_key.der" -d approachs7042mm -w
```

## Test auf echter S70
1. `.prg` bauen.
2. S70 per USB verbinden.
3. `.prg` in den passenden Garmin Apps/Watchfaces-Ordner kopieren oder über VS Code/SDK deployen.
4. Watchface auf der Uhr aktivieren.

## Kritischer Spike: echte Golfdaten
Zu prüfen:
- Gibt es im Watchface-Kontext Zugriff auf Garmin Golf/HCP/Performance-Daten?
- Falls nicht: alternative Sync-Architektur über Communications/OAuth/Backend oder Companion-App.
- Für Shop-Freigabe muss klar angegeben werden, welche Daten live vom Gerät kommen und welche synchronisiert/konfiguriert werden.
