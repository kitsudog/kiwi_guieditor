package kiwi.guieditor.view {
import flash.display.DisplayObject;
import flash.events.Event;
import flash.geom.Rectangle;

import mx.core.UIComponent;

public class DisplayObjectAdapter extends UIComponent {
    private var displayObject:DisplayObject;
    private var selectedMask:SelectedMask;

    public function DisplayObjectAdapter(displayObject:DisplayObject) {
        this.displayObject = displayObject;
        this.addChild(displayObject);
        mouseChildren = false;
        selectedMask = new SelectedMask();
        updateMask();
        addChildAt(selectedMask, 0);
        unselected();
        addEventListener(Event.RESIZE, onResize, false, 0, true);
        displayObject.addEventListener(Event.RESIZE, onResize, false, 0, true);
        displayObject.addEventListener(Event.CHANGE, onResize, false, 0, true);
    }

    public function updateMask():void {
        // TODO: mask 应该变成一个独立的view
        selectedMask.updateBy(displayObject);
        graphics.clear();
        graphics.beginFill(0xffffff, 0.001);
        graphics.drawRect(displayObject.x, displayObject.y, displayObject.width, displayObject.height);
        graphics.endFill();

    }

    private function onResize(event:Event):void {
        updateMask();
        event.stopImmediatePropagation();
        event.stopPropagation();
    }

    public function selected():void {
        this.selectedMask.visible = true;
    }

    public function unselected():void {
        this.selectedMask.visible = false;
    }

    public function get orig():DisplayObject {
        return displayObject;
    }

    public function get realWidth():Number {
        return displayObject.width;
    }

    public function get realHeight():Number {
        return displayObject.height;
    }

    public function get contentBound():Rectangle {
        return displayObject.getBounds(this);
    }

    override public function set x(value:Number):void {
        throw new Error("不可以改变");
    }

    override public function get x():Number {
        return 0;
    }

    override public function set y(value:Number):void {
        throw new Error("不可以改变");
    }

    override public function get y():Number {
        return 0;
    }

    public function set dragging(dragging:Boolean):void {
        selectedMask.dragging = dragging;
    }
}
}
