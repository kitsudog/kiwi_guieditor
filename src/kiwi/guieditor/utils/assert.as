package kiwi.guieditor.utils {
/**
 * 这个是开发时使用的一个断言工具
 * 为了弥补as语言上的不足
 * 希望使用的时候可以按类似的形式
 * trace(assert(...))
 * 这样可以再发布的时候才用工具主动过滤所有的断言语句
 * @author zhangming.luo
 */
public function assert(expr:Boolean, msg:* = null, ...params):Boolean {
    if (expr) {
        return true;
    }
    if (msg is String) {
        // 字符串的话直接输出
        if (params.length > 0) {
            msg += " " + params.join(" ");
        }
    } else if (msg is Function) {
        // 这个是为了防止字符串拼接导致的性能损耗
        msg = (msg as Function).apply(null, params);
    } else if (msg == null) {
        // 不显示信息
        return false;
    } else {
        // 忽略信息
        trace("WARNING: 指定的信息无法被显示" + msg);
        return false;
    }
    Log.error(msg);
    return false;
}
}
