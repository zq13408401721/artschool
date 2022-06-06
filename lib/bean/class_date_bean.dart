/// errno : 0
/// errmsg : ""
/// data : {"dates":[{"classid":"6","dateid":151},{"classid":"5","dateid":152}]}

class ClassDateBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  ClassDateBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  ClassDateBean.fromJson(dynamic json) {
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

/// dates : [{"classid":"6","dateid":151},{"classid":"5","dateid":152}]

class Data {
  List<Dates> _dates;

  List<Dates> get dates => _dates;

  Data({
      List<Dates> dates}){
    _dates = dates;
}

  Data.fromJson(dynamic json) {
    if (json['dates'] != null) {
      _dates = [];
      json['dates'].forEach((v) {
        _dates.add(Dates.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_dates != null) {
      map['dates'] = _dates.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// classid : "6"
/// dateid : 151

class Dates {
  String _classid;
  int _dateid;

  String get classid => _classid;
  int get dateid => _dateid;

  Dates({
      String classid, 
      int dateid}){
    _classid = classid;
    _dateid = dateid;
}

  Dates.fromJson(dynamic json) {
    _classid = json['classid'];
    _dateid = json['dateid'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['classid'] = _classid;
    map['dateid'] = _dateid;
    return map;
  }

}