package kiwi.guieditor.view {
import flash.events.Event;
import flash.events.MouseEvent;
import flash.geom.Point;
import flash.geom.Rectangle;

import kiwi.guieditor.event.OperateEvent;

import kiwi.guieditor.event.OperateEvent;

import mx.controls.Menu;
import mx.events.MenuEvent;

import org.robotlegs.mvcs.Mediator;

import spark.filters.GlowFilter;

public class AdapterMediator extends Mediator {
    private static const MENU_HANDLE_MAP:* = {//
        "移除": OperateEvent.DEL//
        , "替换": OperateEvent.REPLACE//
        , "向上": OperateEvent.MOVE_UP//
        , "向下": OperateEvent.MOVE_DOWN//
        , "最上": OperateEvent.MOVE_TOP//
        , "最下": OperateEvent.MOVE_BOTTOM//
        , "复制到右方": OperateEvent.COPY_RIGHT//
        , "复制到下方": OperateEvent.COPY_BOTTOM//
    };
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
        addViewListener(MouseEvent.ROLL_OVER, handleRoll);
        addViewListener(MouseEvent.ROLL_OUT, handleRoll);
        addViewListener(MouseEvent.MOUSE_DOWN, handleMouse);
        addViewListener(MouseEvent.MOUSE_UP, handleMouse);
        addViewListener(MouseEvent.RIGHT_CLICK, handlePopupMenu);
    }

    private function handlePopupMenu(event:MouseEvent):void {
        var menuXML:XML = <root>
            <menuitem label="移除" />
            <menuitem label="替换" />
            <menuitem type="seperator" />
            <menuitem label="向上" />
            <menuitem label="向下" />
            <menuitem label="最上" />
            <menuitem label="最下" />
            <menuitem type="seperator" />
            <menuitem label="复制到右方" />
            <menuitem label="复制到下方" />
        </root>
        var menu:mx.controls.Menu = mx.controls.Menu.createMenu(null, menuXML, false);
        menu.labelField = "@label";
        menu.addEventListener(MenuEvent.ITEM_CLICK, handleMenu);
        menu.show(event.stageX, event.stageY);
    }

    private function handleMenu(event:MenuEvent):void {
        var eventName:String = MENU_HANDLE_MAP[event.label];
        dispatch(new OperateEvent(eventName, adapter));
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
        dispatch(new OperateEvent(OperateEvent.UPDATE));
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
