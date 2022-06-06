/// errno : 0
/// errmsg : ""
/// data : {"id":3,"score":88,"workid":20,"uid":"41246ea0-9595-4619-b67c-35ffc03f295c","username":"yihua_teacher1","nickname":null}

class WorkScoreBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  WorkScoreBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  WorkScoreBean.fromJson(dynamic json) {
    _errno = json['errno'];
    _errmsg = json['errmsg'];
    _data = (json['data'] != null && json['data'].length > 0) ? Data.fromJson(json['data']) : null;
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

/// id : 3
/// score : 88
/// workid : 20
/// uid : "41246ea0-9595-4619-b67c-35ffc03f295c"
/// username : "yihua_teacher1"
/// nickname : null

class Data {
  int _id;
  int _score;
  int _workid;
  String _uid;
  String _username;
  dynamic _nickname;

  int get id => _id;
  int get score => _score;
  int get workid => _workid;
  String get uid => _uid;
  String get username => _username;
  dynamic get nickname => _nickname;

  Data({
      int id, 
      int score, 
      int workid, 
      String uid, 
      String username, 
      dynamic nickname}){
    _id = id;
    _score = score;
    _workid = workid;
    _uid = uid;
    _username = username;
    _nickname = nickname;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _score = json['score'];
    _workid = json['workid'];
    _uid = json['uid'];
    _username = json['username'];
    _nickname = json['nickname'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['score'] = _score;
    map['workid'] = _workid;
    map['uid'] = _uid;
    map['username'] = _username;
    map['nickname'] = _nickname;
    return map;
  }

}