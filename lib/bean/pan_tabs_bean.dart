/// errno : 0
/// errmsg : ""
/// data : [{"id":1,"name":"图片","type":"1","sort":1},{"id":2,"name":"步骤","type":"1","sort":2},{"id":3,"name":"考卷","type":"1","sort":3}]

class PanTabsBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  PanTabsBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  PanTabsBean.fromJson(dynamic json) {
    _errno = json["errno"];
    _errmsg = json["errmsg"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["errno"] = _errno;
    map["errmsg"] = _errmsg;
    if (_data != null) {
      map["data"] = _data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// name : "图片"
/// type : "1"
/// sort : 1

class Data {
  int _id;
  String _name;
  String _type;
  int _sort;

  int get id => _id;
  String get name => _name;
  String get type => _type;
  int get sort => _sort;

  Data({
      int id, 
      String name, 
      String type, 
      int sort}){
    _id = id;
    _name = name;
    _type = type;
    _sort = sort;
}

  Data.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _type = json["type"];
    _sort = json["sort"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    map["type"] = _type;
    map["sort"] = _sort;
    return map;
  }

}