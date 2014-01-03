package kiwi.guieditor.model.config {
import kiwi.guieditor.model.formator.Formator;
import kiwi.guieditor.model.formator.IFormator;

/**
 * @author zhangming.luo
 */
public class PropertyConfig extends BaseConfig {
    public static const X:PropertyConfig = new PropertyConfig();
    public static const Y:PropertyConfig = new PropertyConfig();
    {
        X.label = "x";
        X.name = "x";
        X.format = "Int";
        Y.label = "y";
        Y.name = "y";
        Y.format = "Int";
    }
    public var readOnly:Boolean = false;
    public var def:*;
    public var enumRef:String = null;
    public var format:String = null;

    public function get enums():Array {
        return EnumConfig.byName(enumRef).values;
    }

    public function get formator():IFormator {
        return Formator.byName(format);
    }
}
}
