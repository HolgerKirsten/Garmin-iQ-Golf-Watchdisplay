# Datenversorgung: letzte Golf-Runde

## Ziel
Die Data-Ansicht soll echte Werte der letzten gespielten Golf-Runde anzeigen:

- HCP Index
- Score
- Putts
- GIR
- Fairways Hit
- Netto Score / Score relativ zu Par, z. B. `Netto 72  Score: E`

## Ergebnis der SDK/API-Prüfung
Im lokal installierten Connect-IQ-SDK 9.3.0 ist keine direkte, dokumentierte Watchface-API für Garmin Golf Scorecards, HCP-Statistiken, Fairways, GIR oder Putts der letzten Runde erkennbar.

Relevante Beobachtungen:
- `Toybox.Activity.Info` liefert aktuelle Aktivitätsdaten, aber keine Golf-Scorecard-Felder wie Putts, Fairways, GIR oder Netto Score.
- `ActivityMonitor` liefert Alltags-/Health-History, keine Golf-Scorecards.
- `PersistedContent` bezieht sich auf gespeicherte Inhalte wie Courses/Routes/Tracks, nicht auf Garmin Golf Scorecards.
- In Garmin-Foren wird ebenfalls diskutiert, dass „Last Round“-Golfdetails wohl nicht klar über Connect IQ dokumentiert sind und ggf. nur über Connect/Golf-Webdaten zugänglich sind.

## Architekturentscheidung
Das Watchface liest reale Golfwerte nicht direkt aus Garmin Golf, sondern aus dem lokalen App-Storage.

Ein separater Sync-Schritt muss die letzten Golfdaten in folgende Keys schreiben:

| Storage Key | Beispiel | Bedeutung |
|---|---:|---|
| `lastRound.hcp` | `14.2` | aktueller HCP Index |
| `lastRound.score` | `84.6` | Score / Brutto-Score der letzten Runde |
| `lastRound.scoreRelation` | `E` | Score relativ zu Par, z. B. E, +3, -1 |
| `lastRound.fairways` | `57%` | Fairways Hit |
| `lastRound.gir` | `42%` | Greens in Regulation |
| `lastRound.putts` | `31.8` | Putts/Runde oder letzter Rundenwert je finaler Definition |
| `lastRound.puttsAvg` | `1.8` | Putts pro Loch, numerisch für Balkenlogik gegen Referenz 2.0 |
| `lastRound.netScore` | `Netto 72  Score: E` | finale Netto-Score-Zeile |

## Aktueller Implementierungsstand
`GolfDataModel.refresh()` ruft jetzt `loadLastRoundFromStorage()` auf und überschreibt die bisherigen Fallbackwerte, sobald die Storage-Keys vorhanden sind.

Ohne Sync bleiben die bisherigen Demo-/Fallbackwerte sichtbar.

## Nächster Schritt
Einen Sync-Prototypen erstellen, der Garmin-Golf-Scorecard-Daten exportiert/verarbeitet und für das Watchface bereitstellt. Mögliche Wege:

1. Manuelle JSON/CSV-Datei aus Garmin Connect/Garmin Golf exportieren und daraus die Storage-Werte erzeugen.
2. Companion-App / Communications-basierter Sync.
3. PrayForPar.club Backend mit Auth/Sync, falls Garmin-Daten zuverlässig extern abgefragt werden können.

Für einen echten Shop-Release muss transparent beschrieben werden, wie die Golfdaten ins Watchface gelangen.
