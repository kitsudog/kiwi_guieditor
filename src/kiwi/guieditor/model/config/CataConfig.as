package kiwi.guieditor.model.config {
import kiwi.guieditor.model.Models;

/**
 * @author zhangming.luo
 */
public class CataConfig extends BaseConfig {
    public static function byName(name:String):CataConfig {
        return Models.byName(CataConfig, name);
    }
}
}
