package kiwi.guieditor.utils {
import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

/**
 * @author zhangming.luo
 */
public function readFile(path:String):String {
    var fs:FileStream = new FileStream();
    fs.open(File.applicationDirectory.resolvePath(path), FileMode.READ);
    var content:String = fs.readUTFBytes(fs.bytesAvailable);
    fs.close();
    return content;
}
}
