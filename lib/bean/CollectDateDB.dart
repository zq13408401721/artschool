
import 'dart:core';

class CollectDateDB{
  String id;
  String uid;
  int dateid;
  String date;

  CollectDateDB({
    this.id,
    this.uid,
    this.dateid,
    this.date
  });

  factory CollectDateDB.fromjson(Map<String,dynamic> parseJson){
    return CollectDateDB(
      id: parseJson['id'],
      uid: parseJson['uid'],
      dateid:parseJson['dateid'],
      date:parseJson['date']
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'id':id,
      'uid':uid,
      'dateid':dateid,
      'date':date
    };
  }


}