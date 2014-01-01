/**
 * Created with IntelliJ IDEA.
 * User: Mage
 * Date: 14-1-1
 * Time: 下午6:40
 * To change this template use File | Settings | File Templates.
 */
package kiwi.guieditor.command {
import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;

import kiwi.guieditor.event.EditorEvent;
import kiwi.guieditor.model.config.EditorConfig;
import kiwi.guieditor.model.config.LibConfig;

import org.robotlegs.mvcs.Command;

public class LoadLibraryCommand extends Command {
    [Inject]
    public var config:EditorConfig;

    private var current:LibConfig;

    public override function execute():void {
        for each(var lib:LibConfig in config.lib) {
            if (lib.$loaded) {
                continue;
            }
            if (lib.$loading) {
                return;
            }
            var request:URLRequest = new URLRequest(lib.src);
            var context:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
            current = lib;
            current.$loading = true;
            dispatch(new EditorEvent(EditorEvent.LIBRARY_LOADING));
            var loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
            loader.load(request, context);
            return;
        }
        // 全部加载完毕
        dispatch(new EditorEvent(EditorEvent.LIBRARY_LOADED));
    }

    private function onError(event:IOErrorEvent):void {
        // TODO: 发布错误消息
        onComplete(event);
    }

    private function onComplete(event:Event):void {
        current.$loading = true;
        current.$loaded = true;
        dispatch(new EditorEvent(EditorEvent.LOAD_LIBRARY));
    }
}
}
