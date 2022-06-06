/// errno : 0
/// errmsg : ""
/// data : {"folderids":["9"]}

class PanDeleteFolder {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  PanDeleteFolder({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  PanDeleteFolder.fromJson(dynamic json) {
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

/// folderids : ["9"]

class Data {
  List<String> _folderids;

  List<String> get folderids => _folderids;

  Data({
      List<String> folderids}){
    _folderids = folderids;
}

  Data.fromJson(dynamic json) {
    _folderids = json["folderids"] != null ? json["folderids"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["folderids"] = _folderids;
    return map;
  }

}