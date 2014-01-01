package kiwi.guieditor.command {
import kiwi.guieditor.event.OperateEvent;
import kiwi.guieditor.model.config.EditorConfig;

import org.robotlegs.mvcs.Command;

/**
 * @author zhangming.luo
 */
public class ApplyConfigCommand extends Command {
    [Inject]
    public var config:EditorConfig;

    override public function execute():void {
        resetCanvas();
        resetControl();
    }

    private function resetControl():void {
        dispatch(new OperateEvent(OperateEvent.RESET));
    }

    private function resetCanvas():void {
        dispatch(new OperateEvent(OperateEvent.RESET));
    }
}
}
