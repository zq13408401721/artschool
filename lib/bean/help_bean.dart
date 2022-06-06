/// video_title : "视频栏目"
/// video : [{"name":"艺画视频课程是什么?","url":"https://support.qq.com/products/326279/faqs/94704"},{"name":"艺画视频课程有哪些形式？","url":"https://support.qq.com/products/326279/faqs/94705"},{"name":"如何在艺画中学习视频课程？","url":"https://support.qq.com/products/326279/faqs/94706"},{"name":"艺画视频课程有范画吗，在哪儿看？","url":"https://support.qq.com/products/326279/faqs/94730"},{"name":"如何收藏视频课程？","url":"https://support.qq.com/products/326279/faqs/94851"},{"name":"如何将视频课程推送到课堂？","url":"https://support.qq.com/products/326279/faqs/109462"}]
/// course_title : "课堂栏目"
/// course : [{"name":"什么是图文课堂、双师课堂？","url":"https://support.qq.com/products/326279/faqs/94711"},{"name":"如何在图文课堂中添加图片资料？","url":"https://support.qq.com/products/326279/faqs/94715"},{"name":"如何在课堂中添加视频课程？","url":"https://support.qq.com/products/326279/faqs/94717"},{"name":"如何在双师课堂中排课？","url":"https://support.qq.com/products/326279/faqs/94728"}]

class HelpBean {
  String _videoTitle;
  List<Video> _video;
  String _courseTitle;
  List<Course> _course;

  String get videoTitle => _videoTitle;
  List<Video> get video => _video;
  String get courseTitle => _courseTitle;
  List<Course> get course => _course;

  HelpBean({
      String videoTitle, 
      List<Video> video, 
      String courseTitle, 
      List<Course> course}){
    _videoTitle = videoTitle;
    _video = video;
    _courseTitle = courseTitle;
    _course = course;
}

  HelpBean.fromJson(dynamic json) {
    _videoTitle = json['video_title'];
    if (json['video'] != null) {
      _video = [];
      json['video'].forEach((v) {
        _video.add(Video.fromJson(v));
      });
    }
    _courseTitle = json['course_title'];
    if (json['course'] != null) {
      _course = [];
      json['course'].forEach((v) {
        _course.add(Course.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['video_title'] = _videoTitle;
    if (_video != null) {
      map['video'] = _video.map((v) => v.toJson()).toList();
    }
    map['course_title'] = _courseTitle;
    if (_course != null) {
      map['course'] = _course.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// name : "什么是图文课堂、双师课堂？"
/// url : "https://support.qq.com/products/326279/faqs/94711"

class Course {
  String _name;
  String _url;

  String get name => _name;
  String get url => _url;

  Course({
      String name, 
      String url}){
    _name = name;
    _url = url;
}

  Course.fromJson(dynamic json) {
    _name = json['name'];
    _url = json['url'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['name'] = _name;
    map['url'] = _url;
    return map;
  }

}

/// name : "艺画视频课程是什么?"
/// url : "https://support.qq.com/products/326279/faqs/94704"

class Video {
  String _name;
  String _url;

  String get name => _name;
  String get url => _url;

  Video({
      String name, 
      String url}){
    _name = name;
    _url = url;
}

  Video.fromJson(dynamic json) {
    _name = json['name'];
    _url = json['url'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['name'] = _name;
    map['url'] = _url;
    return map;
  }

}