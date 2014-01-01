package kiwi.guieditor.utils {
import flash.external.ExternalInterface;
import flash.system.Capabilities;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.utils.getTimer;

/**
 * Log框架支持基本的注册分发
 * @author zhangming.luo
 */
public class Log {
    public static const LEVEL_ALL:int = int.MAX_VALUE;
    public static const LEVEL_STAT:int = 6;
    public static const LEVEL_DEBUG:int = 5;
    public static const LEVEL_PROFILE:int = 4;
    public static const LEVEL_INFO:int = 3;
    public static const LEVEL_WARN:int = 2;
    public static const LEVEL_ERROR:int = 1;
    private static const LEVEL_ALERT:int = 0;
    private static var _level:int = LEVEL_ALL;
    private static var appenderDic:Dictionary = new Dictionary();
    private static var _profilerNode:NodeInfo;
    private static var curNode:NodeInfo;
    public static var _profileEnabled:Boolean = false;
    {
        appenderDic[LEVEL_ALL] = [];
        appenderDic[LEVEL_PROFILE] = [];
        appenderDic[LEVEL_DEBUG] = [];
        appenderDic[LEVEL_ERROR] = [];
        appenderDic[LEVEL_INFO] = [];
        appenderDic[LEVEL_WARN] = [];
        appenderDic[LEVEL_ALERT] = [];
        appenderDic[LEVEL_STAT] = [];
    }
    public static function set level(value:int):void {
        _level = value;
    }

    public static function error(msg:String, e:Error = null):void {
        if (_level < Log.LEVEL_ERROR) {
            return;
        }
        var stack:String = printStack(e);
        trace("ERROR ", msg, e != null ? e.message : "", stack);
        var appender:ILogAppender;
        for each (appender in appenderDic[LEVEL_ALL]) {
            appender.append("error", msg);
        }
        if (stack) {
            msg += "|" + stack;
        }
        for each (appender in appenderDic[LEVEL_ERROR]) {
            appender.append("error", msg);
        }
    }

    public static function info(msg:String):void {
        if (_level < Log.LEVEL_INFO) {
            return;
        }
        trace("INFO  ", msg);
        var appender:ILogAppender;
        for each (appender in appenderDic[LEVEL_INFO]) {
            appender.append("info", msg);
        }
        for each (appender in appenderDic[LEVEL_ALL]) {
            appender.append("info", msg);
        }
    }

    /**
     * stat统计需求用的
     */
    public static function stat(msg:String):void {
        var appender:ILogAppender;
        for each (appender in appenderDic[LEVEL_STAT]) {
            appender.append("stat", msg);
        }
    }

    /**
     * debug级别的log
     * @param label        用来做debug控制台过滤的
     * @param msg        具体的消息
     * @param append    附加的信息 支持对byteArray,Error等对象的输出
     */
    public static function debug(label:String, msg:String, append:* = null):void {
        if (_level < Log.LEVEL_DEBUG) {
            return;
        }
        var content:String;
        if (append is String) {
            // 原样输出
            content = msg + " " + append;
        } else if (append is ByteArray) {
            var raw:String = ByteArrayUtils.sprint(append);
            if (raw.length > 1000) {
                raw = raw.substr(0, 1000) + " ...";
            }
            content = msg + " " + raw;
        } else if (append is Error) {
            content = msg + " " + Error(append).getStackTrace();
        } else if (append is Array) {
            content = msg + " [" + (append as Array).join(",") + "]";
        } else if (append != null) {
            content = msg + " " + append;
        } else {
            content = msg;
        }
        trace("DEBUG [", label, "] ", content);
        var appender:ILogAppender;
        for each (appender in appenderDic[LEVEL_DEBUG]) {
            appender.append(label, content);
        }
        for each (appender in appenderDic[LEVEL_ALL]) {
            appender.append(label, content);
        }
    }

    public static function warn(msg:String):void {
        if (_level < Log.LEVEL_WARN) {
            return;
        }
        trace("WARN  ", msg);
        var appender:ILogAppender;
        for each (appender in appenderDic[LEVEL_WARN]) {
            appender.append("alert", msg);
        }
        for each (appender in appenderDic[LEVEL_ALL]) {
            appender.append("alert", msg);
        }
    }

    public static function alert(msg:String):void {
        if (_level < Log.LEVEL_ALERT) {
            return;
        }
        trace(msg);
        if (ExternalInterface.available) {
            ExternalInterface.call("alert", msg);
        }
        for each (var appender:ILogAppender in appenderDic[LEVEL_ALERT]) {
            appender.append("alert", msg);
        }
    }

    /**
     * 格式化error的数据
     */
    public static function formatError(e:Error):String {
        return e.name;
    }

    /**
     * 打印堆栈
     */
    private static function printStack(e:Error = null):String {
        e = e == null ? new Error() : e;
        if (Capabilities.isDebugger) {
            return e.getStackTrace();
        } else {
            return e.message;
        }
    }

    public static function registerAppender(level:int, appender:ILogAppender):void {
        (appenderDic[level] as Array).push(appender);
    }

    public static function unregisterAppender(level:int, appender:ILogAppender):void {
        var index:int = (appenderDic[level] as Array).indexOf(appender);
        if (index >= 0) {
            (appenderDic[level] as Array).splice(index, 1);
        }
    }

    public static function registerAlertAppender(appender:ILogAppender):void {
        Log.registerAppender(LEVEL_ALERT, appender);
    }

    public static function enterProfiler(label:String, startTime:uint):void {
        var index:int = curNode.nodeNames.indexOf(label);
        var node:NodeInfo;
        if (index < 0) {
            node = new NodeInfo();
            node.label = label;
            curNode.nodeNames.push(label);
            curNode.nodes.push(node);
            node.parent = curNode;
        } else {
            node = curNode.nodes[index];
        }
        curNode = node;
        node.last = startTime;
        node.curStep = startTime;
    }

    public static function stepMark(label:String, now:int):void {
        if (curNode == null) {
            return;
        }
        trace("[PROF]", "Step ", label || "", now - curNode.curStep, now - curNode.last);
        curNode.curStep = now;
    }

    public static function exitProfiler(label:String, endTime:uint):void {
        assert(curNode.label == label, "出现Profiler堆栈退出异常 ", label, "当前堆栈为" + curNode.label);
        var delta:uint = endTime - curNode.last;
        curNode.sum += delta;
        if (curNode.counter++ == 0) {
            // 第一次独立保留
            curNode.first = curNode.sum;
        }
        if (curNode.max < delta) {
            curNode.max = delta;
        }
        if (curNode.min > delta) {
            curNode.min = delta;
        }
        curNode = curNode.parent;
    }

    public static function profile(label:String, msg:String):void {
        if (_level < Log.LEVEL_PROFILE) {
            return;
        }
        for each (var appender:ILogAppender in appenderDic[LEVEL_PROFILE]) {
            appender.append(label, msg);
        }
    }

    public static function set profileEnabled(profileEnabled:Boolean):void {
        if (_profileEnabled && profileEnabled) {
            return;
        }
        Log._profileEnabled = profileEnabled;
        if (profileEnabled) {
            Log.debug("Profiler", "开始采集");
            // 清理缓存的数据
            _profilerNode = new NodeInfo();
            _profilerNode.label = "Root";
            curNode = _profilerNode;
        } else {
            Log.debug("Profiler", "停止采集");
            // dump
            var now:int = getTimer();
            while (curNode != _profilerNode) {
                exitProfiler(curNode.label, now);
            }
            if (_profilerNode) dump(_profilerNode);
            curNode = null;
            _profilerNode = null;
        }
    }

    private static function dump(targetNode:NodeInfo):void {
        trace("[PROF]", "Dump Profiler");
        trace("[PROF]", sprintf("%-50s %7s %5s %7s %5s %5s %7s", "Label", "cnt", "avg", "self", "min", "max", "fst"));
        trace("[PROF]", "Root");
        trace(function ():String {
            var zeroList:Array = [];
            var nodeList:Array = targetNode.nodes.concat();
            var node:NodeInfo;
            while (nodeList.length) {
                node = nodeList.pop();
                if (node.sum == 0) {
                    // 没有显示的必要了
                    zeroList.push(node);
                    continue;
                }
                var childSum:int = 0;
                for each (var child:NodeInfo in node.nodes) {
                    nodeList.push(child);
                    childSum += child.sum;
                }
                node.childSum = childSum;
                var tmp:NodeInfo = node;
                var cnt:int = 0;
                while (tmp != targetNode) {
                    cnt++;
                    tmp = tmp.parent;
                }
                const template:String = "%-50s %7d %5d %6.2f%% %5d %5d %6.2f%%";
                var prefix:String = sprintf("%" + cnt + "s%s", (childSum > 0 ? "+" : "-"), node.label);
                trace("[PROF]", sprintf(template, prefix, node.counter, node.avg, node.self, node.min, node.max, (node.sum == 0 || node.fst == 0) ? 0 : node.fst), (node.health() > 51 ? "[S]" : ""));
            }
            trace("[PROF]", "Zero List");
            while (zeroList.length) {
                node = zeroList.shift();
                trace("[PROF]", sprintf("*%-50s %7d", node.label, node.counter));
            }
            return  "";
        }() + "[PROF]", "Dump Profiler End");
    }
}
}
class NodeInfo {
    /**
     * 出现次数
     */
    public var counter:int;
    /**
     * 时间总和
     */
    public var sum:int;
    /**
     * 标签
     */
    public var label:String;
    public var first:int;
    public var nodeNames:Array = [];
    public var nodes:Array = [];
    public var last:int;
    public var curStep:int;
    public var max:int;
    public var min:int = int.MAX_VALUE;
    public var parent:NodeInfo;
    public var childSum:int;

    public function get avg():int {
        return sum / counter;
    }

    public function get self():Number {
        return sum == 0 ? 100 : ((sum - childSum) * 100 / sum);
    }

    public function get fst():Number {
        return sum == 0 ? 0 : (first * 100 / sum);
    }

    public function health():int {
        if (max > 15 || avg > 10) {
            return 100;
        }
        if (fst > 50) {
            return 50;
        }
        return avg * 5 + fst;
    }
}