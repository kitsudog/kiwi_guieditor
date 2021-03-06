package kiwi.guieditor.view {
import kiwi.guieditor.event.EditorEvent;

import org.robotlegs.mvcs.Mediator;

public class MainMediator extends Mediator {
    [Inject]
    public var main:Main;

    private static var loadingMask:LoadingMask = new LoadingMask();

    public override function onRegister():void {
        addContextListener(EditorEvent.LIBRARY_LOADING, onLoad);
        addContextListener(EditorEvent.LIBRARY_LOADED, onLoad);
    }

    private function onLoad(e:EditorEvent):void {
        if (e.type == EditorEvent.LIBRARY_LOADING) {
            main.addElement(loadingMask);
        } else if (e.type == EditorEvent.LIBRARY_LOADED) {
            main.removeElement(loadingMask);
        }
    }
}
}
