/// errno : 0
/// msg : ""
/// data : {"url":"/Users/zhangquan/work/art/img-server/files/3/5694e443-188c-492c-9d07-cf35461d8469/WechatIMG2.jpeg"}

class WorkUploadBean {
  int _errno;
  String _msg;
  Data _data;

  int get errno => _errno;
  String get msg => _msg;
  Data get data => _data;

  WorkUploadBean({
      int errno, 
      String msg, 
      Data data}){
    _errno = errno;
    _msg = msg;
    _data = data;
}

  WorkUploadBean.fromJson(dynamic json) {
    _errno = json['errno'];
    _msg = json['msg'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['errno'] = _errno;
    map['msg'] = _msg;
    if (_data != null) {
      map['data'] = _data.toJson();
    }
    return map;
  }

}

/// url : "/Users/zhangquan/work/art/img-server/files/3/5694e443-188c-492c-9d07-cf35461d8469/WechatIMG2.jpeg"

class Data {
  String _url;

  String get url => _url;

  Data({
      String url}){
    _url = url;
}

  Data.fromJson(dynamic json) {
    _url = json['url'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['url'] = _url;
    return map;
  }

}