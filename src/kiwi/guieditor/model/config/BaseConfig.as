package kiwi.guieditor.model.config {
import kiwi.guieditor.model.BaseModel;

/**
 * @author zhangming.luo
 */
internal class BaseConfig extends BaseModel {
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
