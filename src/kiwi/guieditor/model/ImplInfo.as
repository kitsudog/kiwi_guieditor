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
