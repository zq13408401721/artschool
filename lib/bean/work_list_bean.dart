import 'package:yhschool/bean/work_score_bean.dart';

/// errno : 0
/// errmsg : ""
/// data : [{"id":1,"date":"2021-10-11","classid":3,"works":[{"id":1,"uid":"5694e443-188c-492c-9d07-cf35461d8469","createtime":"2021-10-11 16:29:51","url":"/Users/zhangquan/work/art/img-server/files/3/5694e443-188c-492c-9d07-cf35461d8469/WechatIMG2.jpeg","correct":null,"grade":0,"dateid":1}]}]

class WorkListBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  WorkListBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  WorkListBean.fromJson(dynamic json) {
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

/// id : 1
/// date : "2021-10-11"
/// classid : 3
/// works : [{"id":1,"uid":"5694e443-188c-492c-9d07-cf35461d8469","createtime":"2021-10-11 16:29:51","url":"/Users/zhangquan/work/art/img-server/files/3/5694e443-188c-492c-9d07-cf35461d8469/WechatIMG2.jpeg","correct":null,"grade":0,"dateid":1}]

class Data {
  int _id;
  String _date;
  int _classid;
  List<Works> _works;

  int get id => _id;
  String get date => _date;
  int get classid => _classid;
  List<Works> get works => _works;

  Data({
      int id, 
      String date, 
      int classid, 
      List<Works> works}){
    _id = id;
    _date = date;
    _classid = classid;
    _works = works;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _date = json['date'];
    _classid = json['classid'];
    if (json['works'] != null) {
      _works = [];
      json['works'].forEach((v) {
        _works.add(Works.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['date'] = _date;
    map['classid'] = _classid;
    if (_works != null) {
      map['works'] = _works.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// uid : "5694e443-188c-492c-9d07-cf35461d8469"
/// createtime : "2021-10-11 16:29:51"
/// url : "/Users/zhangquan/work/art/img-server/files/3/5694e443-188c-492c-9d07-cf35461d8469/WechatIMG2.jpeg"
/// correct : null
/// grade : 0
/// dateid : 1标记

class Works {
  int _id;
  String _uid;
  String _createtime;
  String _url;
  dynamic _correct;
  int _grade;
  int _dateid;
  int _width;
  int _height;
  String _name;
  String _author;
  int _maxwidth;
  int _maxheight;
  String _correct_uid;
  String _correct_time;
  String _correct_name;
  int _score;
  String _avater;

  WorkScoreBean _workScoreBean;
  WorkScoreBean get workScoreBean => _workScoreBean;
  set workScoreBean(value){
    _workScoreBean = value;
  }

  int get id => _id;
  String get uid => _uid;
  String get createtime => _createtime;
  String get url => _url;
  dynamic get correct => _correct;
  set correct(value){
    _correct = value;
  }
  int get grade => _grade;
  set grade(value){
    _grade = value;
  }
  int get dateid => _dateid;
  int get width => _width;
  int get height => _height;
  String get name => _name;
  String get author => _author;
  int get maxwidth => _maxwidth;
  int get maxheight => _maxheight;
  String get correct_uid => _correct_uid;
  set correct_uid(value){
    _correct_uid = value;
  }
  String get correct_time => _correct_time;
  set correct_time(value){
    _correct_time = value;
  }
  String get correct_name => _correct_name;
  set correct_name(value){
    _correct_name = value;
  }
  int get score => _score;
  String get avater => _avater;

  Works({
      int id, 
      String uid, 
      String createtime, 
      String url, 
      dynamic correct, 
      int grade, 
      int dateid,
      int width,
      int height,
      String name,
      String author,
      int maxwidth,
      int maxheight,
      String correct_uid,
      String correct_time,
      String correct_name,
      int score,
      String avater,}){
    _id = id;
    _uid = uid;
    _createtime = createtime;
    _url = url;
    _correct = correct;
    _grade = grade;
    _dateid = dateid;
    _width = width;
    _height = height;
    _name = name;
    _author = author;
    _maxwidth = maxwidth;
    _maxheight = maxheight;
    _correct_uid = correct_uid;
    _correct_time = correct_time;
    _correct_name = correct_name;
    _score = score;
    _avater = avater;
  }

  Works.fromJson(dynamic json) {
    _id = json['id'];
    _uid = json['uid'];
    _createtime = json['createtime'];
    _url = json['url'];
    _correct = json['correct'];
    _grade = json['grade'];
    _dateid = json['dateid'];
    _width = json['width'];
    _height = json['height'];
    _name = json['name'];
    _author = json['author'];
    _maxwidth = json['maxwidth'];
    _maxheight = json['maxheight'];
    _correct_uid = json['correct_uid'];
    _correct_time = json['correct_time'];
    _correct_name = json['correct_name'];
    _score = json['score'];
    _avater = json['avater'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['uid'] = _uid;
    map['createtime'] = _createtime;
    map['url'] = _url;
    map['correct'] = _correct;
    map['grade'] = _grade;
    map['dateid'] = _dateid;
    map['width'] = _width;
    map['height'] = _height;
    map['name'] = _name;
    map['author'] = _author;
    map['maxwidth'] = _maxwidth;
    map['maxheight'] = _maxheight;
    map['correct_uid'] = _correct_uid;
    map['correct_time'] = _correct_time;
    map['correct_name'] = _correct_name;
    map['score'] = _score;
    map['avater'] = _avater;
    return map;
  }

}