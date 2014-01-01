/**
 * Created with IntelliJ IDEA.
 * User: Mage
 * Date: 14-1-1
 * Time: 下午11:30
 * To change this template use File | Settings | File Templates.
 */
package kiwi.guieditor.model.formator {
import flash.display.DisplayObject;

import kiwi.guieditor.model.config.PropertyConfig;

public class UnknwonFormator extends BaseFormator {
    public static const instance:UnknwonFormator = new UnknwonFormator();

    override public function getBy(displayObject:DisplayObject, property:PropertyConfig):* {
        return "#UNKNOWN#";
    }

    override public function setBy(displayObject:DisplayObject, property:PropertyConfig, value:*):void {
        // pass
    }
}
}
