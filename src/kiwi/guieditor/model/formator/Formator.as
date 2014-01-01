/**
 * Created with IntelliJ IDEA.
 * User: Mage
 * Date: 14-1-1
 * Time: 下午11:10
 * To change this template use File | Settings | File Templates.
 */
package kiwi.guieditor.model.formator {
public class Formator {

    public static function byName(format:String):IFormator {
        switch (format) {
            case "Int":
                return IntFormator.instance;
            case "Double":
                return DoubleFormator.instance;
            case "Boolean":
                return BooleanFormator.instance;
            case "String":
                return StringFormator.instance;
            case "StyleBoolean":
                return UnknwonFormator.instance;
            case "StyleSkin":
                return UnknwonFormator.instance;
            case "StyleTextFormat":
                return UnknwonFormator.instance;
            default :
                throw new Error("不认识的类型: " + format);
        }

    }
}
}
