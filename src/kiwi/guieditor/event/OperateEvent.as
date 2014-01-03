package kiwi.guieditor.event {
import flash.events.Event;
import flash.geom.Point;

/**
 * @author zhangming.luo
 */
public class OperateEvent extends Event {
    public static const NEW:String = "OperateEvent::NEW";
    public static const ADD:String = "OperateEvent::ADD";
    public static const DEL:String = "OperateEvent::DEL";
    public static const RESET:String = "OperateEvent::RESET";
    public static const CLICK:String = "OperateEvent::CLICK";
    public static const SELECTED:String = "OperateEvent::SELECTED";
    public static const UNSELECTED:String = "OperateEvent::UNSELECTED";
    public static const UPDATE:String = "OperateEvent::UPDATE";
    public static const REPLACE:String = "OperateEvent::REPLACE";
    public static const MOVE_UP:String = "OperateEvent::MOVE_UP";
    public static const MOVE_DOWN:String = "OperateEvent::MOVE_DOWN";
    public static const MOVE_TOP:String = "OperateEvent::MOVE_TOP";
    public static const MOVE_BOTTOM:String = "OperateEvent::MOVE_BOTTOM";
    public static const COPY_RIGHT:String = "OperateEvent::COPY_RIGHT";
    public static const COPY_BOTTOM:String = "OperateEvent::COPY_BOTTOM";
    public var object:*;
    public var pos:Point;

    public function OperateEvent(type:String, object:* = null, pos:Point = null) {
        super(type, true);
        this.object = object;
        this.pos = pos;
    }

    override public function clone():Event {
        return new OperateEvent(type, object, pos);
    }
}
}
