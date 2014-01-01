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

import org.robotlegs.mvcs.Mediator;

public class PropertyListMediator extends Mediator {
    [Inject]
    public var list:PropertyList;

    public override function onRegister():void {
        addContextListener(OperateEvent.SELECTED, onSelected);
        addContextListener(OperateEvent.UNSELECTED, onReset);
    }

    private function onSelected(event:OperateEvent):void {
        var impl:ImplInfo = ImplInfo(event.object);
        list.dataProvider = impl.control.property.filter(function (property:PropertyConfig, i:int, array:Array):Boolean {
            return property.readOnly == false;
        }).map(function (property:PropertyConfig, i:int, array:Array):PropertyInfo {
                    return new PropertyInfo(impl, property);
                });
    }

    private function onReset(event:OperateEvent):void {
        list.dataProvider = null;
    }
}
}