# Golf Style by PrayForPar.club (`Garmin-iQ-DisplayDesign`)

Entwicklung und UI-Architektur für das Garmin Connect IQ Watch Face **Golf Style by PrayForPar.club**, optimiert für das runde 390 × 390 px AMOLED-Display der **Garmin Approach S70 (42 mm)** (Connect IQ API-Level 5.1)[cite: 1].

## Konzept & Anzeigeprofile
Das Watch Face kombiniert dauerhaft sichtbare Systemdaten (Uhrzeit, Akkustand, Herzfrequenz, Benachrichtigungen) mit golf-spezifischen Performance-Kennzahlen[cite: 1]. Über die App-Einstellungen stehen drei visuell getrennte Designprofile zur Auswahl[cite: 1]:

* **Fashion:** Premium-Alltagslook mit reduzierten Golf-Kernwerten und dezenter goldener Akku-/Status-Randgrafik[cite: 1].
* **Sport:** Performance-Ansicht mit Trend- und Balkendarstellungen sowie dynamischer grüner Randgrafik[cite: 1].
* **Data:** Kompaktes Dashboard-Layout mit hoher Informationsdichte und technischer blauer Randgrafik[cite: 1].

## Geplante Datenintegration & Architektur
Neben den Systemmetriken bildet das Display folgende Golf-Statistiken ab (Durchschnittswerte der letzten 10 bis 100 Runden)[cite: 1]:
* Aktuelles Handicap (HCP) & Score[cite: 1]
* Fairways in Regulation (FIR) & Greens in Regulation (GIR)[cite: 1]
* Putts pro Runde[cite: 1]

**Technische Besonderheit (API-Scope & Fallback):**
Da Garmin Golf- und HCP-Statistiken über die öffentliche Monkey-C-Watchface-API nicht zwingend direkt auslesbar sind, verfolgt das Projekt einen zweistufigen Ansatz[cite: 1]:
1. **API-Spike:** Validierung der nativ verfügbaren Golf-, Aktivitäts- und History-APIs unter Connect IQ 5.1[cite: 1].
2. **Fallback-Sync:** Bereitstellung der Golf-Kennzahlen über Nutzer-Settings, eine Companion-Logik oder Backend-Synchronisation, falls ein direkter Watchface-Zugriff systemseitig blockiert ist[cite: 1].

## Entwicklungs-Roadmap
- [ ] Setup der Connect IQ SDK Umgebung (API-Level 5.1) & Projektstruktur für `approachs7042mm` (390×390)[cite: 1]
- [ ] Basis-Watchface implementieren (Uhrzeit, Akku, HR, Notifications)[cite: 1]
- [ ] API-Spike zur Prüfung des Zugriffs auf Garmin-Golf-/Rundendaten[cite: 1]
- [ ] Portierung der UI-Layouts (von 454×454 Mockup auf 390×390 Safe-Area) für Fashion, Sport und Data[cite: 1]
- [ ] Simulator-Validierung & Side-Load-Test (`.prg`) auf der physischen Approach S70[cite: 1]
- [ ] Vorbereitung des Connect IQ Store-Pakets[cite: 1]

## Lokale Entwicklungsumgebung
* **IDE:** Visual Studio Code inkl. *Monkey C* Extension
* **SDK:** Garmin Connect IQ SDK (Ziel-API 5.1)[cite: 1]
* **Zielgerät:** Garmin Approach S70 42 mm (`390 × 390 px`, AMOLED)[cite: 1]
