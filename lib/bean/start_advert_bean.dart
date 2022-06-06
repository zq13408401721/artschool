/// errno : 0
/// errmsg : ""
/// data : {"id":1,"videourl":"http://res.yimios.com:9050/videos/fb9ccb7e9964d0acd5fcf23d0d32908d.mp4","title":"Hi,亲爱的同学们！","word1":"云视频是艺画美术为同学们精心制作的一套系统美术教学视频课程，共350个课程，每天学习30分钟，3个月提高30分，","word2":"的同学们可免费学习所有课程。","tab_title1":"美院教授教研，一线名师制作课程","tab_title2":"系统体系，初级至高级全覆盖","tab_title3":"理论精讲，详细剖析作画内部原理","tab_title4":"步骤教学，科学拆解作画全过程","tab_title5":"高清无损，零广告，纯净高清","label":"开始学习！3个月提高30分","active":1,"time":"2021-09-28 17:04:35"}

class StartAdvertBean {
  int _errno;
  String _errmsg;
  Data _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  Data get data => _data;

  StartAdvertBean({
      int errno, 
      String errmsg, 
      Data data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  StartAdvertBean.fromJson(dynamic json) {
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
/// videourl : "http://res.yimios.com:9050/videos/fb9ccb7e9964d0acd5fcf23d0d32908d.mp4"
/// title : "Hi,亲爱的同学们！"
/// word1 : "云视频是艺画美术为同学们精心制作的一套系统美术教学视频课程，共350个课程，每天学习30分钟，3个月提高30分，"
/// word2 : "的同学们可免费学习所有课程。"
/// tab_title1 : "美院教授教研，一线名师制作课程"
/// tab_title2 : "系统体系，初级至高级全覆盖"
/// tab_title3 : "理论精讲，详细剖析作画内部原理"
/// tab_title4 : "步骤教学，科学拆解作画全过程"
/// tab_title5 : "高清无损，零广告，纯净高清"
/// label : "开始学习！3个月提高30分"
/// active : 1
/// time : "2021-09-28 17:04:35"

class Data {
  int _id;
  String _videourl;
  String _title;
  String _word1;
  String _word2;
  String _tabTitle1;
  String _tabTitle2;
  String _tabTitle3;
  String _tabTitle4;
  String _tabTitle5;
  String _label;
  int _active;
  String _time;

  int get id => _id;
  String get videourl => _videourl;
  String get title => _title;
  String get word1 => _word1;
  String get word2 => _word2;
  String get tabTitle1 => _tabTitle1;
  String get tabTitle2 => _tabTitle2;
  String get tabTitle3 => _tabTitle3;
  String get tabTitle4 => _tabTitle4;
  String get tabTitle5 => _tabTitle5;
  String get label => _label;
  int get active => _active;
  String get time => _time;

  Data({
      int id, 
      String videourl, 
      String title, 
      String word1, 
      String word2, 
      String tabTitle1, 
      String tabTitle2, 
      String tabTitle3, 
      String tabTitle4, 
      String tabTitle5, 
      String label, 
      int active, 
      String time}){
    _id = id;
    _videourl = videourl;
    _title = title;
    _word1 = word1;
    _word2 = word2;
    _tabTitle1 = tabTitle1;
    _tabTitle2 = tabTitle2;
    _tabTitle3 = tabTitle3;
    _tabTitle4 = tabTitle4;
    _tabTitle5 = tabTitle5;
    _label = label;
    _active = active;
    _time = time;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _videourl = json['videourl'];
    _title = json['title'];
    _word1 = json['word1'];
    _word2 = json['word2'];
    _tabTitle1 = json['tab_title1'];
    _tabTitle2 = json['tab_title2'];
    _tabTitle3 = json['tab_title3'];
    _tabTitle4 = json['tab_title4'];
    _tabTitle5 = json['tab_title5'];
    _label = json['label'];
    _active = json['active'];
    _time = json['time'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['videourl'] = _videourl;
    map['title'] = _title;
    map['word1'] = _word1;
    map['word2'] = _word2;
    map['tab_title1'] = _tabTitle1;
    map['tab_title2'] = _tabTitle2;
    map['tab_title3'] = _tabTitle3;
    map['tab_title4'] = _tabTitle4;
    map['tab_title5'] = _tabTitle5;
    map['label'] = _label;
    map['active'] = _active;
    map['time'] = _time;
    return map;
  }

}