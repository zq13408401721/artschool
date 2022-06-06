import 'package:flutter/cupertino.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class LocalFile{

  String filename;
  String _path;
  String get path => _path;
  set path(value){
    this._path = value;
  }


  int sort;
  String date;
  Asset data;

  String _uploadState="";

  String get uploadState => _uploadState;
  set uploadState(String value) => _uploadState = value;



  LocalFile({@required this.filename,@required this.data,@required this.sort,@required this.date});

}