/**
 * Created by Mage on 13-12-31.
 */
package kiwi.guieditor {
import kiwi.guieditor.view.EditorMediator;
import kiwi.guieditor.command.ApplyConfigCommand;
import kiwi.guieditor.command.GuiEditorStartupCommand;
import kiwi.guieditor.command.LoadConfigCommand;
import kiwi.guieditor.event.EditorEvent;
import kiwi.guieditor.model.config.EditorConfig;
import kiwi.guieditor.view.Canvas;
import kiwi.guieditor.view.CanvasMediator;
import kiwi.guieditor.view.Editor;
import kiwi.guieditor.view.Menu;
import kiwi.guieditor.view.MenuMediator;
import kiwi.guieditor.view.SmartEditor;
import kiwi.guieditor.view.SmartEditorMediator;
import kiwi.guieditor.view.SmartRender;
import kiwi.guieditor.view.SmartRenderMediator;

import org.robotlegs.base.ContextEvent;
import org.robotlegs.mvcs.Context;

public class AppContext extends Context {
    override public function startup():void {
        // 全局的配置
        injector.mapSingleton(EditorConfig);

        mediatorMap.mapView(Menu, MenuMediator);
        mediatorMap.mapView(Canvas, CanvasMediator);
        mediatorMap.mapView(Editor, EditorMediator);
        mediatorMap.mapView(SmartRender, SmartRenderMediator);
        mediatorMap.mapView(SmartEditor, SmartEditorMediator);

        commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, GuiEditorStartupCommand);
        commandMap.mapEvent(EditorEvent.LOAD_CONFIG, LoadConfigCommand);
        commandMap.mapEvent(EditorEvent.APPLY_CONFIG, ApplyConfigCommand);

        super.startup();
    }
}
}
