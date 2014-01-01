package kiwi.guieditor.view {
import kiwi.guieditor.event.EditorEvent;
import kiwi.guieditor.event.OperateEvent;
import kiwi.guieditor.model.config.CataConfig;
import kiwi.guieditor.model.config.ControlConfig;
import kiwi.guieditor.model.config.EditorConfig;

import org.robotlegs.mvcs.Mediator;

import mx.collections.ArrayList;
import mx.containers.Accordion;
import mx.containers.VBox;

/**
 * @author zhangming.luo
 */
public class EditorMediator extends Mediator {
    [Inject]
    public var editor:Editor;
    [Inject]
    public var config:EditorConfig;
    private var listMap:* = {};
    private var cataMap:* = {};

    override public function onRegister():void {
        addContextListener(EditorEvent.APPLY_CONFIG, onReset);
        onReset();
    }

    private function onReset():void {
        var ctrls:Accordion = editor.ctrls;
        listMap = {};
        cataMap = {};
        ctrls.removeAllElements();
        function newCata(cata:CataConfig):VBox {
            var vbox:VBox = new VBox();
            vbox.label = cata.label;
            var list:ControleList = new ControleList();
            list.percentWidth = 100;
            list.percentHeight = 100;
            listMap[cata.name] = list;
            cataMap[cata.name] = [];
            vbox.addElement(list);
            return vbox;
        }

        function newControle(controle:ControlConfig):void {
            var cata:Array = cataMap[controle.cata];
            cata.push(controle);
        }

        config.cata.forEach(function (cata:CataConfig, i:int, array:Array):void {
            ctrls.addElement(newCata(cata));
        });
        config.controle.forEach(function (controle:ControlConfig, i:int, a:Array):void {
            newControle(controle);
        });
        for (var cata:String in cataMap) {
            var list:ControleList = listMap[cata];
            list.dataProvider = new ArrayList(cataMap[cata]);
        }
    }
}
}
