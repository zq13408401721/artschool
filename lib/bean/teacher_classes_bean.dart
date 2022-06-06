/// errno : 0
/// errmsg : ""
/// data : [{"id":3,"name":"A1班级","date":"2021-08-11 23:39:10","maxnum":500}]

class TeacherClassesBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  TeacherClassesBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  TeacherClassesBean.fromJson(dynamic json) {
    _errno = json['errno'];
    _errmsg = json['errmsg'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['errno'] = _errno;
    map['errmsg'] = _errmsg;
    if (_data != null) {
      map['data'] = _data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 3
/// name : "A1班级"
/// date : "2021-08-11 23:39:10"
/// maxnum : 500

class Data {
  int _id;
  String _name;
  String _date;
  int _maxnum;
  bool _select=false;

  int get id => _id;
  String get name => _name;
  String get date => _date;
  int get maxnum => _maxnum;
  bool get select => _select;
  set select(bool _bool){
    this._select = _bool;
  }

  Data({
      int id, 
      String name, 
      String date, 
      int maxnum}){
    _id = id;
    _name = name;
    _date = date;
    _maxnum = maxnum;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _date = json['date'];
    _maxnum = json['maxnum'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['date'] = _date;
    map['maxnum'] = _maxnum;
    return map;
  }

}