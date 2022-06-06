/// result : "OK"
/// room : {"id":"868BA34762DE7EDD9C33DC5901307461","name":"山下一猴子","desc":"山下一猴子请来了一个小姐姐","status":10,"authtype":2,"liveStartTime":"2021-12-02 20:59:00","liveState":0,"playurl":"https://view.csslcloud.net/api/view/index?roomid=868BA34762DE7EDD9C33DC5901307461&userid=A478E06B5AA1107B","pushurl":"https://view.csslcloud.net/api/view/lecturer?roomid=868BA34762DE7EDD9C33DC5901307461&userid=A478E06B5AA1107B","qrurl":"http://res.yimios.com:9050/videos/school/1/868BA34762DE7EDD9C33DC5901307461.png","schoolname":"艺画美术官方"}

class LiveRoomInfoBean {
  String _result;
  Room _room;

  String get result => _result;
  Room get room => _room;

  LiveRoomInfoBean({
      String result, 
      Room room}){
    _result = result;
    _room = room;
}

  LiveRoomInfoBean.fromJson(dynamic json) {
    _result = json['result'];
    _room = json['room'] != null ? Room.fromJson(json['room']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['result'] = _result;
    if (_room != null) {
      map['room'] = _room.toJson();
    }
    return map;
  }

}

/// id : "868BA34762DE7EDD9C33DC5901307461"
/// name : "山下一猴子"
/// desc : "山下一猴子请来了一个小姐姐"
/// status : 10
/// authtype : 2
/// liveStartTime : "2021-12-02 20:59:00"
/// liveState : 0
/// playurl : "https://view.csslcloud.net/api/view/index?roomid=868BA34762DE7EDD9C33DC5901307461&userid=A478E06B5AA1107B"
/// pushurl : "https://view.csslcloud.net/api/view/lecturer?roomid=868BA34762DE7EDD9C33DC5901307461&userid=A478E06B5AA1107B"
/// qrurl : "http://res.yimios.com:9050/videos/school/1/868BA34762DE7EDD9C33DC5901307461.png"
/// schoolname : "艺画美术官方"

class Room {
  String _id;
  String _name;
  String _desc;
  int _status;
  int _authtype;
  String _liveStartTime;
  int _liveState;
  String _playurl;
  String _pushurl;
  String _qrurl;
  String _schoolname;

  String get id => _id;
  String get name => _name;
  set name(value){
    this._name = value;
  }
  String get desc => _desc;
  set desc(value){
    this._desc = value;
  }
  int get status => _status;
  int get authtype => _authtype;
  String get liveStartTime => _liveStartTime;
  set liveStartTime(value){
    this._liveStartTime = value;
  }
  int get liveState => _liveState;
  String get playurl => _playurl;
  String get pushurl => _pushurl;
  String get qrurl => _qrurl;
  String get schoolname => _schoolname;

  Room({
      String id, 
      String name, 
      String desc, 
      int status, 
      int authtype, 
      String liveStartTime, 
      int liveState, 
      String playurl, 
      String pushurl, 
      String qrurl, 
      String schoolname}){
    _id = id;
    _name = name;
    _desc = desc;
    _status = status;
    _authtype = authtype;
    _liveStartTime = liveStartTime;
    _liveState = liveState;
    _playurl = playurl;
    _pushurl = pushurl;
    _qrurl = qrurl;
    _schoolname = schoolname;
}

  Room.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _desc = json['desc'];
    _status = json['status'];
    _authtype = json['authtype'];
    _liveStartTime = json['liveStartTime'];
    _liveState = json['liveState'];
    _playurl = json['playurl'];
    _pushurl = json['pushurl'];
    _qrurl = json['qrurl'];
    _schoolname = json['schoolname'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['desc'] = _desc;
    map['status'] = _status;
    map['authtype'] = _authtype;
    map['liveStartTime'] = _liveStartTime;
    map['liveState'] = _liveState;
    map['playurl'] = _playurl;
    map['pushurl'] = _pushurl;
    map['qrurl'] = _qrurl;
    map['schoolname'] = _schoolname;
    return map;
  }

}