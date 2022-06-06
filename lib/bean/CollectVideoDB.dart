import 'package:yhschool/collects/CollectVideo.dart';

class CollectVideoDB{
  int id;
  int categoryid;
  String uid;

  CollectVideoDB({
    this.id,
    this.categoryid,
    this.uid
  });

  factory CollectVideoDB.fromjson(Map<String,dynamic> parseJson){
    return CollectVideoDB(
      id:parseJson['id'],
      categoryid:parseJson['categoryid'],
      uid: parseJson['uid']
    );
  }

  Map<String,dynamic> toJson(){
    return {
      'id':id,
      'categoryid':categoryid,
      'uid':uid
    };
  }

}