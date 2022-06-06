/// errno : 0
/// errmsg : ""
/// data : [{"id":249,"date_id":26,"tid":"d1e92c59-d595-4e40-9631-a4fa021d16b4","name":"Teacher020","date":"2021-07-07 08:26:15","url":"http://res.yimios.com:9050/1372445644860735500/d1e92c59-d595-4e40-9631-a4fa021d16b4/FullSizeRender.jpg"},{"id":247,"date_id":26,"tid":"b4e4909f-6cf3-497e-981b-13449e438ea3","name":"student1","date":"2021-07-07 08:15:54","url":"http://res.yimios.com:9050/1372445644860735500/b4e4909f-6cf3-497e-981b-13449e438ea3/IMG_0321.JPG"},{"id":246,"date_id":26,"tid":"b4e4909f-6cf3-497e-981b-13449e438ea3","name":"student1","date":"2021-07-07 08:15:54","url":"http://res.yimios.com:9050/1372445644860735500/b4e4909f-6cf3-497e-981b-13449e438ea3/IMG_0322.JPG"},{"id":245,"date_id":26,"tid":"b4e4909f-6cf3-497e-981b-13449e438ea3","name":"student1","date":"2021-07-07 07:40:32","url":"http://res.yimios.com:9050/1372445644860735500/b4e4909f-6cf3-497e-981b-13449e438ea3/yoka_1625554355081.JPEG"},{"id":243,"date_id":26,"tid":"b4e4909f-6cf3-497e-981b-13449e438ea3","name":"student1","date":"2021-07-07 05:34:40","url":"http://res.yimios.com:9050/1372445644860735500/b4e4909f-6cf3-497e-981b-13449e438ea3/IMG_0018.JPG"},{"id":239,"date_id":26,"tid":"b4e4909f-6cf3-497e-981b-13449e438ea3","name":"student1","date":"2021-07-07 05:27:17","url":"http://res.yimios.com:9050/1372445644860735500/b4e4909f-6cf3-497e-981b-13449e438ea3/IMG_4306.JPG"},{"id":238,"date_id":26,"tid":"b4e4909f-6cf3-497e-981b-13449e438ea3","name":"student1","date":"2021-07-07 05:23:55","url":"http://res.yimios.com:9050/1372445644860735500/b4e4909f-6cf3-497e-981b-13449e438ea3/IMG_4306.JPG"},{"id":224,"date_id":26,"tid":"b4e4909f-6cf3-497e-981b-13449e438ea3","name":"student1","date":"2021-07-07 05:10:08","url":"http://res.yimios.com:9050/1372445644860735500/b4e4909f-6cf3-497e-981b-13449e438ea3/IMG_0017.JPG"},{"id":223,"date_id":26,"tid":"b4e4909f-6cf3-497e-981b-13449e438ea3","name":"student1","date":"2021-07-07 03:27:06","url":"http://res.yimios.com:9050/1372445644860735500/b4e4909f-6cf3-497e-981b-13449e438ea3/IMG_0016.JPG"},{"id":222,"date_id":26,"tid":"b4e4909f-6cf3-497e-981b-13449e438ea3","name":"student1","date":"2021-07-07 03:27:06","url":"http://res.yimios.com:9050/1372445644860735500/b4e4909f-6cf3-497e-981b-13449e438ea3/IMG_0014.JPG"}]

class IssueMoreBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  IssueMoreBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  IssueMoreBean.fromJson(dynamic json) {
    _errno = json["errno"];
    _errmsg = json["errmsg"];
    if (json["data"] != null) {
      _data = [];
      json["data"].forEach((v) {
        _data.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["errno"] = _errno;
    map["errmsg"] = _errmsg;
    if (_data != null) {
      map["data"] = _data.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 249
/// date_id : 26
/// tid : "d1e92c59-d595-4e40-9631-a4fa021d16b4"
/// name : "Teacher020"
/// date : "2021-07-07 08:26:15"
/// url : "http://res.yimios.com:9050/1372445644860735500/d1e92c59-d595-4e40-9631-a4fa021d16b4/FullSizeRender.jpg"

class Data {
  int _id;
  int _dateId;
  String _tid;
  String _name;
  String _date;
  String _url;

  int get id => _id;
  int get dateId => _dateId;
  String get tid => _tid;
  String get name => _name;
  String get date => _date;
  String get url => _url;

  Data({
      int id, 
      int dateId, 
      String tid, 
      String name, 
      String date, 
      String url}){
    _id = id;
    _dateId = dateId;
    _tid = tid;
    _name = name;
    _date = date;
    _url = url;
}

  Data.fromJson(dynamic json) {
    _id = json["id"];
    _dateId = json["date_id"];
    _tid = json["tid"];
    _name = json["name"];
    _date = json["date"];
    _url = json["url"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["date_id"] = _dateId;
    map["tid"] = _tid;
    map["name"] = _name;
    map["date"] = _date;
    map["url"] = _url;
    return map;
  }

}