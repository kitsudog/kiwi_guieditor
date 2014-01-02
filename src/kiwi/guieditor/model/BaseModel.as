/**
 * Created with IntelliJ IDEA.
 * User: Mage
 * Date: 14-1-2
 * Time: 上午10:46
 * To change this template use File | Settings | File Templates.
 */
package kiwi.guieditor.model {
import flash.events.EventDispatcher;

public class BaseModel extends EventDispatcher {
    public function BaseModel():void {
        Models.add(this);
    }
}
}
