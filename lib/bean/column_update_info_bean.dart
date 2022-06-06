/// errno : 0
/// errmsg : ""
/// data : {"columnid":16}

class ColumnUpdateInfoBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  ColumnUpdateInfoBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  ColumnUpdateInfoBean.fromJson(dynamic json) {
    _errno = json['errno'];
    _errmsg = json['errmsg'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['errno'] = _errno;
    map['errmsg'] = _errmsg;
    if (_data != null) {
      map['data'] = _data.toJson();
    }
    return map;
  }

}

/// columnid : 16

class Data {
  int _columnid;

  int get columnid => _columnid;

  Data({
      int columnid}){
    _columnid = columnid;
}

  Data.fromJson(dynamic json) {
    _columnid = json['columnid'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['columnid'] = _columnid;
    return map;
  }

}