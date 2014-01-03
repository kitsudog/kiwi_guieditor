package kiwi.guieditor.model {
import kiwi.guieditor.view.DisplayObjectAdapter;

public class EditorInfo {
    public var impl:Array = [];
    public var currentSelected:ImplInfo = null;

    public function getByDos(dos:DisplayObjectAdapter):ImplInfo {
        var result:ImplInfo = null;
        impl.some(function (impl:ImplInfo, i:int, array:Array):Boolean {
            if (impl.dos == dos) {
                result = impl;
                return true;
            }
            return false;
        });
        return result;
    }
}
}
