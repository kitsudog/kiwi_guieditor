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
    public static const LOAD_LIBRARY:String = "EditorEvent::LOAD_LIBRARY";
    public static const LIBRARY_LOADING:String = "EditorEvent::LIBRARY_LOADING";
    public static const LIBRARY_LOADED:String = "EditorEvent::LIBRARY_LOADED";
    public var data:String;

    public function EditorEvent(type:String, data:String = null) {
        super(type);
        this.data = data;
    }

    override public function clone():Event {
        return new EditorEvent(type, data);
    }
}
}
