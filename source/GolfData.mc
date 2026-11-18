import Toybox.System;
import Toybox.ActivityMonitor;
import Toybox.Application.Storage;

class GolfDataModel {
    var style;
    var hcp;
    var scoreAvg;
    var lastScoreRelation;
    var scoringMatchesEven;
    var fairways;
    var gir;
    var putts;
    var puttsAvg;
    var puttsAvgValue;
    var hcpTrend;
    var netScore;
    var heartRate;
    var messages;
    var battery;

    function initialize() {
        // Version 0 scaffold: Systemdaten live, Golfwerte noch als lokale Fallbackwerte.
        // Nächster Spike prüft, ob Garmin Golf/HCP-Statistiken per CIQ API erreichbar sind.
        style = "fashion";
        hcp = "14.2";
        scoreAvg = "84.6";
        lastScoreRelation = "E";
        scoringMatchesEven = true;
        fairways = "57%";
        gir = "42%";
        putts = "31.8";
        puttsAvg = "1.8";
        puttsAvgValue = 1.8;
        hcpTrend = "Stable";
        netScore = "Netto 72  Score: E";
        heartRate = "--";
        messages = "3";
        battery = 82.0;
    }

    function refresh() {
        loadLastRoundFromStorage();

        var stats = System.getSystemStats();
        if (stats != null && stats.battery != null) {
            battery = stats.battery;
        }

        // Heart-rate availability differs by device state and permissions.
        // Use the latest heart-rate history sample when available; keep safe fallback otherwise.
        try {
            var iterator = ActivityMonitor.getHeartRateHistory(null, true);
            var sample = iterator.next();
            if (sample != null && sample.heartRate != null && sample.heartRate != ActivityMonitor.INVALID_HR_SAMPLE) {
                heartRate = sample.heartRate.format("%d");
            }
        } catch (ex) {
            heartRate = "--";
        }
    }

    function batteryArcDegrees() {
        return (battery * 0.95).toNumber();
    }

    function loadLastRoundFromStorage() as Void {
        // Real Golf/Garmin scorecard data is expected to be synchronized into app storage.
        // A later sync component should write these keys after reading the latest Garmin Golf round.
        var storedHcp = Storage.getValue("lastRound.hcp");
        if (storedHcp instanceof String) {
            hcp = storedHcp;
        }

        var storedScore = Storage.getValue("lastRound.score");
        if (storedScore instanceof String) {
            scoreAvg = storedScore;
        }

        var storedScoreRelation = Storage.getValue("lastRound.scoreRelation");
        if (storedScoreRelation instanceof String) {
            lastScoreRelation = storedScoreRelation;
            scoringMatchesEven = (lastScoreRelation == "E");
        }

        var storedFairways = Storage.getValue("lastRound.fairways");
        if (storedFairways instanceof String) {
            fairways = storedFairways;
        }

        var storedGir = Storage.getValue("lastRound.gir");
        if (storedGir instanceof String) {
            gir = storedGir;
        }

        var storedPutts = Storage.getValue("lastRound.putts");
        if (storedPutts instanceof String) {
            putts = storedPutts;
        }

        var storedPuttsAvg = Storage.getValue("lastRound.puttsAvg");
        if (storedPuttsAvg instanceof Float) {
            puttsAvgValue = storedPuttsAvg;
            puttsAvg = puttsAvgValue.format("%.1f");
        } else if (storedPuttsAvg instanceof Number) {
            puttsAvgValue = storedPuttsAvg.toFloat();
            puttsAvg = puttsAvgValue.format("%.1f");
        }

        var storedNetScore = Storage.getValue("lastRound.netScore");
        if (storedNetScore instanceof String) {
            netScore = storedNetScore;
        }
    }
}
