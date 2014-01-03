package kiwi.guieditor.view {
import kiwi.guieditor.event.OperateEvent;
import kiwi.guieditor.model.ImplInfo;
import kiwi.guieditor.model.PropertyInfo;
import kiwi.guieditor.model.config.PropertyConfig;
import kiwi.guieditor.model.formator.UnknwonFormator;

import mx.collections.ArrayCollection;

import org.robotlegs.mvcs.Mediator;

public class PropertyListMediator extends Mediator {
    [Inject]
    public var list:PropertyList;

    private var collection:ArrayCollection;

    private var impl:ImplInfo;

    public override function onRegister():void {
        addContextListener(OperateEvent.SELECTED, onSelected);
        addContextListener(OperateEvent.UNSELECTED, onReset);
        addContextListener(OperateEvent.UPDATE, onUpdate);
        addViewListener(OperateEvent.UPDATE, onUpdate);
    }

    private function onUpdate(event:OperateEvent):void {
        list.dataProvider = collection;
    }

    private function onSelected(event:OperateEvent):void {
        impl = ImplInfo(event.object);
        // 附加位置
        var property:Array = [PropertyConfig.X, PropertyConfig.Y].concat(impl.control.property);
        collection = new ArrayCollection(property.filter(function (property:PropertyConfig, i:int, array:Array):Boolean {
            return property.readOnly == false && !(property.formator is UnknwonFormator);
        }).map(function (property:PropertyConfig, i:int, array:Array):PropertyInfo {
                    return new PropertyInfo(impl, property);
                })
        )
        ;
        list.dataProvider = collection;
    }

    private function onReset(event:OperateEvent):void {
        list.dataProvider = null;
    }
}
}
