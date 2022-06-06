/// errno : 0
/// msg : ""
/// data : {"correct":"/Users/zhangquan/work/art/img-server/files/3/e82cf39e-dfa1-45db-90dc-f5a6035a3b15/IMG_0056_correct(1)(1)(1)(1).png","correct_uid":"b4e4909f-6cf3-497e-981b-13449e438ea3","correct_time":"2021-10-13 15:24:15"}

class WorkCorrectBean {
  int _errno;
  String _msg;
  Data _data;

  int get errno => _errno;
  String get msg => _msg;
  Data get data => _data;

  WorkCorrectBean({
      int errno, 
      String msg, 
      Data data}){
    _errno = errno;
    _msg = msg;
    _data = data;
}

  WorkCorrectBean.fromJson(dynamic json) {
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

/// correct : "/Users/zhangquan/work/art/img-server/files/3/e82cf39e-dfa1-45db-90dc-f5a6035a3b15/IMG_0056_correct(1)(1)(1)(1).png"
/// correct_uid : "b4e4909f-6cf3-497e-981b-13449e438ea3"
/// correct_time : "2021-10-13 15:24:15"

class Data {
  String _correct;
  String _correctUid;
  String _correctTime;

  String get correct => _correct;
  String get correctUid => _correctUid;
  String get correctTime => _correctTime;

  Data({
      String correct, 
      String correctUid, 
      String correctTime}){
    _correct = correct;
    _correctUid = correctUid;
    _correctTime = correctTime;
}

  Data.fromJson(dynamic json) {
    _correct = json['correct'];
    _correctUid = json['correct_uid'];
    _correctTime = json['correct_time'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['correct'] = _correct;
    map['correct_uid'] = _correctUid;
    map['correct_time'] = _correctTime;
    return map;
  }

}