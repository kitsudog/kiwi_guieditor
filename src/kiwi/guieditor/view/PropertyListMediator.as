/**
 * Created with IntelliJ IDEA.
 * User: Mage
 * Date: 14-1-1
 * Time: 下午10:45
 * To change this template use File | Settings | File Templates.
 */
package kiwi.guieditor.view {
import kiwi.guieditor.event.OperateEvent;
import kiwi.guieditor.model.ImplInfo;
import kiwi.guieditor.model.PropertyInfo;
import kiwi.guieditor.model.config.PropertyConfig;
import kiwi.guieditor.model.formator.UnknwonFormator;
import kiwi.guieditor.utils.ArrayUtils;

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
        addViewListener(OperateEvent.UPDATE, onUpdate);
    }

    private function onUpdate(event:OperateEvent):void {
        list.enabled = false;
        list.enabled = true;
    }

    private function onSelected(event:OperateEvent):void {
        impl = ImplInfo(event.object);
        collection = new ArrayCollection(impl.control.property.filter(function (property:PropertyConfig, i:int, array:Array):Boolean {
            return property.readOnly == false && !(property.formator is UnknwonFormator);
        }).map(function (property:PropertyConfig, i:int, array:Array):PropertyInfo {
                    return new PropertyInfo(impl, property);
                }));
        list.dataProvider = collection;
    }

    private function onReset(event:OperateEvent):void {
        list.dataProvider = null;
    }
}
}
