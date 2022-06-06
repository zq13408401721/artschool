import 'dart:convert';
import 'dart:io';
import 'dart:async';

class VideosList{

  List<VideoItem> videos;

  VideosList.fromJson(Map<String,dynamic> jsonstr){
    var videos = jsonstr['videos'].map((i) => (VideoItem.fromJson(i))).toList();
    this.videos = new List<VideoItem>.from(videos);
  }

}

class VideoItem{
  String ccid;
  String url;
  VideoItem.fromJson(Map<String,dynamic> jsonstr){
    this.ccid = jsonstr['ccid'];
    this.url = jsonstr['url'];
  }
}