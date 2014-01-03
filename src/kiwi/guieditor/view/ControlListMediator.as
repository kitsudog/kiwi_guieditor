package kiwi.guieditor.view {
import kiwi.guieditor.event.OperateEvent;

import org.robotlegs.mvcs.Mediator;

public class ControlListMediator extends Mediator {
    [Inject]
    public var list:ControlList;

    override public function onRegister():void {
        addViewListener(OperateEvent.NEW, dispatch);
    }
}
}
