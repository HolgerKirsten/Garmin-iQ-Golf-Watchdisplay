# Product Brief: Golf Style by PrayForPar.club

## Produktname
**Golf Style by PrayForPar.club**

## Zielgerät
- Garmin Approach S70 42 mm
- Rundes AMOLED-Display
- Zielauflösung: 390 × 390 px
- Connect IQ API-Level laut Garmin-Kompatibilitätsliste: 5.1

## App-Typ
Primäres Ziel: **Connect IQ Watch Face**.

Begründung:
- Uhrzeit, Akku, Herzfrequenz und Nachrichten sollen dauerhaft sichtbar sein.
- Fashion/Sport/Data sollen als Nutzer-konfigurierbare Anzeigeprofile auswählbar sein.

## Designprofile
1. **Fashion**
   - Premium-/Alltagslook
   - wenige zentrale Golfwerte
   - dezente goldene Akku-/Status-Randgrafik

2. **Sport**
   - Performance-orientiert
   - Balken/Trendwerte
   - grüne dynamische Randgrafik

3. **Data**
   - datenorientiert
   - kompakte Kachel-/Dashboard-Ansicht
   - blaue technische Randgrafik

## Gewünschte echte Daten
- aktuelles HCP
- Durchschnittsinformationen der letzten 10 bis max. 100 Runden
- Garmin Handicap-/Golf-Statistiken
- Score
- Fairways getroffen
- Greens in Regulation
- Putts/Runde
- aktuelle Herzfrequenz
- Batterie
- Nachrichtenanzahl

## Kritische technische Annahme
Echte Garmin-Golfdaten sind möglicherweise nicht vollständig direkt aus einem Connect-IQ-Watchface abrufbar. Die Verfügbarkeit muss über das Connect IQ SDK/API-Dokumentation und ggf. Testcode auf der S70 geprüft werden.

## Risikobewertung Datenzugriff
- Systemdaten wie Uhrzeit und Batterie sind für Watchfaces typisch verfügbar.
- Herzfrequenz kann je nach Berechtigung/API verfügbar sein.
- Nachrichtenanzahl kann eingeschränkt sein.
- Garmin Golf/HCP/Performance-Statistiken sind der kritischste Punkt; ggf. sind sie nur in Garmin Golf/Garmin Connect sichtbar, aber nicht als öffentliche Connect-IQ-Watchface-API verfügbar.

## Mögliche Fallback-Architektur
Falls echte Golfdaten nicht direkt verfügbar sind:
1. Watchface zeigt echte Systemdaten + zuletzt synchronisierte Golfwerte.
2. Golfwerte kommen über Nutzer-Settings, Datei-/Companion-Sync oder später Backend.
3. Separate Companion-/Device-App prüft, ob Golfdaten exportiert/synchronisiert werden können.

## Nächste technische Schritte
1. Garmin Connect IQ SDK installieren/prüfen.
2. Watchface-Projekt für Approach S70 42 mm / 390×390 anlegen.
3. Minimal-Watchface mit Uhrzeit, Akku, HR und Nachrichten bauen.
4. API-Spike: prüfen, welche Golf-/Aktivitäts-/Historydaten aus Monkey C verfügbar sind.
5. Layout von 454×454 Mockup auf 390×390 Safe-Area übertragen.
6. Simulator-Test.
7. Side-load `.prg` auf echte S70.
8. Erst danach Shop-Paket und Listing vorbereiten.
