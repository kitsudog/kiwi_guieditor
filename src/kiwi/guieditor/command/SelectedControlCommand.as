/**
 * Created with IntelliJ IDEA.
 * User: Mage
 * Date: 14-1-1
 * Time: 下午10:16
 * To change this template use File | Settings | File Templates.
 */
package kiwi.guieditor.command {
import kiwi.guieditor.event.OperateEvent;
import kiwi.guieditor.model.EditorInfo;

import org.robotlegs.mvcs.Command;

public class SelectedControlCommand extends Command {
    [Inject]
    public var event:OperateEvent;

    [Inject]
    public var info:EditorInfo;

    public override function execute():void {
        if (info.currentSelected) {
            dispatch(new OperateEvent(OperateEvent.UNSELECTED, info.currentSelected));
        }
        info.currentSelected = info.getByDos(event.object);
        dispatch(new OperateEvent(OperateEvent.SELECTED, info.currentSelected));
    }
}
}
