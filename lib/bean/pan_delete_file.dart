/// errno : 0
/// errmsg : ""
/// data : {"fids":["42","43"]}

class PanDeleteFile {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  PanDeleteFile({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  PanDeleteFile.fromJson(dynamic json) {
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

/// fids : ["42","43"]

class Data {
  List<String> _fids;

  List<String> get fids => _fids;

  Data({
      List<String> fids}){
    _fids = fids;
}

  Data.fromJson(dynamic json) {
    _fids = json["fids"] != null ? json["fids"].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["fids"] = _fids;
    return map;
  }

}