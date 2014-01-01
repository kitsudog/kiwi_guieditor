/**
 * Created with IntelliJ IDEA.
 * User: Mage
 * Date: 14-1-1
 * Time: 下午11:31
 * To change this template use File | Settings | File Templates.
 */
package kiwi.guieditor.model.formator {
import flash.display.DisplayObject;

import kiwi.guieditor.model.config.PropertyConfig;

internal class BaseFormator implements IFormator {
    public function getBy(displayObject:DisplayObject, property:PropertyConfig):* {
        return displayObject[property.name];
    }

    public function setBy(displayObject:DisplayObject, property:PropertyConfig, value:*):void {
        displayObject[property.name] = value;
    }
}
}
