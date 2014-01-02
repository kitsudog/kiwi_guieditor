package kiwi.guieditor.model.config {
import kiwi.guieditor.model.Models;

/**
 * @author zhangming.luo
 */
public class LibConfig extends BaseConfig {
    public var src:String;
    public var $loaded:Boolean = false;
    public var $loading:Boolean = false;

    public static function byName(name:String):LibConfig {
        return Models.byName(LibConfig, name);
    }
}
}
