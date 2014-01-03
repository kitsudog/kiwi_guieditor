package kiwi.guieditor.view {
import flash.events.Event;

import kiwi.guieditor.event.EditorEvent;

import mx.events.MenuEvent;

import org.robotlegs.mvcs.Mediator;

/**
 * @author zhangming.luo
 */
public class MenuMediator extends Mediator {
    [Inject]
    public var menu:Menu;
    private static const MENU_HANDLE_MAP:* = {//
        "新建": EditorEvent.NEW//
        , "读取": EditorEvent.OPEN//
        , "保存": EditorEvent.SAVE//
        , "导出": EditorEvent.EXPORT//
        , "容器": EditorEvent.CONTAINER//
        , "批量导出": EditorEvent.EXPORT_ADV//
    };

    override public function onRegister():void {
        addViewListener(MenuEvent.ITEM_CLICK, onItemClick);
    }

    private function onItemClick(event:MenuEvent):void {
        var eventName:String = MENU_HANDLE_MAP[event.label];
        dispatch(new Event(eventName));
    }
}
}
