package kiwi.guieditor.utils {
import flash.utils.ByteArray;

/**
 * 数组相关的工具
 * @author zhangming.luo
 */
public class ByteArrayUtils {
    public static function sprint(ba:ByteArray, clone:Boolean = false):String {
        if (clone) {
            var tmp:ByteArray = new ByteArray();
            ba.readBytes(tmp);
            ba = tmp;
        }
        var oldPosition:uint = ba.position;
        ba.position = 0;
        var str:String = "";
        while (ba.bytesAvailable) {
            str += sprintf("%02x ", ba.readUnsignedByte());
        }
        ba.position = oldPosition;
        return str;
    }
}
}
