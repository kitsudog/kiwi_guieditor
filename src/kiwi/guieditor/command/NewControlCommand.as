package kiwi.guieditor.command {
import kiwi.guieditor.event.OperateEvent;
import kiwi.guieditor.model.EditorInfo;
import kiwi.guieditor.model.ImplInfo;
import kiwi.guieditor.model.config.ControlConfig;
import kiwi.guieditor.utils.newObject;
import kiwi.guieditor.view.DisplayObjectAdapter;

import org.robotlegs.mvcs.Command;

public class NewControlCommand extends Command {
    [Inject]
    public var info:EditorInfo;
    [Inject]
    public var event:OperateEvent;

    public override function execute():void {
        var controle:ControlConfig = event.object;
        var object:DisplayObjectAdapter = new DisplayObjectAdapter(newObject(controle.factory));
        var impl:ImplInfo = new ImplInfo();
        impl.dos = object;
        impl.control = controle;
        info.impl.push(impl);
        dispatch(new OperateEvent(OperateEvent.ADD, object, event.pos));
    }
}
}
