/// errno : 0
/// errmsg : ""
/// data : {"result":"OK","pageIndex":1,"count":1,"records":[{"id":"B76840273C014E50","liveId":"52E878CF447E3417","startTime":"2021-11-24 14:49:39","stopTime":"2021-11-24 15:04:02","recordStatus":1,"recordVideoStatus":3,"recordVideoId":"EC2A29649DEB64ECFC9558351D509E7C","replayUrl":"https://view.csslcloud.net/api/view/callback?roomid=868BA34762DE7EDD9C33DC5901307461&userid=A478E06B5AA1107B&liveid=52E878CF447E3417&recordid=B76840273C014E50","templateType":3,"sourceType":0,"title":"44432","desc":""}]}

class RecordBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  RecordBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  RecordBean.fromJson(dynamic json) {
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

/// result : "OK"
/// pageIndex : 1
/// count : 1
/// records : [{"id":"B76840273C014E50","liveId":"52E878CF447E3417","startTime":"2021-11-24 14:49:39","stopTime":"2021-11-24 15:04:02","recordStatus":1,"recordVideoStatus":3,"recordVideoId":"EC2A29649DEB64ECFC9558351D509E7C","replayUrl":"https://view.csslcloud.net/api/view/callback?roomid=868BA34762DE7EDD9C33DC5901307461&userid=A478E06B5AA1107B&liveid=52E878CF447E3417&recordid=B76840273C014E50","templateType":3,"sourceType":0,"title":"44432","desc":""}]

class Data {
  String _result;
  int _pageIndex;
  int _count;
  List<Records> _records;

  String get result => _result;
  int get pageIndex => _pageIndex;
  int get count => _count;
  List<Records> get records => _records;

  Data({
      String result, 
      int pageIndex, 
      int count, 
      List<Records> records}){
    _result = result;
    _pageIndex = pageIndex;
    _count = count;
    _records = records;
}

  Data.fromJson(dynamic json) {
    _result = json['result'];
    _pageIndex = json['pageIndex'];
    _count = json['count'];
    if (json['records'] != null) {
      _records = [];
      json['records'].forEach((v) {
        _records.add(Records.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['result'] = _result;
    map['pageIndex'] = _pageIndex;
    map['count'] = _count;
    if (_records != null) {
      map['records'] = _records.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "B76840273C014E50"
/// liveId : "52E878CF447E3417"
/// startTime : "2021-11-24 14:49:39"
/// stopTime : "2021-11-24 15:04:02"
/// recordStatus : 1
/// recordVideoStatus : 3
/// recordVideoId : "EC2A29649DEB64ECFC9558351D509E7C"
/// replayUrl : "https://view.csslcloud.net/api/view/callback?roomid=868BA34762DE7EDD9C33DC5901307461&userid=A478E06B5AA1107B&liveid=52E878CF447E3417&recordid=B76840273C014E50"
/// templateType : 3
/// sourceType : 0
/// title : "44432"
/// desc : ""

class Records {
  String _id;
  String _liveId;
  String _startTime;
  String _stopTime;
  int _recordStatus;
  int _recordVideoStatus;
  String _recordVideoId;
  String _replayUrl;
  int _templateType;
  int _sourceType;
  String _title;
  String _desc;

  String get id => _id;
  String get liveId => _liveId;
  String get startTime => _startTime;
  String get stopTime => _stopTime;
  int get recordStatus => _recordStatus;
  int get recordVideoStatus => _recordVideoStatus;
  String get recordVideoId => _recordVideoId;
  String get replayUrl => _replayUrl;
  int get templateType => _templateType;
  int get sourceType => _sourceType;
  String get title => _title;
  String get desc => _desc;

  Records({
      String id, 
      String liveId, 
      String startTime, 
      String stopTime, 
      int recordStatus, 
      int recordVideoStatus, 
      String recordVideoId, 
      String replayUrl, 
      int templateType, 
      int sourceType, 
      String title, 
      String desc}){
    _id = id;
    _liveId = liveId;
    _startTime = startTime;
    _stopTime = stopTime;
    _recordStatus = recordStatus;
    _recordVideoStatus = recordVideoStatus;
    _recordVideoId = recordVideoId;
    _replayUrl = replayUrl;
    _templateType = templateType;
    _sourceType = sourceType;
    _title = title;
    _desc = desc;
}

  Records.fromJson(dynamic json) {
    _id = json['id'];
    _liveId = json['liveId'];
    _startTime = json['startTime'];
    _stopTime = json['stopTime'];
    _recordStatus = json['recordStatus'];
    _recordVideoStatus = json['recordVideoStatus'];
    _recordVideoId = json['recordVideoId'];
    _replayUrl = json['replayUrl'];
    _templateType = json['templateType'];
    _sourceType = json['sourceType'];
    _title = json['title'];
    _desc = json['desc'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['liveId'] = _liveId;
    map['startTime'] = _startTime;
    map['stopTime'] = _stopTime;
    map['recordStatus'] = _recordStatus;
    map['recordVideoStatus'] = _recordVideoStatus;
    map['recordVideoId'] = _recordVideoId;
    map['replayUrl'] = _replayUrl;
    map['templateType'] = _templateType;
    map['sourceType'] = _sourceType;
    map['title'] = _title;
    map['desc'] = _desc;
    return map;
  }

}