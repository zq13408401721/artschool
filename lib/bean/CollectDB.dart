
import 'dart:core';

class CollectDB{
  String id;
  String uid;
  int from;
  int fromid;

  CollectDB({
    this.id,
    this.uid,
    this.from,
    this.fromid
  });

  factory CollectDB.fromjson(Map<String,dynamic> parseJson){
    return CollectDB(
      id: parseJson['id'],
      uid: parseJson['uid'],
      from:parseJson['from'],
      fromid:parseJson['fromid']
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'id':id,
      'uid':uid,
      'from':from,
      'fromid':fromid
    };
  }


}