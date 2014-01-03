package kiwi.guieditor.view {
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

import mx.managers.CursorManager;

public class SelectedMask extends Sprite {
    private var displayObject:DisplayObject;
    private var _dragging:Boolean;

    public function SelectedMask() {
        addEventListener(MouseEvent.ROLL_OVER, onRoll, false, int.MAX_VALUE);
        addEventListener(MouseEvent.ROLL_OUT, onRoll, false, int.MAX_VALUE);
    }

    private function onRoll(event:MouseEvent):void {
        if (event.type == MouseEvent.ROLL_OVER) {
            if (!_dragging) {
                var bound:Rectangle = new Rectangle(displayObject.x, displayObject.y, displayObject.width, displayObject.height);
                var delta:int = bound.width * 0.05;
                bound.left += delta;
                bound.top += delta;
                bound.right -= delta;
                bound.bottom -= delta;
                if (event.localX > bound.left && event.localX < bound.right) {
                    CursorManager.setCursor(fixv_cursor);
                } else if (event.localY > bound.top && event.localY < bound.bottom) {
                    CursorManager.setCursor(fixh_cursor);
                } else if (event.localX < bound.left && event.localY < bound.top) {
                    CursorManager.setCursor(fixhv_cursor);
                } else if (event.localX > bound.right && event.localY > bound.bottom) {
                    CursorManager.setCursor(fixhv_cursor);
                } else if (event.localX < bound.left && event.localY > bound.bottom) {
                    CursorManager.setCursor(fixvh_cursor);
                } else if (event.localX > bound.right && event.localY < bound.top) {
                    CursorManager.setCursor(fixvh_cursor);
                }
            }
        } else if (event.type == MouseEvent.ROLL_OUT) {
            if (!_dragging) {
                CursorManager.removeAllCursors();
            }
        }
    }

    public function updateBy(displayObject:DisplayObject):void {
        this.displayObject = displayObject;
        graphics.clear();
        graphics.lineStyle(2, 0x00ff00);
        graphics.drawRect(-2 + displayObject.x, -2 + displayObject.y, displayObject.width + 4, displayObject.height + 4);
        graphics.lineStyle(2, 0xffffff);
        graphics.drawRect(displayObject.x - 4, displayObject.y - 4, 4, 4);
        graphics.drawRect(displayObject.x - 4, displayObject.y + displayObject.height, 4, 4);
        graphics.drawRect(displayObject.x + displayObject.width, displayObject.y - 4, 4, 4);
        graphics.drawRect(displayObject.x + displayObject.width, displayObject.y + displayObject.height, 4, 4);
    }

    public function set dragging(value:Boolean):void {
        _dragging = value;
        if (!value) {
            CursorManager.removeAllCursors();
        }
    }
}
}
