package kiwi.guieditor.model {
import flash.utils.getQualifiedClassName;

import kiwi.guieditor.utils.ArrayUtils;

public class Models {
    private static const modelMap:* = {};

    public static function add(model:BaseModel):void {
        var modelName:String = getQualifiedClassName(model);
        var array:Array = modelMap[modelName];
        if (!array) {
            array = [];
            modelMap[modelName] = array;
        }
        array.push(model);
    }

    public static function byName(clz:Class, name:String):* {
        var modelName:String = getQualifiedClassName(clz);
        var array:Array = modelMap[modelName];
        return ArrayUtils.findFirst(array, "name", name);
    }
}
}
