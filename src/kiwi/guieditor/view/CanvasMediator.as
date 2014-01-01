package kiwi.guieditor.view {
import kiwi.guieditor.event.OperateEvent;

import org.robotlegs.mvcs.Mediator;

/**
 * @author zhangming.luo
 */
public class CanvasMediator extends Mediator {
    [Inject]
    public var canvas:Canvas;

    override public function onRegister():void {
        addContextListener(OperateEvent.NEW, onNew);
        addContextListener(OperateEvent.DEL, onDel);
    }

    private function onNew(event:OperateEvent):void {

    }

    private function onDel(event:OperateEvent):void {

    }
}
}
