/**
 * Created with IntelliJ IDEA.
 * User: Mage
 * Date: 14-1-1
 * Time: 下午10:58
 * To change this template use File | Settings | File Templates.
 */
package kiwi.guieditor.model {
import flash.events.EventDispatcher;

import kiwi.guieditor.model.config.EnumValueConfig;
import kiwi.guieditor.model.config.PropertyConfig;
import kiwi.guieditor.model.formator.IFormator;
import kiwi.guieditor.utils.ArrayUtils;

public class PropertyInfo extends EventDispatcher {
    public var label:String;
    public var impl:ImplInfo;
    public var property:PropertyConfig;
    public var formator:IFormator;

    public function PropertyInfo(impl:ImplInfo, property:PropertyConfig) {
        this.impl = impl;
        this.property = property;
        this.label = property.label ? property.label : property.name;
        this.formator = property.formator;
    }

    [Bindable]
    public function get value():* {
        var result:* = formator.getBy(impl.dos.orig, property);
        if (property.enumRef) {
            return ArrayUtils.findFirst(property.enums, "value", result);
        } else {
            return result;
        }
    }

    public function set value(value:*):void {
        if (value is EnumValueConfig) {
            formator.setBy(impl.dos.orig, property, value.value);
        } else {
            formator.setBy(impl.dos.orig, property, value);
        }
    }
}
}
