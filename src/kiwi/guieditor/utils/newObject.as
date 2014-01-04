package kiwi.guieditor.utils {
import flash.utils.getDefinitionByName;

public function newObject(info:*):* {
    var clzName:String = info["$class"];
    assert(clzName != null, "$class 没有定义");
    var clz:Class = Class(getDefinitionByName(clzName));
    var obj:* = new clz();

    function getValue(info:*):* {
        if (typeof info == "object") {
            if (info["$format"]) {
                if (info["$format"] == "Wrapper") {
                    var clz:Class = Class(getDefinitionByName(info["$class"]));
                    return new clz(info["$value"]);
                }
                throw new Error("不支持的类型:" + info["$format"]);
            }
        }
        return info;
    }

    for (var key:String in info) {
        if (key == "$class") {
            continue;
        }
        obj[key] = getValue(info[key]);
    }
    return obj;
}
}