import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class GolfStyleApp extends Application.AppBase {
    private var _editMode as Boolean = false;

    function initialize() {
        AppBase.initialize();
    }

    function onStart(state as Dictionary?) as Void {
        if (state != null) {
            var editorActive = state[:launchedFromWatchFaceSettingsEditor] as Boolean?;
            if (editorActive) {
                _editMode = true;
            }
        }
    }

    function getInitialView() {
        var view = new GolfStyleView(_editMode);
        if (_editMode) {
            return [ view, new GolfStyleDelegate(view) ];
        }
        return [ view ];
    }
}
