package kiwi.guieditor.model.config {
import kiwi.guieditor.model.formator.Formator;
import kiwi.guieditor.model.formator.IFormator;

/**
 * @author zhangming.luo
 */
public class PropertyConfig extends BaseConfig {
    public var readOnly:Boolean = false;
    public var def:*;
    public var enumRef:String;
    public var format:String;

    public function get enums():Array {
        return EnumConfig.byName(enumRef).values;
    }

    public function get formator():IFormator {
        return Formator.byName(format);
    }
}
}
