package kiwi.guieditor.model.formator {
import flash.display.DisplayObject;
import flash.events.Event;

import kiwi.guieditor.model.config.PropertyConfig;

internal class BaseFormator implements IFormator {
    public function getBy(displayObject:DisplayObject, property:PropertyConfig):* {
        return displayObject[property.name];
    }

    public function setBy(displayObject:DisplayObject, property:PropertyConfig, value:*):void {
        displayObject[property.name] = value;
        displayObject.dispatchEvent(new Event(Event.CHANGE));
    }
}
}
