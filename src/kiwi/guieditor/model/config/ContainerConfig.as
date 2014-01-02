package kiwi.guieditor.model.config {
import kiwi.guieditor.model.Models;

/**
 * @author zhangming.luo
 */
public class ContainerConfig extends ControlConfig {
    public static function byName(name:String):ContainerConfig {
        return Models.byName(ContainerConfig, name);
    }
}
}
