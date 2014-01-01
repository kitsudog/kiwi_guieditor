package kiwi.guieditor.event {
import flash.events.Event;

/**
 * @author zhangming.luo
 */
public class OperateEvent extends Event {
    public static const NEW:String = "OperateEvent::NEW";
    public static const DEL:String = "OperateEvent::DEL";
    public static const RESET:String = "OperateEvent::RESET";
    public var object:*;

    public function OperateEvent(type:String, object:* = null) {
        super(type);
        this.object = object;
    }
}
}
