package kiwi.guieditor.utils {
import flash.utils.getDefinitionByName;

public function newObject(info:*):* {
    var clzName:String = info["$class"];
    assert(clzName != null, "$class 没有定义");
    var clz:Class = Class(getDefinitionByName(clzName));
    var obj:* = new clz();
    for (var key:String in info) {
        if (key == "$class") {
            continue;
        }
        obj[key] = info[key];
    }
    return obj;
}
}