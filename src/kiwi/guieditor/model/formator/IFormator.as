package kiwi.guieditor.model.formator {
import flash.display.DisplayObject;

import kiwi.guieditor.model.config.PropertyConfig;

public interface IFormator {
    function getBy(displayObject:DisplayObject, property:PropertyConfig):*;

    function setBy(displayObject:DisplayObject, property:PropertyConfig, value:*):void;
}
}