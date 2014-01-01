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
import flash.events.MouseEvent;
import flash.filters.GlowFilter;

import kiwi.guieditor.event.OperateEvent;

import mx.core.UIComponent;

public class DisplayObjectAdapter extends UIComponent {
    private var displayObject:DisplayObject;
    private var selectedMask:Shape;

    public function DisplayObjectAdapter(displayObject:DisplayObject) {
        this.displayObject = displayObject;
        this.addChild(displayObject);
        this.mouseChildren = false;
        selectedMask = new Shape();
        selectedMask.graphics.lineStyle(2, 0x00ff00);
        selectedMask.graphics.drawRect(-2, -2, displayObject.width + 4, displayObject.height + 4);
        addChildAt(selectedMask, 0);
        addEventListener(MouseEvent.ROLL_OVER, handleRoll);
        addEventListener(MouseEvent.ROLL_OUT, handleRoll);
        addEventListener(MouseEvent.MOUSE_DOWN, handleMouse);
        addEventListener(MouseEvent.MOUSE_UP, handleMouse);
        unselected();
    }

    private function handleMouse(event:MouseEvent):void {
        if (event.type == MouseEvent.MOUSE_DOWN) {
            startDrag();
            dispatchEvent(new OperateEvent(OperateEvent.CLICK, this));
        } else if (event.type == MouseEvent.MOUSE_UP) {
            stopDrag();
        }
    }

    private function handleRoll(event:MouseEvent):void {
        if (event.type == MouseEvent.ROLL_OVER) {
            this.filters = [new GlowFilter(0xff0000)];
        } else if (event.type == MouseEvent.ROLL_OUT) {
            this.filters = null;
        }
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
