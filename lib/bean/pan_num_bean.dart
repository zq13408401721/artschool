class PanNumBean {
  PanNumBean({
      int errno, 
      String errmsg, 
      List<Data> data,}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  PanNumBean.fromJson(dynamic json) {
    _errno = json['errno'];
    _errmsg = json['errmsg'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data.add(Data.fromJson(v));
      });
    }
  }
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
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
      int pannum, 
      int schoolnum, 
      int selfnum,}){
    _pannum = pannum;
    _schoolnum = schoolnum;
    _selfnum = selfnum;
  }

  Data.fromJson(dynamic json) {
    _pannum = json['pannum'];
    _schoolnum = json['schoolnum'];
    _selfnum = json['selfnum'];
  }
  int _pannum;
  int _schoolnum;
  int _selfnum;

  int get pannum => _pannum;
  int get schoolnum => _schoolnum;
  int get selfnum => _selfnum;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pannum'] = _pannum;
    map['schoolnum'] = _schoolnum;
    map['selfnum'] = _selfnum;
    return map;
  }

}