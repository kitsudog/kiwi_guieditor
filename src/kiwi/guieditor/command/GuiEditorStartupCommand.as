package kiwi.guieditor.command {
import kiwi.guieditor.event.EditorEvent;
import kiwi.guieditor.model.config.AppConfig;
import kiwi.guieditor.model.config.EditorConfig;

import org.robotlegs.mvcs.Command;

public class GuiEditorStartupCommand extends Command {
    [Inject]
    public var config:EditorConfig;

    public override function execute():void {
        dispatch(new EditorEvent(EditorEvent.LOAD_CONFIG, "config.json"));
        for each (var app:AppConfig in config.app) {
            dispatch(new EditorEvent(EditorEvent.LOAD_CONFIG, app.src));
        }
        dispatch(new EditorEvent(EditorEvent.APPLY_CONFIG));
    }
}
}
