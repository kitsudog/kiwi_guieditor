package kiwi.guieditor.model.config {
import kiwi.guieditor.model.Models;
import kiwi.guieditor.model.formator.Formator;
import kiwi.guieditor.model.formator.IFormator;

public class EnumConfig extends BaseConfig {
    public var format:String;
    public var values:Array = [];

    public function get formator():IFormator {
        return Formator.byName(format);
    }

    public static function byName(name:String):EnumConfig {
        return Models.byName(EnumConfig, name);
    }
}
}
