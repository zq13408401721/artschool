/// errno : 0
/// errmsg : ""
/// data : {"result":"OK","pageIndex":1,"count":3,"lives":[{"id":"B87BDCD642C7682B","startTime":"2021-11-24 20:21:09","endTime":"2021-11-24 20:37:02","recordVideoStatus":0,"templateType":3,"sourceType":0},{"id":"52E878CF447E3417","startTime":"2021-11-24 14:49:39","endTime":"2021-11-24 15:04:02","recordVideoStatus":0,"templateType":3,"sourceType":0},{"id":"D8015D11113162ED","startTime":"2021-11-24 14:40:49","endTime":"2021-11-24 14:41:16","recordVideoStatus":0,"templateType":3,"sourceType":0}]}

class LiveListBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  LiveListBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  LiveListBean.fromJson(dynamic json) {
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
/// count : 3
/// lives : [{"id":"B87BDCD642C7682B","startTime":"2021-11-24 20:21:09","endTime":"2021-11-24 20:37:02","recordVideoStatus":0,"templateType":3,"sourceType":0},{"id":"52E878CF447E3417","startTime":"2021-11-24 14:49:39","endTime":"2021-11-24 15:04:02","recordVideoStatus":0,"templateType":3,"sourceType":0},{"id":"D8015D11113162ED","startTime":"2021-11-24 14:40:49","endTime":"2021-11-24 14:41:16","recordVideoStatus":0,"templateType":3,"sourceType":0}]

class Data {
  String _result;
  int _pageIndex;
  int _count;
  List<Lives> _lives;

  String get result => _result;
  int get pageIndex => _pageIndex;
  int get count => _count;
  List<Lives> get lives => _lives;

  Data({
      String result, 
      int pageIndex, 
      int count, 
      List<Lives> lives}){
    _result = result;
    _pageIndex = pageIndex;
    _count = count;
    _lives = lives;
}

  Data.fromJson(dynamic json) {
    _result = json['result'];
    _pageIndex = json['pageIndex'];
    _count = json['count'];
    if (json['lives'] != null) {
      _lives = [];
      json['lives'].forEach((v) {
        _lives.add(Lives.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['result'] = _result;
    map['pageIndex'] = _pageIndex;
    map['count'] = _count;
    if (_lives != null) {
      map['lives'] = _lives.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "B87BDCD642C7682B"
/// startTime : "2021-11-24 20:21:09"
/// endTime : "2021-11-24 20:37:02"
/// recordVideoStatus : 0
/// templateType : 3
/// sourceType : 0

class Lives {
  String _id;
  String _startTime;
  String _endTime;
  int _recordVideoStatus;
  int _templateType;
  int _sourceType;

  String get id => _id;
  String get startTime => _startTime;
  String get endTime => _endTime;
  int get recordVideoStatus => _recordVideoStatus;
  int get templateType => _templateType;
  int get sourceType => _sourceType;

  Lives({
      String id, 
      String startTime, 
      String endTime, 
      int recordVideoStatus, 
      int templateType, 
      int sourceType}){
    _id = id;
    _startTime = startTime;
    _endTime = endTime;
    _recordVideoStatus = recordVideoStatus;
    _templateType = templateType;
    _sourceType = sourceType;
}

  Lives.fromJson(dynamic json) {
    _id = json['id'];
    _startTime = json['startTime'];
    _endTime = json['endTime'];
    _recordVideoStatus = json['recordVideoStatus'];
    _templateType = json['templateType'];
    _sourceType = json['sourceType'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['startTime'] = _startTime;
    map['endTime'] = _endTime;
    map['recordVideoStatus'] = _recordVideoStatus;
    map['templateType'] = _templateType;
    map['sourceType'] = _sourceType;
    return map;
  }

}