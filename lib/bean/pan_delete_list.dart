/// errno : 0
/// errmsg : ""
/// data : {"panids":["4","3"]}

class PanDeleteList {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  PanDeleteList({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  PanDeleteList.fromJson(dynamic json) {
    _errno = json["errno"];
    _errmsg = json["errmsg"];
    _data = json["data"] != null ? Data.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["errno"] = _errno;
    map["errmsg"] = _errmsg;
    if (_data != null) {
      map["data"] = _data.toJson();
    }
    return map;
  }

}

/// panids : ["4","3"]

class Data {
  List<String> _panids;

  List<String> get panids => _panids;

  Data({
      List<String> panids}){
    _panids = panids;
}

  Data.fromJson(dynamic json) {
    _panids = json["panids"] != null ? json["panids"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["panids"] = _panids;
    return map;
  }

}