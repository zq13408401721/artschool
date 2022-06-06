
import 'dart:core';

class GalleryTabDB{
  String id;
  String uid;
  int tabid;
  String name;
  int sort;

  GalleryTabDB({
    this.id,
    this.uid,
    this.tabid,
    this.name,
    this.sort
  });

  factory GalleryTabDB.fromjson(Map<String,dynamic> parseJson){
    return GalleryTabDB(
        id: parseJson['id'],
        uid: parseJson['uid'],
        tabid:parseJson['tabid'],
        name:parseJson['name'],
        sort: parseJson['sort']
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'id':id,
      'uid':uid,
      'tabid':tabid,
      'name':name,
      'sort':sort
    };
  }


}