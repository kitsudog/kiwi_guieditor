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
