package kiwi.guieditor.utils {
import json.frigga.Frigga;
import json.frigga.report.FriggaReport;


public function readJSON(path:String, schemaPath:String = null):* {
    var json:* = JSON.parse(readFile(path));
    if (schemaPath) {
        var report:FriggaReport = Frigga.forSchema(JSON.parse(readFile(schemaPath))).validate(json);
        if (!report.isValid()) {
            throw new Error(sprintf("%s 不合法:%s", path, report.getMessagesAsString()));
        }
    }
    return json;
}
}