/// errno : 0
/// errmsg : ""
/// data : [{"id":6,"title":"色彩/色彩头像","categoryid":361,"createtime":"2021-11-12 19:22:37","sort":6,"name":"完整稿男老年","cover":"http://res.yimios.com:9050/videos/cover/15完整稿男老年.jpg","description":"本系列课程，是素描和色彩学习的高级阶段。人物色彩肖像对颜色表现、形体塑造都有非常高的要求。本套课程从五官的三个角度，详细的演示了五官作画方法和技巧；用12个不同性别与年龄的人物从色稿到完整画面的示范演示，你会学习到色彩肖像的构图、色调、造型及人物气质的表现方法。"},{"id":5,"title":"色彩/组合完整稿","categoryid":428,"createtime":"2021-11-12 19:22:33","sort":5,"name":"酒具桃子花朵","cover":"http://res.yimios.com:9050/videos/cover/2酒具桃子花朵.jpg","description":"本系列课程，是在色稿的基础上，进一步学习如何深入处理画面，直至完成一幅作品。如：物体细节的刻画技巧、画面虚实处理方法等。一幅具有艺术高度的色彩静物画面，首先需要色调统一、画面完整，视觉中心刻画精彩、空间虚实关系得当，构图具有观赏性有视觉冲击力。"},{"id":4,"title":"素描/人物头像","categoryid":230,"createtime":"2021-11-12 19:22:30","sort":4,"name":"卷发男青年","cover":"http://res.yimios.com:9050/videos/cover/1卷发男青年.jpg","description":"本系列课程，是每一个美术爱好者都向往的章节。你会通过对一幅幅精彩绝伦的人物肖像素描的学习，深入了解人物头像头骨结构、肌肉规律，掌握人物头像的基本规律，通过对不同人物的塑造，了解人物头像大关系下的个体差异特征，学会准确且生动的人物头像表现技巧。熟能生巧，反复的训练、用心的体会，你会在绘画的道路上走的更远更高！"},{"id":3,"title":"素描/静物组合","categoryid":95,"createtime":"2021-11-12 19:22:26","sort":3,"name":"素描质感技巧","cover":"http://res.yimios.com:9050/videos/cover/质感.jpg","description":"本系列基础课程，是新手入门必须掌握的基础知识。你会了解物体造型的基本方法，如：物体的黑白灰关系、透视规律、空间关系、质感表达等；同时你也会掌握绘画的基础技巧，如：排线方法、揉擦技巧等。"},{"id":2,"title":"素描/静物单体","categoryid":169,"createtime":"2021-11-12 19:22:22","sort":2,"name":"白菜光影","cover":"http://res.yimios.com:9050/videos/cover/29白菜光影.jpg","description":"本系列课程，是初学者从简单规则形体向复杂物体塑造的过渡阶段。你会通过对圆形、方形、椭圆形等物体，如：苹果、梨子、盒子等，学会如何把复杂的形体归纳为简单的几何体，再从复杂的几何体细分到具体的形，简单而奇妙；你会通过对不同深浅颜色物体的黑白灰塑造，学会如何掌控黑白灰的细微变化，画出各种不同颜色、不同质感的物体。"},{"id":1,"title":"素描/石膏几何体","categoryid":121,"createtime":"2021-11-12 19:22:18","sort":1,"name":"圆球体结构","cover":"http://res.yimios.com:9050/videos/cover/5圆球体结构.jpg","description":"本系列课程，是学习素描必须经过的第一个阶段。你会通过学习几何体的结构素描，了解绘画起形的基本方法，掌握物体的透视规律；通过学习几何体的光影素描，了解如何通过黑白灰三个大的明暗层次来塑造物体的体积关系。本系列课程，建议新手多看多临，反复揣摩，切勿粗略马虎。"}]

class ChoiceBean {
  int _errno;
  String _errmsg;
  List<Data> _data;

  int get errno => _errno;
  String get errmsg => _errmsg;
  List<Data> get data => _data;

  ChoiceBean({
      int errno, 
      String errmsg, 
      List<Data> data}){
    _errno = errno;
    _errmsg = errmsg;
    _data = data;
}

  ChoiceBean.fromJson(dynamic json) {
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

/// id : 6
/// title : "色彩/色彩头像"
/// categoryid : 361
/// createtime : "2021-11-12 19:22:37"
/// sort : 6
/// name : "完整稿男老年"
/// cover : "http://res.yimios.com:9050/videos/cover/15完整稿男老年.jpg"
/// description : "本系列课程，是素描和色彩学习的高级阶段。人物色彩肖像对颜色表现、形体塑造都有非常高的要求。本套课程从五官的三个角度，详细的演示了五官作画方法和技巧；用12个不同性别与年龄的人物从色稿到完整画面的示范演示，你会学习到色彩肖像的构图、色调、造型及人物气质的表现方法。"

class Data {
  int _id;
  String _title;
  int _categoryid;
  String _createtime;
  int _sort;
  String _name;
  String _cover;
  String _description;

  int get id => _id;
  String get title => _title;
  int get categoryid => _categoryid;
  String get createtime => _createtime;
  int get sort => _sort;
  String get name => _name;
  String get cover => _cover;
  String get description => _description;

  Data({
      int id, 
      String title, 
      int categoryid, 
      String createtime, 
      int sort, 
      String name, 
      String cover, 
      String description}){
    _id = id;
    _title = title;
    _categoryid = categoryid;
    _createtime = createtime;
    _sort = sort;
    _name = name;
    _cover = cover;
    _description = description;
}

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _categoryid = json['categoryid'];
    _createtime = json['createtime'];
    _sort = json['sort'];
    _name = json['name'];
    _cover = json['cover'];
    _description = json['description'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['categoryid'] = _categoryid;
    map['createtime'] = _createtime;
    map['sort'] = _sort;
    map['name'] = _name;
    map['cover'] = _cover;
    map['description'] = _description;
    return map;
  }

}