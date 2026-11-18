import Toybox.Application.WatchFaceConfig;
import Toybox.Lang;
import Toybox.WatchUi;

class GolfStyleDelegate extends WatchUi.WatchFaceDelegate {
    private var _view as GolfStyleView;

    function initialize(view as GolfStyleView) {
        WatchFaceDelegate.initialize();
        _view = view;
    }

    function onWatchFaceConfigEdited(options as {:configId as WatchFaceConfig.Id, :type as WatchFaceConfigType?, :committed as Boolean}) as Void {
        var id = options[:configId] as WatchFaceConfig.Id?;
        if (id != null) {
            var settings = WatchFaceConfig.getSettings(id);
            if (settings != null) {
                _view.updateConfiguration(settings);
            }
        }
    }
}
