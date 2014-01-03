package kiwi.guieditor.view {
import flash.events.Event;

import kiwi.guieditor.event.OperateEvent;
import kiwi.guieditor.model.ImplInfo;

import mx.core.IVisualElement;

import org.robotlegs.mvcs.Mediator;

/**
 * @author zhangming.luo
 */
public class CanvasMediator extends Mediator {
    [Inject]
    public var canvas:Canvas;

    override public function onRegister():void {
        // 转发view事件
        addViewListener(OperateEvent.NEW, dispatch);
        addViewListener(OperateEvent.DEL, dispatch);
        // 接收事件
        addContextListener(OperateEvent.ADD, onAdd);
        addContextListener(OperateEvent.DEL, onDel);
        addContextListener(OperateEvent.SELECTED, onSelected);
        addContextListener(OperateEvent.UNSELECTED, onUnselected);
    }

    private function onUnselected(event:OperateEvent):void {
        var impl:ImplInfo = ImplInfo(event.object);
        impl.dos.unselected();
    }

    private function onSelected(event:OperateEvent):void {
        var impl:ImplInfo = ImplInfo(event.object);
        impl.dos.selected();
    }

    private function onAdd(event:OperateEvent):void {
        var obj:DisplayObjectAdapter = event.object;
        if (event.pos) {
            obj.orig.x = event.pos.x;
            obj.orig.y = event.pos.y;
            obj.updateMask();
        }
        canvas.container.addElement(obj);
        dispatch(new OperateEvent(OperateEvent.CLICK, obj));
    }

    private function onDel(event:OperateEvent):void {
        var obj:IVisualElement = event.object;
        canvas.container.removeElement(obj);
    }
}
}
