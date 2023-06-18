class SchoolVideoGroupBean {
  SchoolVideoGroupBean({
      int errno, 
      String errmsg, 
      List<Data> data,}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  SchoolVideoGroupBean.fromJson(dynamic json) {
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
      int id, 
      String name, 
      String icon, 
      String description, 
      String createtime, 
      int tabid, 
      int iconWidth, 
      int iconHeight, 
      int iconMaxwidth, 
      int iconMaxheight, 
      int visible, 
      dynamic schoolid, 
      dynamic sort,}){
    _id = id;
    _name = name;
    _icon = icon;
    _description = description;
    _createtime = createtime;
    _tabid = tabid;
    _iconWidth = iconWidth;
    _iconHeight = iconHeight;
    _iconMaxwidth = iconMaxwidth;
    _iconMaxheight = iconMaxheight;
    _visible = visible;
    _schoolid = schoolid;
    _sort = sort;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _icon = json['icon'];
    _description = json['description'];
    _createtime = json['createtime'];
    _tabid = json['tabid'];
    _iconWidth = json['icon_width'];
    _iconHeight = json['icon_height'];
    _iconMaxwidth = json['icon_maxwidth'];
    _iconMaxheight = json['icon_maxheight'];
    _visible = json['visible'];
    _schoolid = json['schoolid'];
    _sort = json['sort'];
  }
  int _id;
  String _name;
  String _icon;
  String _description;
  String _createtime;
  int _tabid;
  int _iconWidth;
  int _iconHeight;
  int _iconMaxwidth;
  int _iconMaxheight;
  int _visible;
  dynamic _schoolid;
  dynamic _sort;

  int get id => _id;
  String get name => _name;
  String get icon => _icon;
  String get description => _description;
  String get createtime => _createtime;
  int get tabid => _tabid;
  int get iconWidth => _iconWidth;
  int get iconHeight => _iconHeight;
  int get iconMaxwidth => _iconMaxwidth;
  int get iconMaxheight => _iconMaxheight;
  int get visible => _visible;
  dynamic get schoolid => _schoolid;
  dynamic get sort => _sort;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['icon'] = _icon;
    map['description'] = _description;
    map['createtime'] = _createtime;
    map['tabid'] = _tabid;
    map['icon_width'] = _iconWidth;
    map['icon_height'] = _iconHeight;
    map['icon_maxwidth'] = _iconMaxwidth;
    map['icon_maxheight'] = _iconMaxheight;
    map['visible'] = _visible;
    map['schoolid'] = _schoolid;
    map['sort'] = _sort;
    return map;
  }

}