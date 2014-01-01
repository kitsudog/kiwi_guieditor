package kiwi.guieditor.view {
import org.robotlegs.mvcs.Mediator;

public class SmartRenderMediator extends Mediator {
    [Inject]
    public var render:SmartRender;

    public function SmartRenderMediator() {
    }

    override public function onRegister():void {
    }
}
}