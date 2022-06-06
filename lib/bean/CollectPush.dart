import 'dart:core';

class CollectPush{
  int _dataid;
  List<CidData> _classes;
  List<ImgsData> _imgs;

  int get dataid => _dataid;
  List<CidData> get classes => _classes;
  List<ImgsData> get imgs => _imgs;

  CollectPush({
    int dataid,
    List<CidData> classes,
    List<ImgsData> imgs
  }){
    _dataid = dataid;
    _classes = classes;
    _imgs = imgs;
  }

  Map<String,dynamic> toJson(){
    var map = <String,dynamic>{};
    map["dataid"] = this.dataid;
    map["classes"] = this.classes.map((e) => e.toJson()).toList();
    map["imgs"] = this.imgs.map((e) => e.toJson()).toList();
    return map;
  }
}

class CidData{

  int _cid;
  int get cid => _cid;

  CidData({
    int cid
  }){
    _cid = cid;
  }

  Map<String,dynamic> toJson(){
    var map = <String,dynamic>{};
    map["cid"] = cid;
    return map;
  }

}

class ImgsData{
  String _name;
  String _url;
  int _sort;
  int _width;
  int _height;
  String _filename;

  String get name => _name;
  String get url => _url;
  int get sort => _sort;
  int get width => _width;
  int get height => _height;
  String get filename => _filename;

  ImgsData({
    String name,
    String url,
    int sort,
    int width,
    int height,
    String filename
  }){
    _name = name;
    _url = url;
    _sort = sort;
    _width = width;
    _height = height;
    _filename = filename;
  }

  Map<String,dynamic> toJson(){
    var map = <String,dynamic>{};
    map["name"] = _name;
    map["url"] = _url;
    map["sort"] = _sort;
    map["width"] = _width;
    map["height"] = _height;
    map["filename"] = _filename;
    return map;
  }
}