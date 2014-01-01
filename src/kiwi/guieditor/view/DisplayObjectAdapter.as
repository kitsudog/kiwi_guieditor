/**
 * Created with IntelliJ IDEA.
 * User: Mage
 * Date: 14-1-1
 * Time: 下午6:04
 * To change this template use File | Settings | File Templates.
 */
package kiwi.guieditor.view {
import flash.display.DisplayObject;

import mx.core.UIComponent;

public class DisplayObjectAdapter extends UIComponent {
    private var displayObject:DisplayObject;

    public function DisplayObjectAdapter(displayObject:DisplayObject) {
        this.displayObject = displayObject;
        this.addChild(displayObject);
    }
}
}
