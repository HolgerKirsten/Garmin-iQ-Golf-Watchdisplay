# Spike: echte Golfdaten in Connect IQ

## Ziel
Klären, ob ein Connect-IQ-Watchface echte Garmin-Golfdaten laden kann:
- HCP Index
- Durchschnitt der letzten 10–100 Runden
- Score Average
- Fairways Hit
- Greens in Regulation
- Putts/Runde
- Garmin Golf Performance-/Handicap-Statistiken

## Aktuelle Einschätzung
Systemdaten sind realistisch:
- Uhrzeit: `Toybox.System.getClockTime()`
- Akku: `Toybox.System.getSystemStats().battery`
- Herzfrequenz: wahrscheinlich über ActivityMonitor/UserProfile je nach Kontext/Berechtigung

Golfdaten sind unsicher:
- Garmin Golf und Garmin Connect zeigen diese Daten, aber das bedeutet nicht automatisch, dass eine öffentliche Watchface-API existiert.
- Watchfaces haben eingeschränktere API-Möglichkeiten als Watch Apps/Widgets/Data Fields.

## Prüfplan nach SDK-Installation
1. API-Dokumentation lokal nach Golf-/Activity-History-/PersistedContent-Zugriff durchsuchen.
2. Minimalen Testcode bauen, der verfügbare Activity-/History-/Profile-Felder protokolliert.
3. Auf Simulator und S70 testen.
4. Ergebnis klassifizieren:
   - A: Golfdaten direkt im Watchface verfügbar.
   - B: nur allgemeine Aktivitätsdaten verfügbar.
   - C: keine Golfdaten verfügbar; externe Sync-Lösung nötig.

## Fallback falls C
- Watchface zeigt echte Systemdaten + zuletzt synchronisierte Golfwerte.
- Sync später über Garmin Communications + eigenes PrayForPar.club Backend oder Companion-App.
- Shop-Text muss transparent sagen: Golfwerte werden synchronisiert/konfiguriert, nicht direkt aus Garmin Golf gelesen.
