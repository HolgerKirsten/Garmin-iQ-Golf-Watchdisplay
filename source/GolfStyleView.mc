import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;
import Toybox.Application.WatchFaceConfig;
import Toybox.WatchUi;

class GolfStyleView extends WatchUi.WatchFace {
    const COLOR_BG = 0x050605;
    const COLOR_WHITE = 0xF8F4EA;
    const COLOR_MUTED = 0x8F918A;
    const COLOR_GOLD = 0xD7B56D;
    const COLOR_GREEN = 0x7FC77B;
    const COLOR_BLUE = 0x7FB3FF;
    const COLOR_RED = 0xFF846F;

    var data;
    var _editMode;
    var _style;

    function initialize(editMode as Boolean) {
        WatchFace.initialize();
        _editMode = editMode;
        _style = getCompiledTestVariant();
        data = new GolfDataModel();
    }

    function getCompiledTestVariant() as Number {
        var variant = WatchUi.loadResource($.Rez.Strings.TestVariant) as String;
        if (variant == "2") {
            return 2;
        } else if (variant == "3") {
            return 3;
        }
        return 1;
    }

    function onLayout(dc as Dc) as Void {
        // Avoid calling WatchFaceConfig during normal simulator launch; some device runtimes expose it only through the watch-face editor.
    }

    function updateConfiguration(config as WatchFaceConfig.Settings) as Void {
        if (config.styleId != null) {
            _style = config.styleId;
        } else {
            _style = 1;
        }
        WatchUi.requestUpdate();
    }

    function onShow() as Void {
    }

    function onUpdate(dc as Dc) as Void {
        data.refresh();
        if (_style == 2) {
            drawSportBackground(dc);
            drawSideStatus(dc, COLOR_RED, COLOR_GREEN);
            drawSport(dc);
        } else if (_style == 3) {
            drawSportBackground(dc);
            drawBatteryArc(dc, COLOR_BLUE, 292, data.batteryArcDegrees());
            drawSideStatus(dc, COLOR_RED, COLOR_BLUE);
            drawData(dc);
        } else {
            drawBackground(dc);
            drawBatteryArc(dc, COLOR_GOLD, 292, data.batteryArcDegrees());
            drawSideStatus(dc, COLOR_RED, COLOR_BLUE);
            drawFashion(dc);
        }
    }

    function drawBackground(dc as Dc) as Void {
        dc.setColor(COLOR_BG, COLOR_BG);
        dc.clear();
        dc.setPenWidth(2);
        dc.setColor(0x222820, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(195, 195, 184);
        dc.setColor(0x172017, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(195, 195, 180);
        dc.setColor(COLOR_BG, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(195, 195, 170);
    }

    function drawSportBackground(dc as Dc) as Void {
        dc.setColor(COLOR_BG, COLOR_BG);
        dc.clear();
        // Sport intentionally draws no full circular background/ring.
    }

    function drawBatteryArc(dc as Dc, color as Number, start as Number, sweep as Number) as Void {
        dc.setPenWidth(8);
        dc.setColor(0x202420, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(195, 195, 181, Graphics.ARC_CLOCKWISE, start, start + 96);
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(195, 195, 181, Graphics.ARC_CLOCKWISE, start, start + sweep);
        dc.setPenWidth(1);
    }

    function drawSportBatteryArc(dc as Dc) as Void {
        // Left-side battery arc only: 100% spans roughly from the "A" in APPROACH
        // on the upper-left bezel down to the "15" marker on the lower-left bezel.
        var start = 132;
        var maxSweep = 104;
        var sweep = (data.battery * maxSweep / 100.0).toNumber();

        dc.setPenWidth(8);
        dc.setColor(0x202420, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(195, 195, 181, Graphics.ARC_CLOCKWISE, start, start + maxSweep);
        dc.setColor(COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        dc.drawArc(195, 195, 181, Graphics.ARC_CLOCKWISE, start, start + sweep);
        dc.setPenWidth(1);
    }

    function drawSideStatus(dc as Dc, hrColor as Number, msgColor as Number) as Void {
        dc.setColor(hrColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(48, 172, Graphics.FONT_XTINY, "HR", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(48, 190, Graphics.FONT_TINY, data.heartRate, Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(msgColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(342, 172, Graphics.FONT_XTINY, "MSG", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(342, 190, Graphics.FONT_TINY, data.messages, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawFashion(dc as Dc) as Void {
        var clock = System.getClockTime();
        var timeText = clock.hour.format("%02d") + ":" + clock.min.format("%02d");
        var dayText = getDayText();
        var dateText = getDayMonthText();

        dc.setColor(COLOR_GOLD, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(195, 195, 145);

        dc.setColor(COLOR_GOLD, Graphics.COLOR_TRANSPARENT);
        dc.drawText(195, 59, Graphics.FONT_XTINY, "PRAYFORPAR", Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(195, 76, Graphics.FONT_NUMBER_MILD, timeText, Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(COLOR_MUTED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(75, 99, Graphics.FONT_XTINY, dayText, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(314, 99, Graphics.FONT_XTINY, dateText, Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(0x17140E, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(195, 203, 43);
        dc.setColor(COLOR_GOLD, Graphics.COLOR_TRANSPARENT);
        dc.drawCircle(195, 203, 43);
        dc.setColor(COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(195, 178, Graphics.FONT_MEDIUM, data.hcp, Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(COLOR_GOLD, Graphics.COLOR_TRANSPARENT);
        dc.drawText(195, 244, Graphics.FONT_XTINY, "HCP INDEX", Graphics.TEXT_JUSTIFY_CENTER);

        drawMetric(dc, 104, 294, data.scoreAvg, "SCORE", COLOR_WHITE, COLOR_MUTED);
        drawMetric(dc, 286, 294, data.gir, "GIR", COLOR_WHITE, COLOR_MUTED);
        drawMetric(dc, 195, 332, data.putts, "PUTTS", COLOR_WHITE, COLOR_MUTED);
    }

    function drawMetric(dc as Dc, x as Number, y as Number, value as String, label as String, valueColor as Number, labelColor as Number) as Void {
        dc.setColor(labelColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y - 24, Graphics.FONT_XTINY, label, Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(valueColor, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y, Graphics.FONT_SMALL, value, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function drawSport(dc as Dc) as Void {
        var clock = System.getClockTime();
        var timeText = clock.hour.format("%02d") + ":" + clock.min.format("%02d");
        var dayText = getDayText();
        var dateText = getDayMonthText();

        // Sport/Performance: distinct from Fashion, inspired by the performance reference.
        drawSportZones(dc);

        dc.setColor(COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        dc.drawText(195, 42, Graphics.FONT_XTINY, "PRAYFORPAR", Graphics.TEXT_JUSTIFY_CENTER);

        drawSportBatteryStatus(dc);

        dc.setColor(COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(83, 76, Graphics.FONT_NUMBER_MILD, timeText, Graphics.TEXT_JUSTIFY_LEFT);

        dc.setColor(COLOR_MUTED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(92, 135, Graphics.FONT_XTINY, dayText + " · " + dateText, Graphics.TEXT_JUSTIFY_LEFT);

        // HCP performance value top-right, no enclosing circle for cleaner sport look.
        dc.setColor(COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(284, 84, Graphics.FONT_MEDIUM, data.hcp, Graphics.TEXT_JUSTIFY_CENTER);
        dc.setColor(COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        dc.drawText(284, 135, Graphics.FONT_XTINY, "HCP INDEX", Graphics.TEXT_JUSTIFY_CENTER);

        drawBar(dc, 92, 218, 230, "SCORING", data.scoreAvg, 95, 68, getScoringColor());
        drawBar(dc, 92, 266, 230, "FAIRWAYS", data.fairways, 110, 57, COLOR_GREEN);
        drawBar(dc, 92, 309, 230, "GIR", data.gir, 38, 42, getGirColor());
        drawBar(dc, 92, 354, 230, "PUTTS 10R", data.puttsAvg, 114, 88, getPuttsColor());
    }

    function drawSportZones(dc as Dc) as Void {
        dc.setColor(0x06100A, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon([[60, 326], [184, 252], [336, 356], [78, 362]]);
        dc.setColor(0x07131C, Graphics.COLOR_TRANSPARENT);
        dc.fillPolygon([[186, 260], [326, 206], [350, 340], [254, 336]]);
    }

    function drawSportGauge(dc as Dc) as Void {
        // Reserved for future sport performance gauge.
    }

    function drawSportBatteryStatus(dc as Dc) as Void {
        var batteryText = data.battery.toNumber().format("%d") + "%";
        var fillWidth = (data.battery * 14 / 100.0).toNumber();

        dc.setColor(COLOR_GREEN, Graphics.COLOR_TRANSPARENT);
        dc.drawText(39, 98, Graphics.FONT_XTINY, batteryText, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawRectangle(47, 124, 18, 10);
        dc.fillRectangle(66, 127, 3, 4);
        dc.fillRectangle(49, 126, fillWidth, 6);
    }

    function drawBar(dc as Dc, x as Number, y as Number, w as Number, label as String, value as String, valueOffset as Number, pct as Number, barColor as Number) as Void {
        dc.setColor(COLOR_MUTED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x, y - 31, Graphics.FONT_XTINY, label, Graphics.TEXT_JUSTIFY_LEFT);
        dc.setColor(COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x + valueOffset, y - 31, Graphics.FONT_XTINY, value, Graphics.TEXT_JUSTIFY_LEFT);
        dc.setPenWidth(8);
        dc.setColor(0x243024, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(x, y, x + w, y);
        dc.setColor(barColor, Graphics.COLOR_TRANSPARENT);
        dc.drawLine(x, y, x + (w * pct / 100), y);
        if (barColor != COLOR_RED) {
            dc.setColor(COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
            dc.setPenWidth(3);
            dc.drawLine(x, y, x + (w * pct / 100), y);
        }
        dc.setPenWidth(1);
    }

    function getPuttsColor() as Number {
        if (data.puttsAvgValue > 2.0) {
            return COLOR_RED;
        }
        return COLOR_GREEN;
    }

    function getScoringColor() as Number {
        if (!data.scoringMatchesEven) {
            return COLOR_RED;
        }
        return COLOR_GREEN;
    }

    function getGirColor() as Number {
        // GIR below 50% is a warning state.
        return COLOR_RED;
    }

    function drawData(dc as Dc) as Void {
        var clock = System.getClockTime();
        var timeText = clock.hour.format("%02d") + ":" + clock.min.format("%02d");
        var dayText = getDayText();
        var dateText = getDayMonthText();

        dc.setColor(COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(195, 29, Graphics.FONT_XTINY, "PRAYFORPAR", Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(195, 46, Graphics.FONT_NUMBER_MILD, timeText, Graphics.TEXT_JUSTIFY_CENTER);

        dc.setColor(COLOR_MUTED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(75, 84, Graphics.FONT_XTINY, dayText, Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(314, 84, Graphics.FONT_XTINY, dateText, Graphics.TEXT_JUSTIFY_CENTER);

        drawTileInline(dc, 92, 113, 206, 50, "HCP INDEX", data.hcp, 126);
        drawTile(dc, 92, 157, 96, 50, "SCORE", data.scoreAvg);
        drawTile(dc, 202, 157, 96, 50, "PUTTS", data.putts);
        drawTile(dc, 92, 217, 96, 50, "GIR", data.gir);
        drawTile(dc, 202, 217, 96, 50, "FW HIT", data.fairways);
        drawTileSmallValue(dc, 92, 282, 206, 42, "LETZTE RUNDE", data.netScore);
    }

    function drawTile(dc as Dc, x as Number, y as Number, w as Number, h as Number, label as String, value as String) as Void {
        dc.setColor(COLOR_BG, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(x, y, w, h);
        dc.setColor(COLOR_BG, Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(x, y, w, h);
        dc.setColor(COLOR_MUTED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x + 8, y + 8, Graphics.FONT_XTINY, label, Graphics.TEXT_JUSTIFY_LEFT);
        dc.setColor(COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x + 8, y + 27, Graphics.FONT_TINY, value, Graphics.TEXT_JUSTIFY_LEFT);
    }

    function drawTileInline(dc as Dc, x as Number, y as Number, w as Number, h as Number, label as String, value as String, valueOffset as Number) as Void {
        dc.setColor(COLOR_BG, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(x, y, w, h);
        dc.setColor(COLOR_BG, Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(x, y, w, h);
        dc.setColor(COLOR_MUTED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x + 8, y + 17, Graphics.FONT_XTINY, label, Graphics.TEXT_JUSTIFY_LEFT);
        dc.setColor(COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x + valueOffset, y + 17, Graphics.FONT_XTINY, value, Graphics.TEXT_JUSTIFY_LEFT);
    }

    function drawTileSmallValue(dc as Dc, x as Number, y as Number, w as Number, h as Number, label as String, value as String) as Void {
        dc.setColor(COLOR_BG, Graphics.COLOR_TRANSPARENT);
        dc.fillRectangle(x, y, w, h);
        dc.setColor(COLOR_BG, Graphics.COLOR_TRANSPARENT);
        dc.drawRectangle(x, y, w, h);
        dc.setColor(COLOR_MUTED, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x + 8, y + 7, Graphics.FONT_XTINY, label, Graphics.TEXT_JUSTIFY_LEFT);
        dc.setColor(COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(x + 8, y + 30, Graphics.FONT_XTINY, value, Graphics.TEXT_JUSTIFY_LEFT);
    }

    function getDateText() as String {
        var info = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var day = info.day.format("%02d");
        var month = info.month.format("%02d");
        return Lang.format("$1$ - $2$.$3$", [getWeekdayText(info.day_of_week), day, month]);
    }

    function getDayText() as String {
        var info = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        return getWeekdayText(info.day_of_week);
    }

    function getDayMonthText() as String {
        var info = Gregorian.info(Time.now(), Time.FORMAT_SHORT);
        var day = info.day.format("%02d");
        var month = info.month.format("%02d");
        return Lang.format("$1$.$2$", [day, month]);
    }

    function getWeekdayText(dayOfWeek as Object) as String {
        switch (dayOfWeek) {
            case Gregorian.DAY_MONDAY:
                return "Mo";
            case Gregorian.DAY_TUESDAY:
                return "Di";
            case Gregorian.DAY_WEDNESDAY:
                return "Mi";
            case Gregorian.DAY_THURSDAY:
                return "Do";
            case Gregorian.DAY_FRIDAY:
                return "Fr";
            case Gregorian.DAY_SATURDAY:
                return "Sa";
            case Gregorian.DAY_SUNDAY:
                return "So";
        }
        return "--";
    }

    function onHide() as Void {
    }
}
