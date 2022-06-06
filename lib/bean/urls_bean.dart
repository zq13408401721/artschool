/// errno : 0
/// errmsg : ""
/// data : {"id":1,"api_url":"http://res.yimios.com:9060/api","upload_url":"http://res.yimios.com:9090/api/","state":1}

class UrlsBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  UrlsBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  UrlsBean.fromJson(dynamic json) {
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

/// id : 1
/// api_url : "http://res.yimios.com:9060/api"
/// upload_url : "http://res.yimios.com:9090/api/"
/// state : 1

class Data {
  int _id;
  String _apiUrl;
  String _uploadUrl;
  int _state;

  int get id => _id;
  String get apiUrl => _apiUrl;
  String get uploadUrl => _uploadUrl;
  int get state => _state;

  Data({
      int id, 
      String apiUrl, 
      String uploadUrl, 
      int state}){
    _id = id;
    _apiUrl = apiUrl;
    _uploadUrl = uploadUrl;
    _state = state;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _apiUrl = json['api_url'];
    _uploadUrl = json['upload_url'];
    _state = json['state'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['api_url'] = _apiUrl;
    map['upload_url'] = _uploadUrl;
    map['state'] = _state;
    return map;
  }

}