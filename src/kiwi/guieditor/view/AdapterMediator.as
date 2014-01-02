/**
 * Created with IntelliJ IDEA.
 * User: Mage
 * Date: 14-1-2
 * Time: 下午1:37
 * To change this template use File | Settings | File Templates.
 */
package kiwi.guieditor.view {
import flash.events.MouseEvent;

import kiwi.guieditor.event.OperateEvent;

import org.robotlegs.mvcs.Mediator;

import spark.filters.GlowFilter;

public class AdapterMediator extends Mediator {
    [Inject]
    public var adapter:DisplayObjectAdapter;

    override public function onRegister():void {
        addViewListener(MouseEvent.ROLL_OVER, handleRoll);
        addViewListener(MouseEvent.ROLL_OUT, handleRoll);
        addViewListener(MouseEvent.MOUSE_DOWN, handleMouse);
        addViewListener(MouseEvent.MOUSE_UP, handleMouse);
    }

    private function handleMouse(event:MouseEvent):void {
        if (event.type == MouseEvent.MOUSE_DOWN) {
            adapter.startDrag();
            dispatch(new OperateEvent(OperateEvent.CLICK, adapter));
        } else if (event.type == MouseEvent.MOUSE_UP) {
            adapter.stopDrag();
        }
    }

    private function handleRoll(event:MouseEvent):void {
        if (event.type == MouseEvent.ROLL_OVER) {
            adapter.filters = [new GlowFilter(0xff0000)];
        } else if (event.type == MouseEvent.ROLL_OUT) {
            adapter.filters = null;
        }
    }
}
}
