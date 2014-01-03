package kiwi.guieditor.model {
import flash.events.EventDispatcher;

public class BaseModel extends EventDispatcher {
    public function BaseModel():void {
        Models.add(this);
    }
}
}
