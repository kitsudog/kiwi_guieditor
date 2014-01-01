/**
 * Created with IntelliJ IDEA.
 * User: Mage
 * Date: 14-1-1
 * Time: 下午10:58
 * To change this template use File | Settings | File Templates.
 */
package kiwi.guieditor.model {
import kiwi.guieditor.model.config.PropertyConfig;
import kiwi.guieditor.model.formator.IFormator;

public class PropertyInfo {
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

    public function get value():* {
        return formator.getBy(impl.dos.orig, property);
    }

    public function set value(value:*):void {
        formator.setBy(impl.dos.orig, property, value);
    }
}
}
