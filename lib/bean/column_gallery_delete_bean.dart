/// errno : 0
/// errmsg : ""
/// data : 1

class ColumnGalleryDeleteBean {
  int _errno;
  String _errmsg;
  int _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  int get data => _data;

  ColumnGalleryDeleteBean({
      int errno, 
      String errmsg, 
      int data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  ColumnGalleryDeleteBean.fromJson(dynamic json) {
    _errno = json['errno'];
    _errmsg = json['errmsg'];
    _data = json['data'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['errno'] = _errno;
    map['errmsg'] = _errmsg;
    map['data'] = _data;
    return map;
  }

}