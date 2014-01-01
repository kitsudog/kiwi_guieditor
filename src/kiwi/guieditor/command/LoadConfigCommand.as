package kiwi.guieditor.command {
import kiwi.guieditor.event.EditorEvent;
import kiwi.guieditor.model.config.AppConfig;
import kiwi.guieditor.model.config.CataConfig;
import kiwi.guieditor.model.config.ContainerConfig;
import kiwi.guieditor.model.config.ControleConfig;
import kiwi.guieditor.model.config.EditorConfig;
import kiwi.guieditor.model.config.EnumConfig;
import kiwi.guieditor.model.config.EnumValueConfig;
import kiwi.guieditor.model.config.LibConfig;
import kiwi.guieditor.model.config.PropertyConfig;
import kiwi.guieditor.utils.readJSON;
import kiwi.guieditor.view.Editor;

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
            } else if (key == "values") {
                for each (var value:* in info[key]) {
                    obj["values"]["push"](merge(EnumValueConfig, value));
                }
            } else {
                obj[key] = info[key];
            }
        }
        return obj;
    }

    override public function execute():void {
        // TODO: 引入schema
        //configObj = readJSON(event.data, "configSchema.json");
        configObj = readJSON(event.data);
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
        for each (info in this.configObj["enum"]) {
            config.enum.push(merge(EnumConfig, info));
        }
        for each (info in this.configObj["container"]) {
            config.container.push(merge(ContainerConfig, info));
        }
        for each (info in this.configObj["controle"]) {
            config.controle.push(merge(ControleConfig, info));
        }
        // 加载Lib
        dispatch(new EditorEvent(EditorEvent.LOAD_LIBRARY));
    }
}
}
