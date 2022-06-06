/// errno : 0
/// errmsg : ""
/// data : {"roomid":"868BA34762DE7EDD9C33DC5901307461","qr_code":"https://admin.bokecc.com/liveroom/qrcodepic.bo?roomid=868BA34762DE7EDD9C33DC5901307461"}

class LiveRoomBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  LiveRoomBean({
    int errno,
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  LiveRoomBean.fromJson(dynamic json) {
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

/// roomid : "868BA34762DE7EDD9C33DC5901307461"
/// qr_code : "https://admin.bokecc.com/liveroom/qrcodepic.bo?roomid=868BA34762DE7EDD9C33DC5901307461"

class Data {
  String _roomid;
  String _qrCode;

  String get roomid => _roomid;
  String get qrCode => _qrCode;

  Data({
      String roomid, 
      String qrCode}){
    _roomid = roomid;
    _qrCode = qrCode;
}

  Data.fromJson(dynamic json) {
    _roomid = json['roomid'];
    _qrCode = json['qr_code'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['roomid'] = _roomid;
    map['qr_code'] = _qrCode;
    return map;
  }

}