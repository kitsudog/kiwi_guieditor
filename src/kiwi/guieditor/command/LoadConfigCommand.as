package kiwi.guieditor.command {
import kiwi.guieditor.event.EditorEvent;
import kiwi.guieditor.model.config.AppConfig;
import kiwi.guieditor.model.config.CataConfig;
import kiwi.guieditor.model.config.ContainerConfig;
import kiwi.guieditor.model.config.ControleConfig;
import kiwi.guieditor.model.config.EditorConfig;
import kiwi.guieditor.model.config.LibConfig;
import kiwi.guieditor.model.config.PropertyConfig;
import kiwi.guieditor.utils.readFile;

import org.robotlegs.mvcs.Command;

/**
 * @author zhangming.luo
 */
public class LoadConfigCommand extends Command {
    [Inject]
    public var config:EditorConfig;
    [Inject]
    public var event:EditorEvent;
    private var configObj:*;

    private function merge(clz:Class, info:*):* {
        var obj:* = new clz();
        for (var key:String in info) {
            if (key == "property") {
                for each (var property:* in info[key]) {
                    obj["property"]["push"](merge(PropertyConfig, property));
                }
            } else {
                obj[key] = info[key];
            }
        }
        return obj;
    }

    override public function execute():void {
        configObj = JSON.parse(readFile(event.data));
        var info:*;
        for each (info in this.configObj["app"]) {
            config.app.push(merge(AppConfig, info));
        }
        for each (info in this.configObj["lib"]) {
            config.lib.push(merge(LibConfig, info));
        }
        for each (info in this.configObj["cata"]) {
            config.cata.push(merge(CataConfig, info));
        }
        for each (info in this.configObj["container"]) {
            config.container.push(merge(ContainerConfig, info));
        }
        for each (info in this.configObj["controle"]) {
            config.controle.push(merge(ControleConfig, info));
        }
    }
}
}
