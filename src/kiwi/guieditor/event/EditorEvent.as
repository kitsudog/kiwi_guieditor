package kiwi.guieditor.event {
import flash.events.Event;

/**
 * @author zhangming.luo
 */
public class EditorEvent extends Event {
    public static const NEW:String = "EditorEvent::NEW";
    public static const OPEN:String = "EditorEvent::OPEN";
    public static const SAVE:String = "EditorEvent::SAVE";
    public static const EXPORT:String = "EditorEvent::EXPORT";
    public static const CONTAINER:String = "EditorEvent::CONTAINER";
    public static const EXPORT_ADV:String = "EditorEvent::EXPORT_ADV";
    public static const LOAD_CONFIG:String = "EditorEvent::LOAD_CONFIG";
    public static const APPLY_CONFIG:String = "EditorEvent::APPLY_CONFIG";
    public var data:String;

    public function EditorEvent(type:String, data:String = null) {
        super(type);
        this.data = data;
    }
}
}
