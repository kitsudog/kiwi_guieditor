/**
 * Created with IntelliJ IDEA.
 * User: Mage
 * Date: 14-1-1
 * Time: 下午6:04
 * To change this template use File | Settings | File Templates.
 */
package kiwi.guieditor.view {
import flash.display.DisplayObject;
import flash.display.Shape;
import flash.events.Event;

import mx.core.UIComponent;

public class DisplayObjectAdapter extends UIComponent {
    private var displayObject:DisplayObject;
    private var selectedMask:Shape;

    public function DisplayObjectAdapter(displayObject:DisplayObject) {
        this.displayObject = displayObject;
        this.addChild(displayObject);
        this.mouseChildren = false;
        selectedMask = new Shape();
        updateMask();
        addChildAt(selectedMask, 0);
        unselected();
        displayObject.addEventListener(Event.RESIZE, onResize, false, 0, true);
        displayObject.addEventListener(Event.RESIZE, onResize, false, 0, true);
    }

    public function updateMask():void {
        selectedMask.graphics.clear();
        selectedMask.graphics.lineStyle(2, 0x00ff00);
        selectedMask.graphics.drawRect(-2, -2, displayObject.width + 4, displayObject.height + 4);
        graphics.clear();
        graphics.beginFill(0xffffff, 0.001);
        graphics.drawRect(0, 0, displayObject.width, displayObject.height);
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
}
}
