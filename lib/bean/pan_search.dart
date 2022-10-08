class PanSearch {
  PanSearch({
      num errno, 
      String errmsg, 
      List<Data> data,}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  PanSearch.fromJson(dynamic json) {
    _errno = json['errno'];
    _errmsg = json['errmsg'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data.add(Data.fromJson(v));
      });
    }
  }
  num _errno;
  String _errmsg;
  List<Data> _data;

  num get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['errno'] = _errno;
    map['errmsg'] = _errmsg;
    if (_data != null) {
      map['data'] = _data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class Data {
  Data({
      num id, 
      String panid, 
      String name, 
      String date, 
      String uid, 
      num classifyid, 
      num state, 
      String schoolid, 
      num visible, 
      num isself, 
      String topdate, 
      num top,}){
    _id = id;
    _panid = panid;
    _name = name;
    _date = date;
    _uid = uid;
    _classifyid = classifyid;
    _state = state;
    _schoolid = schoolid;
    _visible = visible;
    _isself = isself;
    _topdate = topdate;
    _top = top;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _panid = json['panid'];
    _name = json['name'];
    _date = json['date'];
    _uid = json['uid'];
    _classifyid = json['classifyid'];
    _state = json['state'];
    _schoolid = json['schoolid'];
    _visible = json['visible'];
    _isself = json['isself'];
    _topdate = json['topdate'];
    _top = json['top'];
  }
  num _id;
  String _panid;
  String _name;
  String _date;
  String _uid;
  num _classifyid;
  num _state;
  String _schoolid;
  num _visible;
  num _isself;
  String _topdate;
  num _top;

  num get id => _id;
  String get panid => _panid;
  String get name => _name;
  String get date => _date;
  String get uid => _uid;
  num get classifyid => _classifyid;
  num get state => _state;
  String get schoolid => _schoolid;
  num get visible => _visible;
  num get isself => _isself;
  String get topdate => _topdate;
  num get top => _top;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['panid'] = _panid;
    map['name'] = _name;
    map['date'] = _date;
    map['uid'] = _uid;
    map['classifyid'] = _classifyid;
    map['state'] = _state;
    map['schoolid'] = _schoolid;
    map['visible'] = _visible;
    map['isself'] = _isself;
    map['topdate'] = _topdate;
    map['top'] = _top;
    return map;
  }

}