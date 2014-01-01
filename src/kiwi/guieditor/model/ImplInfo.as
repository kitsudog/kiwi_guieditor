/**
 * Created with IntelliJ IDEA.
 * User: Mage
 * Date: 14-1-1
 * Time: 下午6:10
 * To change this template use File | Settings | File Templates.
 */
package kiwi.guieditor.model {
import flash.utils.getTimer;

import kiwi.guieditor.model.config.ControlConfig;

import kiwi.guieditor.view.DisplayObjectAdapter;

public class ImplInfo {

    public var id:String = getTimer().toString();
    public var dos:DisplayObjectAdapter;
    public var control:ControlConfig;
}
}
