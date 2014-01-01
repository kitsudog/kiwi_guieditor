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
    public var object:*;
    public var pos:Point;

    public function OperateEvent(type:String, object:* = null, pos:Point = null) {
        super(type);
        this.object = object;
        this.pos = pos;
    }

    override public function clone():Event {
        return new OperateEvent(type, object, pos);
    }
}
}
