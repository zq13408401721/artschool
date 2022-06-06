/// errno : 0
/// errmsg : ""
/// data : {"playurl":"https://view.csslcloud.net/api/view/index?roomid=868BA34762DE7EDD9C33DC5901307461&userid=A478E06B5AA1107B","pushurl":"https://view.csslcloud.net/api/view/lecturer?roomid=868BA34762DE7EDD9C33DC5901307461&userid=A478E06B5AA1107B","qrurl":"http://res.yimios.com:9050/videos/school/1/868BA34762DE7EDD9C33DC5901307461.png","schoolname":"艺画美术官方"}

class SchoolLiveRoomInfoBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  SchoolLiveRoomInfoBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  SchoolLiveRoomInfoBean.fromJson(dynamic json) {
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

/// playurl : "https://view.csslcloud.net/api/view/index?roomid=868BA34762DE7EDD9C33DC5901307461&userid=A478E06B5AA1107B"
/// pushurl : "https://view.csslcloud.net/api/view/lecturer?roomid=868BA34762DE7EDD9C33DC5901307461&userid=A478E06B5AA1107B"
/// qrurl : "http://res.yimios.com:9050/videos/school/1/868BA34762DE7EDD9C33DC5901307461.png"
/// schoolname : "艺画美术官方"

class Data {
  String _playurl;
  String _pushurl;
  String _qrurl;
  String _schoolname;

  String get playurl => _playurl;
  String get pushurl => _pushurl;
  String get qrurl => _qrurl;
  String get schoolname => _schoolname;

  Data({
      String playurl, 
      String pushurl, 
      String qrurl, 
      String schoolname}){
    _playurl = playurl;
    _pushurl = pushurl;
    _qrurl = qrurl;
    _schoolname = schoolname;
}

  Data.fromJson(dynamic json) {
    _playurl = json['playurl'];
    _pushurl = json['pushurl'];
    _qrurl = json['qrurl'];
    _schoolname = json['schoolname'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['playurl'] = _playurl;
    map['pushurl'] = _pushurl;
    map['qrurl'] = _qrurl;
    map['schoolname'] = _schoolname;
    return map;
  }

}