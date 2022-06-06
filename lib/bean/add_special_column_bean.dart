/// errno : 0
/// errmsg : ""
/// data : {"type":"1","name":"写生照片","visible":"0","createtime":"2021-10-16 16:56:00","uid":"b4e4909f-6cf3-497e-981b-13449e438ea3","schoolid":"1372445644860735500","id":1}

class AddSpecialColumnBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  AddSpecialColumnBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  AddSpecialColumnBean.fromJson(dynamic json) {
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

/// type : "1"
/// name : "写生照片"
/// visible : "0"
/// createtime : "2021-10-16 16:56:00"
/// uid : "b4e4909f-6cf3-497e-981b-13449e438ea3"
/// schoolid : "1372445644860735500"
/// id : 1

class Data {
  int _type;
  String _name;
  int _visible;
  String _createtime;
  String _uid;
  String _schoolid;
  int _id;

  int get type => _type;
  String get name => _name;
  int get visible => _visible;
  String get createtime => _createtime;
  String get uid => _uid;
  String get schoolid => _schoolid;
  int get id => _id;

  Data({
      int type,
      String name, 
      int visible,
      String createtime, 
      String uid, 
      String schoolid, 
      int id}){
    _type = type;
    _name = name;
    _visible = visible;
    _createtime = createtime;
    _uid = uid;
    _schoolid = schoolid;
    _id = id;
}

  Data.fromJson(dynamic json) {
    _type = json['type'];
    _name = json['name'];
    _visible = json['visible'];
    _createtime = json['createtime'];
    _uid = json['uid'];
    _schoolid = json['schoolid'];
    _id = json['id'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['type'] = _type;
    map['name'] = _name;
    map['visible'] = _visible;
    map['createtime'] = _createtime;
    map['uid'] = _uid;
    map['schoolid'] = _schoolid;
    map['id'] = _id;
    return map;
  }

}