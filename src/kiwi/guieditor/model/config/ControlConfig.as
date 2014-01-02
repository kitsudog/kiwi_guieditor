package kiwi.guieditor.model.config {
import kiwi.guieditor.model.Models;

/**
 * @author zhangming.luo
 */
public class ControlConfig extends BaseConfig {
    public var cata:String;
    public var $class:String;
    public var factory:*;
    public var property:Array = [];

    public static function byName(name:String):ControlConfig {
        return Models.byName(ControlConfig, name);
    }
}
}
