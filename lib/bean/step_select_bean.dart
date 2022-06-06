/// index : 1
/// data : ["http://res.yimios.com:9095/videos/steps/1.png"]

class StepSelectBean {
  int _index;
  List<String> _data;

  int get index => _index;
  List<String> get data => _data;

  StepSelectBean({
      int index, 
      List<String> data}){
    _index = index;
    _data = data;
}

  StepSelectBean.fromJson(dynamic json) {
    _index = json['index'];
    _data = json['data'] != null ? json['data'].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['index'] = _index;
    map['data'] = _data;
    return map;
  }

}