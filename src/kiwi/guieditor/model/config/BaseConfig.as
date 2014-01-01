package kiwi.guieditor.model.config {
import flash.events.EventDispatcher;

/**
 * @author zhangming.luo
 */
internal class BaseConfig extends EventDispatcher {
    [Bindable]
    public var comment:String;
    [Bindable]
    public var name:String;
    [Bindable]
    public var label:String;
    [Bindable]
    public var icon:String;
}
}
