package kiwi.guieditor.utils {
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

/**
 * @author thinkpad
 */
public class ArrayUtils {
    public static function initialize():void {
        // Array.prototype.subArray = function(start : int, len : int = int.MAX_VALUE) : Array {
        // return subArray(this as Array, start, len);
        // };
        // Array.prototype.sum = function(property : String = null) : int {
        // return sum(this as Array, property);
        // };
        // Array.prototype.swap = function(lh : int, rh : int) : void {
        // swap(this as Array, lh, rh);
        // };
        // Array.prototype.max = function(compare : * = null, thisArgs : * = null) : * {
        // return max(this as Array, compare, thisArgs);
        // };
        // Array.prototype.min = function(compare : * = null, thisArgs : * = null) : * {
        // return min(this as Array, compare, thisArgs);
        // };
        // Array.prototype.collect = function(prop : String) : Array {
        // return collect(this as Array, prop);
        // };
    }

    public static function subArray(array:Array, start:int, len:int = -1):Array {
        var result:Array = [];
        var end:int = len < 0 ? array.length : start + len;
        for (var i:int = start; i < end; i++) {
            result.push(array[i]);
        }
        return result;
    }

    /**
     * 将一个byteArray转换为Array<br>
     * @param ba
     * @param uLen
     */
    public static function parseFromByteArray(ba:ByteArray, uLen:int = 1):Array {
        var result:Array = [];
        ba.position = 0;
        while (true) {
            if (ba.position >= ba.length) {
                break;
            }
            switch (uLen) {
                case 1:
                    result.push(ba.readByte());
                    break;
                case 2:
                    result.push(ba.readShort());
                    break;
                case 4:
                    result.push(ba.readUnsignedInt());
                    break;
            }
        }
        return result;
    }

    /**
     * 计算总和
     */
    public static function sum(src:Array, property:String = null):int {
        return fold(src, function (lh:int, rh:*/*{Number|int}*/):* {
            if (!property) {
                // 对值直接做和操作
                return (lh + rh);
            }
            return lh + diveInto([].concat(property), rh);
        }, 0);
    }

    /**
     * 交换数组中的两个元素<br>
     * 位置如果为负数则意思为从后向前数
     */
    public static function swap(src:Array, lh:int, rh:int):void {
        if (src == null || src.length == 0) {
            throw new Error("空数组");
        }
        var len:uint = src.length;
        if (lh >= len || rh >= len) {
            throw new Error("越界了");
        }
        lh = (src.length + lh ) % src.length;
        rh = (src.length + rh ) % src.length;
        if (lh == rh) {
            return;
        }
        if (src[lh] == src[rh]) {
            return;
        }
        // 开始交换
        var tmp:* = src[lh];
        src[lh] = src[rh];
        src[rh] = tmp;
    }

    /**
     * 获取最大的那个
     * @param src
     * @param compare
     * @param thisArgs
     * @return 当数组为空时返回null, 否则返回指定<b>项</b>
     *    <ul>
     *        <li>null: 按数值做比较</li>
     *        <li>Function: 比较函数</li>
     *        <li>String: 针对指定的属性做数值上的比较 </li>
     *        <li>Array: 针对指定的属性做数值上的比较 </li>
     *    </ul>
     *
     */
    public static function max(src:Array, compare:* = null, thisArgs:* = null):* {
        return fold(src, function (lh:*, rh:*):* {
            if (compare == null) {
                // 按数字处理
                return Math.max(lh, rh);
            } else if (compare is Function) {
                // 用指定的方法选择
                return (compare as Function).apply(thisArgs, [lh, rh]);
            } else if (compare is Array) {
                if (diveInto(compare as Array, lh) >= diveInto(compare as Array, rh)) {
                    return lh;
                } else {
                    return rh;
                }
            } else if (compare is String) {
                if (lh[compare] >= rh[compare]) {
                    return lh;
                } else {
                    return rh;
                }
            }
            return null;
        });
    }

    /**
     * 获取最小的那个
     * @param src
     * @param compare
     * @param thisArgs
     * @return 当数组为空时返回null, 否则返回指定<b>项</b>
     *    <ul>
     *        <li>null: 按数值做比较</li>
     *        <li>Function: 比较函数</li>
     *        <li>String: 针对指定的属性做数值上的比较 </li>
     *        <li>Array: 针对指定的属性做数值上的比较 </li>
     *    </ul>
     */
    public static function min(src:Array, compare:* = null, thisArgs:* = null):* {
        return fold(src, function (lh:*, rh:*):* {
            if (compare == null) {
                // 按数字处理
                return Math.min(lh, rh);
            } else if (compare is Function) {
                // 用指定的方法选择
                return (compare as Function).apply(thisArgs, [lh, rh]);
            } else if (compare is Array) {
                if (diveInto(compare as Array, lh) >= diveInto(compare as Array, rh)) {
                    return rh;
                } else {
                    return lh;
                }
            } else if (compare is String) {
                if (lh[compare] >= rh[compare]) {
                    return rh;
                } else {
                    return lh;
                }
            }
            return null;
        });
    }

    /**
     * 根据选择器查找对应的项
     * @return not null
     */
    public static function select(src:Array, selector:Function, thisArg:* = null):Array {
        var resutl:Array = [];
        var index:int = 0;
        while (index < src.length) {
            var elem:* = src[index];
            if (elem != null) {
                if (selector.call(thisArg, elem) === true) {
                    resutl.push(elem);
                }
            }
            index++;
        }
        return (resutl);
    }

    /**
     * 剔除满足条件的项(不影响源数组)
     * @param src
     * @param prop 选择器
     * @param value 指定的值(默认为布尔值true)
     * @param thisArgs
     * @return not null
     */
    public static function reject(src:Array, prop:*, value:* = true, thisArgs:* = null):Array {
        return select(src, function (elem:*):Boolean {
            if (prop is Function) {
                return (prop as Function).call(thisArgs || null, elem) != value;
            }
            return !(diveInto([prop], elem) === value);
        }, thisArgs);
    }

    /**
     * 剔除满足条件的项(不影响源数组)
     * @param src 选择器
     * @param prop 选择器
     * @param valueSet 指定的值(默认为布尔值true)
     * @param thisArgs
     * @return not null
     */
    public static function rejectBySet(src:Array, prop:*, valueSet:Array, thisArgs:* = null):Array {
        return select(src, function (elem:*):Boolean {
            if (prop is Function) {
                return valueSet.indexOf((prop as Function).call(thisArgs || null, elem)) < 0;
            }
            return valueSet.indexOf(diveInto([prop], elem)) < 0;
        }, thisArgs);
    }

    /**
     * 选择满足条件的项
     * @param src
     * @param prop 选择器
     * @param value 指定的值(默认为布尔值true)
     * @param thisArgs
     * @return not null
     */
    public static function find(src:Array, prop:*, value:* = true, thisArgs:* = null):Array {
        return select(src, function (elem:*):Boolean {
            // 选择器查找
            if (prop is Function) {
                return (prop as Function).call(thisArgs, elem);
            }
            if (prop is Array) {
                return diveInto(prop, elem) === value;
            }
            if (prop is String) {
                if (value is String) {
                    return elem[prop] == value;
                }
                return elem[prop] === value;
            }
            if (value is String) {
                return diveInto([prop], elem) == value;
            } else {
                return diveInto([prop], elem) === value;
            }
        });
    }

    /**
     * 选择满足条件的项
     * @param src
     * @param prop 选择器
     * @param valueSet 指定的值(默认为布尔值true)
     * @param thisArgs 指定的值(默认为布尔值true)
     * @return not null
     */
    public static function findBySet(src:Array, prop:*, valueSet:Array, thisArgs:* = null):Array {
        return select(src, function (elem:*):Boolean {
            // 选择器查找
            if (prop is Function) {
                return valueSet.indexOf((prop as Function).call(thisArgs, elem)) >= 0;
            }
            if (prop is Array) {
                return valueSet.indexOf(diveInto(prop, elem)) >= 0;
            }
            if (prop is String) {
                return valueSet.indexOf(elem[prop]) >= 0;
            }
            return valueSet.indexOf(diveInto([prop], elem)) >= 0;
        });
    }

    /**
     * 定位第一个
     */
    public static function findFirst(src:Array, prop:*, value:* = true, thisArgs:* = null):* {
        var result:Array = find(src, prop, value, thisArgs);
        if (result.length) {
            return result[0];
        }
        return null;
    }

    /**
     * 通过一个path(String表达的)获取内部的值
     */
    public static function diveInto(src:Array, object:*, ignorInvalid:Boolean = false):* {
        try {
            return fold(src, function (obj:*, prop:*):* {
                // 单纯的认为prop中的只是一个属性而已
                return (obj[prop]);
            }, object);
        } catch (e:Error) {
            if (ignorInvalid) {
                return null;
            }
        }
        throw new Error("Invalid prop: " + JSON.stringify(src));
    }

    /**
     * 迭代数组中的每个值
     * @param src 源数组
     * @param func 执行体 Function(cur:*,elem:*):*
     * @param startElem 其实值(当值与元素的类型不兼容时,务必指定此参数)
     * @param thisArg
     */
    public static function fold(src:Array, func:Function, startElem:Object = null, thisArg:Object = null):* {
        var tmp:Array = src.concat();
        if (startElem === null) {
            startElem = tmp.shift();
        }
        var result:Object = startElem;
        var index:int = 0;
        while (index < tmp.length) {
            // 排除其中的null
            if (tmp[index] != null) {
                result = func.call(thisArg, result, tmp[index]);
            }
            index++;
        }
        return (result);
    }

    /**
     * 从值获取关联数组中的key
     */
    public static function findKey(associative_array:*, value:*):Array {
        var result:Array = [];
        for (var key:String in associative_array) {
            if (associative_array[key] == value) {
                result.push(key);
            }
        }
        return result;
    }

    /**
     * 多次执行
     */
    public static function times(times:int, func:Function, thisObj:* = null, params:Array = null):void {
        for (var i:int = 0; i < times; i++) {
            func.apply(thisObj, params);
        }
    }

    /**
     * 主要是针对关联数组的
     */
    public static function forEach(associative_array:*, func:Function, thisObj:* = null):Array {
        var result:Array = [];
        for (var key:String in associative_array) {
            result.push(func.apply(thisObj, [associative_array[key]]));
        }
        return result;
    }

    /**
     * 收集某个属性
     */
    public static function collect(src:Array, prop:String):Array {
        var result:Array = [];
        for each (var item:* in src) {
            result.push(item[prop]);
        }
        return result;
    }

    /**
     * 同时收集两个属性
     * 第一个当做key
     * 第二个当做value
     */
    public static function collectToMap(src:Array, keyProp:String, valueProp:String):Object {
        var result:Object = {};
        for each (var item:* in src) {
            result[item[keyProp]] = item[valueProp];
        }
        return result;
    }

    public static function putAll(src:Array, dest:Array):void {
        if (dest == null || dest.length == 0) {
            return;
        }
        for each (var item:* in dest) {
            src.push(item);
        }
    }

    /**
     * 取a - b 的差积<br>
     * [1,2] - [1,3] = [2]
     */
    public static function dec(a:Array, b:Array):Array {
        var dic:Dictionary = new Dictionary();
        for each (var d:* in b) {
            dic[d] = null;
        }
        var result:Array = [];
        for each (var e:* in a) {
            if (e in dic) {
                continue;
            }
            result.push(e);
        }
        return result;
    }

    public static function combine(array1:Array, array2:Array, uniq:Boolean = true):Array {
        var result:Array = array1.concat();
        for each (var item:* in array2) {
            result.push(item);
        }
        if (uniq) {
            result = createUniqueCopy(result);
        }
        return result;
    }

    /**
     * 包含判断
     */
    public static function contains(array:Array, obj:*, equal:Boolean = true):Boolean {
        for each (var value:* in array) {
            if (equal && value == obj) {
                return true;
            } else {
                if (value === obj) {
                    return true;
                }
            }
        }
        return false;
    }

    /**
     * 子集判断
     */
    public static function containSet(lh:Array, rh:Array):Boolean {
        var map:Dictionary = new Dictionary();
        for each (var value:* in lh) {
            map[value] = null;
        }
        for each (var v:* in rh) {
            if (!(v in map)) {
                return false;
            }
        }
        return true;
    }

    /**
     * 拉平所有
     * [[1,2,3],[4,[5,6]]].flatten()=[1,2,3,4,5,6]
     */
    public static function flatten(src:Array):Array {
        return fold(src, function (result:Array, elem:*):Array {
            if (elem is Array) {
                elem = flatten(elem);
            }
            return (result.concat(elem));
        }, []);
    }

    /**
     * 转换
     * @param src
     * @param f function(e:*):*
     * @param thisArg
     * @return not null
     */
    public static function transform(src:Array, f:Function, thisArg:* = null):Array {
        if (!src.length) {
            return [];
        }
        var thisObject:* = thisArg;
        return src.map(function (element:*, index:int, arr:Array):* {
            return (f.call(((thisObject) || (arr)), element));
        });
    }

    /**
     * 随机数组(乱序)
     */
    public static function shuffle(array:Array, clone:Boolean = true):Array {
        var result:Array = clone ? array.concat() : array;
        var index:int = 0;
        while (index < result.length) {
            var r:int = Math.floor((Math.random() * result.length));
            var tmp:* = result[index];
            result[index] = result[r];
            result[r] = tmp;
            index++;
        }
        return result;
    }

    /**
     * collect后根据值划分的过程
     */
    public static function partition(src:Array, prop:*):* {
        var result:Object = {};
        for each (var item:* in src) {
            var value:*;
            if (prop is Function) {
                value = prop(item);
            } else {
                value = item[prop];
            }
            if (!result[value]) {
                result[value] = [];
            }
            (result[value] as Array).push(item);
        }
        return result;
    }

    /**
     * 随机的一项
     * @param  array 源数组
     */
    public static function randomOne(array:Array):* {
        if (array.length == 0) {
            return null;
        }
        return array[Math.floor(Math.random() * array.length)];
    }

    /**
     * 获取一个1~len的随机数列
     */
    private static function randomArray(len:int):Array {
        var list:Array = [];
        var i:int;
        for (i = 0; i < len; i++) {
            list[i] = i;
        }
        for (i = 0; i < len; i++) {
            var tmp:int = list[i];
            var r:int = (Math.random() * len);
            list[i] = list[r];
            list[r] = tmp;
        }
        return list;
    }

    /**
     * 通过一个序列的数组来重新排序
     */
    public static function sortByHint(orig:Array, hint:Array):void {
        var cursor:int = 0;
        for (var i:int = 0; i < orig.length;) {
            var curIndex:int = hint[cursor];
            if (curIndex < 0 || curIndex == i) {
                hint[cursor] = -1;
                i++;
                cursor = i;
                continue;
            }
            hint[cursor] = -1;
            var tmp:* = orig[cursor];
            orig[cursor] = orig[curIndex];
            orig[curIndex] = tmp;
            cursor = curIndex;
        }
    }

    /**
     * 与sortByHint相同不过交换的算法是可以指定的
     */
    public static function sortByHintEx(orig:Array, hint:Array, swapFunc:Function):int {
        var cursor:int = 0;
        var cnt:int = 0;
        for (var i:int = 0; i < orig.length;) {
            var curIndex:int = hint[cursor];
            if (curIndex < 0 || curIndex == i) {
                hint[cursor] = -1;
                i++;
                cursor = i;
                continue;
            }
            hint[cursor] = -1;
            swapFunc(orig[cursor], orig[curIndex]);
            cursor = curIndex;
            cnt++;
        }
        return cnt;
    }

    /**
     * 随机项
     * @param array 源数组
     * @param cnt 随机抓取的元素数量
     * @param randomSort 是否乱序
     */
    public static function randomItem(array:Array, cnt:int = 1, randomSort:Boolean = true):Array {
        if (!array || array.length < cnt) {
            return null;
        }
        if (cnt == 1) {
            return [array[Math.floor(Math.random() * array.length)]];
        }
        var sort:Array = randomArray(array.length);
        if (!randomSort) {
            // 排序
            sort.sort();
        }
        var result:Array = [];
        var i:int = 0;
        var tmp:Array = [];
        for each (var item:* in array) {
            tmp[i++] = item;
        }
        var c:int = 0;
        for each (i in sort) {
            result.push(tmp[sort[i]]);
            if (++c == cnt) {
                break;
            }
        }
        return result;
    }

    /**
     * 剔除所有的null项
     */
    public static function compact(src:Array):Array {
        var result:Array = [];
        for each (var item:* in src) {
            if (item) {
                result.push(item);
            }
        }
        return result;
    }

    /**
     * 分别调用每个对象的方法并收集返回
     */
    public static function invoke(src:Array, func:String, ...params):Array {
        var len:int = src.length;
        var result:Array = [];
        // 此处必须用逆序避免出现invoke的代码中出现移除的逻辑导致崩溃
        for (var i:int = len - 1; i >= 0; i--) {
            var e:* = src[i];
            assert(e != null, "数组中存在空值");
            assert(e[func] != null, "对象中不存在调用函数", e, func);
            result.push((e[func] as Function).apply(null, params));
        }
        return result.reverse();
    }

    /**
     * 分别调用每个对象的方法并收集返回
     */
    public static function releaseInvoke(src:Array, func:String, ...params):void {
        var len:int = src.length;
        while (len--) {
            var e:* = src.pop();
            assert(e != null, "数组中存在空值");
            assert(e[func] != null, "对象中不存在调用函数", e, func);
            (e[func] as Function).apply(null, params);
        }
    }

    /**
     * 转换数字数组的字符串表达式
     * "1,2,3,4,5,6" => [1,2,3,4,5,6]
     */
    public static function parseIntString(str:String, delimiter:String = ","):Array {
        var list:Array = str.split(delimiter);
        var result:Array = [];
        for each (var e:String in list) {
            result.push(int(e));
        }
        return result;
    }

    /**
     * 转化点集字符串<br>
     * 支持两种格式
     * 独立的点
     * 1:1
     * 指定矩形区域
     * 1:1-10:10
     */
    public static function parsePointSetString(str:String):Array {
        var list:Array = [];
        for each (var region:Rectangle in parseResgionSetString(str)) {
            var start:Point = region.topLeft;
            var end:Point = region.bottomRight;
            for (var x:int = start.x; x < end.x; x++) {
                for (var y:int = start.y; y < end.y; y++) {
                    list.push(new Point(x, y));
                }
            }
        }
        return list;
    }

    /**
     * 取交集
     */
    public static function intersection(...array):Array {
        if (array.length == 0) {
            return null;
        }
        if (array.length == 1) {
            return array[0];
        }
        var result:Array = [];
        var map:Dictionary = new Dictionary();
        var lh:Array = array.pop();
        var elem:*;
        for each (elem in lh) {
            map[elem] = true;
        }
        var rh:Array = intersection.apply(null, array);
        for each (elem in rh) {
            if (elem in map) {
                result.push(elem);
            }
        }
        return result;
    }

    /**
     * 转化点集字符串<br>
     * 支持两种格式
     * 独立的点
     * 1:1
     * 指定矩形区域
     * 1:1-10:10
     */
    public static function parseResgionSetString(str:String):Array {
        var list:Array = [];
        for each (var region:String in str.split(",")) {
            var points:Array = region.split("-");
            var start:Point = parsePointString(points[0]);
            if (points.length == 2) {
                var end:Point = parsePointString(points[1]);
                list.push(new Rectangle(start.x, start.y, end.x - start.x + 1, end.y - start.y + 1));
            } else {
                list.push(new Rectangle(start.x, start.y, 1, 1));
            }
        }
        return list;
    }

    private static function parsePointString(str:String):Point {
        var tmp:Array = str.split(":");
        return new Point(int(tmp[0]), int(tmp[1]));
    }

    /**
     * 合并
     */
    public static function join(temp:Array, separator:String):String {
        var result:String = temp[0];
        for (var i:int = 1; i < temp.length; i++) {
            result += separator + temp[i];
        }
        return result;
    }

    /**
     * 排序(支持填充位)
     * 排序默认为按数字升序
     */
    public static function orderWithStuff(src:Array, prop:*, stuff:*, end:int = 0, start:int = 0):Array {
        var map:Array = collect(src, prop);
        var indices:Array = map.sort(Array.NUMERIC | Array.RETURNINDEXEDARRAY);
        var result:Array = [];
        for each (var index:int in indices) {
            for (var i:int = start; i < map[index]; i++) {
                result.push(stuff);
            }
            result.push(src[index]);
        }
        for (var j:int = map[indices[indices.length - 1]]; j < end; i++) {
            result.push(stuff);
        }
        return result;
    }

    /**
     * 移除一个项
     */
    public static function removeFromArray(src:Array, item:*, ignorOrder:Boolean = false):void {
        var index:int = src.indexOf(item);
        if (index < 0) {
            return;
        }
        if (ignorOrder) {
            src[index] = src[src.length - 1];
            src.pop();
        } else {
            src.splice(index, 1);
        }
    }

    /**
     * 将一个dictionary或者关联数组转化为一个数组
     */
    public static function toArray(source:*):Array {
        var result:Array = [];
        for each (var value:* in source) {
            result.push(value);
        }
        return result;
    }

    public static function isEmpty(source:Array):Boolean {
        if (!source) {
            return true;
        }
        return source.length == 0;
    }

    [Inline]
    /**
     * 清理数组
     */
    public static function clean(source:Array, ...other):void {
        source.splice(0, source.length);
        for each (var array:Array in other) {
            array.splice(0, array.length);
        }
    }

    /**
     * 移动一个元素
     */
    public static function move(item:*, source:Array, target:Array, position:int = -1):void {
        var index:int = source.indexOf(item);
        if (index < 0) {
            return;
        }
        source.splice(index, 1);
        if (position == -1) {
            target.push(item);
        } else {
            target.splice(position, -1, item);
        }
    }

    /**
     * 移动一个元素(数组不需要关心顺序)
     */
    public static function moveFast(item:*, source:Array, target:Array):void {
        var index:int = source.indexOf(item);
        if (index < 0) {
            return;
        }
        source[index] = source[source.length - 1];
        source.pop();
        target.push(item);
    }

    /**
     * 多个数组的调用
     */
    public static function forEachByArray(func:Function, src:Array, ...srcList):Array {
        var len:int = src.length;
        var i:int;
        var result:Array = [];
        for (i = 0; i < len; i++) {
            var args:Array = [src[i]];
            for each (var array:Array in srcList) {
                args.push(array[i]);
            }
            result.push(func.apply(null, args));
        }
        return result;
    }

    /**
     * 创建去重的版本
     */
    public static function createUniqueCopy(a:Array):Array {
        var newArray:Array = [];

        var len:Number = a.length;
        var item:Object;

        for (var i:uint = 0; i < len; ++i) {
            item = a[i];
            if (newArray.indexOf(item) >= 0) {
                continue;
            }
            newArray.push(item);
        }

        return newArray;
    }

    /**
     * 根据连个关联的属性排序
     * 排序暂时是不稳定的
     */
    public static function sortByLink(list:Array, lh:*, rh:*):int {
        if (list.length == 1) {
            return 0;
        }
        var tmp:Array = [];
        var item:*;
        for each (item in list) {
            var lhValue:*;
            if (lh is String) {
                lhValue = item[lh];
            } else if (lh is Function) {
                lhValue = lh(item);
            }
            var rhValue:*;
            if (rh is String) {
                rhValue = item[rh];
            } else if (rh is Function) {
                rhValue = rh(item);
            }
            tmp.push({lh: lhValue, rh: rhValue, source: item});
        }
        var headNode:* = {item: item = tmp.pop(), next: null};
        var endNode:* = headNode;
        while (tmp.length) {
            var found:Boolean = false;
            for (var i:int = tmp.length - 1; i >= 0; i--) {
                item = tmp[i];
                if (item["rh"] == headNode["item"]["lh"]) {
                    // 这个是头指针
                    headNode = {item: item, next: headNode};
                    found = true;
                    tmp.splice(i, 1);
                } else if (endNode["item"]["rh"] == item["lh"]) {
                    // 这个是尾指针
                    endNode["next"] = {item: item, next: null};
                    found = true;
                    tmp.splice(i, 1);
                }
            }
            if (found == false) {
                // 没有办法正常排序
                return -1;
            }
        }
        var hint:Array = [];
        var node:* = headNode;
        while (node) {
            hint.push(list.indexOf(node["item"]["source"]));
            node = node["next"];
        }
        hint.reverse();
        sortByHint(list, hint);
        return 0;
    }
}
}
