package kiwi.guieditor.view {
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;

import kiwi.guieditor.event.OperateEvent;

import org.robotlegs.mvcs.Mediator;

import spark.filters.GlowFilter;

public class AdapterMediator extends Mediator {
    [Inject]
    public var adapter:DisplayObjectAdapter;
    private var dragging:Boolean = false;
    private var resizing:Boolean = false;
    private var resizeType:String = "hv";
    private var dragType:String = "free";
    private var startDragPos:Point;
    private var startPos:Point;
    private var startSize:Point;

    override public function onRegister():void {
        addViewListener(MouseEvent.MOUSE_DOWN, handleMouse);
        addViewListener(MouseEvent.MOUSE_UP, handleMouse);
    }

    private function handleMouse(event:MouseEvent):void {
        if (event.type == MouseEvent.MOUSE_DOWN) {
            var bound:Rectangle = adapter.contentBound;
            if (bound.contains(event.localX, event.localY)) {
                dragType = "free";
                startDrag();
            } else {
                resizeType = "hv";
                if (event.localX > bound.left && event.localX < bound.right) {
                    resizeType = "v";
                } else if (event.localY > bound.top && event.localY < bound.bottom) {
                    resizeType = "h";
                }
                startResize();
            }
            dispatch(new OperateEvent(OperateEvent.CLICK, adapter));
        } else if (event.type == MouseEvent.MOUSE_UP) {
            stopDrag();
            adapter.dispatchEvent(new Event(Event.RESIZE));
            dispatch(new OperateEvent(OperateEvent.UPDATE, adapter));
        }
    }

    private function handleRoll(event:MouseEvent):void {
        if (event.type == MouseEvent.ROLL_OVER) {
            adapter.filters = [new GlowFilter(0xff0000)];
        } else if (event.type == MouseEvent.ROLL_OUT) {
            adapter.filters = null;
        }
    }

    public function startDrag():void {
        dragging = true;
        startDragPos = new Point(adapter.stage.mouseX, adapter.stage.mouseY);
        startPos = new Point(adapter.orig.x, adapter.orig.y);
        adapter.stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove, false, 0, true);
        adapter.stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
        adapter.dragging = true;
    }

    public function startResize():void {
        resizing = true;
        startDragPos = new Point(adapter.stage.mouseX, adapter.stage.mouseY);
        startSize = new Point(adapter.orig.width, adapter.orig.height);
        adapter.stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove, false, 0, true);
        adapter.stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
        adapter.dragging = true;
    }

    private function onStageMouseUp(event:MouseEvent):void {
        stopDrag();
        stopResize();
        adapter.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
        adapter.stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUp);
        adapter.dragging = false;
    }

    public function stopDrag():void {
        dragging = false;
    }

    public function stopResize():void {
        resizing = false;
    }

    private function onStageMouseMove(event:MouseEvent):void {
        if (resizing) {
            if (resizeType == "hv") {
                if (event.shiftKey) {
                    var delta:Number;
                    if (Math.abs(adapter.stage.mouseX - startDragPos.x) > Math.abs(adapter.stage.mouseY - startDragPos.y)) {
                        delta = (startSize.x + adapter.stage.mouseX - startDragPos.x) / startSize.x;
                    } else {
                        delta = (startSize.y + adapter.stage.mouseY - startDragPos.y) / startSize.y;
                    }
                    adapter.orig.width = startSize.x * delta;
                    adapter.orig.height = startSize.y * delta;
                } else if (event.ctrlKey) {
                    var curPos:Point = adapter.orig.globalToLocal(new Point(adapter.stage.mouseX, adapter.stage.mouseY));
                    if (curPos.x - adapter.orig.x > curPos.y - adapter.orig.y) {
                        adapter.orig.width = curPos.x - adapter.orig.x;
                        adapter.orig.height = curPos.x - adapter.orig.x;
                    } else {
                        adapter.orig.width = curPos.y - adapter.orig.y;
                        adapter.orig.height = curPos.y - adapter.orig.y;
                    }
                } else {
                    adapter.orig.width = startSize.x + adapter.stage.mouseX - startDragPos.x;
                    adapter.orig.height = startSize.y + adapter.stage.mouseY - startDragPos.y;
                }
            } else if (resizeType == "h") {
                adapter.orig.width = startSize.x + adapter.stage.mouseX - startDragPos.x;
            } else if (resizeType == "v") {
                adapter.orig.height = startSize.y + adapter.stage.mouseY - startDragPos.y;
            }
        } else if (dragging) {
            if (event.shiftKey) {
                if (dragType == "free") {
                    if (Math.abs(adapter.stage.mouseX - startDragPos.x) > Math.abs(adapter.stage.mouseY - startDragPos.y)) {
                        dragType = "h";
                    } else {
                        dragType = "v";
                    }
                }
                if (dragType == "h") {
                    adapter.orig.x = startPos.x + adapter.stage.mouseX - startDragPos.x;
                } else if (dragType == "v") {
                    adapter.orig.y = startPos.y + adapter.stage.mouseY - startDragPos.y;
                }
            } else {
                adapter.orig.x = startPos.x + adapter.stage.mouseX - startDragPos.x;
                adapter.orig.y = startPos.y + adapter.stage.mouseY - startDragPos.y;
            }
        }
        event.updateAfterEvent();
    }
}
}
