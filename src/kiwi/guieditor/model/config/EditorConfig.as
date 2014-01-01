package kiwi.guieditor.model.config {
import flash.filesystem.File;

/**
 * @author zhangming.luo
 */
public class EditorConfig {
    public var $loadedFile:Vector.<File> = new Vector.<File>();
    public var app:Vector.<AppConfig> = new Vector.<AppConfig>();
    public var lib:Vector.<LibConfig> = new Vector.<LibConfig>();
    public var cata:Vector.<CataConfig> = new Vector.<CataConfig>();
    public var enum:Vector.<EnumConfig> = new Vector.<EnumConfig>();
    public var container:Vector.<ContainerConfig> = new Vector.<ContainerConfig>();
    public var controle:Vector.<ControleConfig> = new Vector.<ControleConfig>();
}
}
