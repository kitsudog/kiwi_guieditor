package kiwi.guieditor.model.config {
/**
 * @author zhangming.luo
 */
public class ControleConfig extends BaseConfig {
    public var cata:String;
    public var $class:String;
    public var factory:*;
    public var property:Vector.<PropertyConfig> = new Vector.<PropertyConfig>();
}
}
