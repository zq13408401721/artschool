import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB{

  Database _database;

  initDB() async{
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path,"art.db");
    return await openDatabase(path,version: 3,onOpen: (_db){},onCreate: (Database db,int version) async{
      //用户个人收藏数据
      await db.execute('''
        CREATE TABLE collect (id int PRIMARY KEY,uid varchar(128),fromid INTEGER,`from` INTEGER);
      ''');
      //收藏日期表
      await db.execute('''
        CREATE TABLE collectdate (id int PRIMARY KEY,uid varchar(128),dateid INTEGER,date varchar(128));
      ''');
      //用户本地图库分类
      await db.execute('''
        CREATE TABLE gallerytab (id int PRIMARY KEY,uid varchar(128),tabid INTEGER,name varchar(128),sort INTEGER);
      ''');
      //常用的接口对应数据表
      await db.execute('''
        CREATE TABLE unchangeapi (id int PRIMARY KEY,api varchar(255),result TEXT,version varchar(255));
      ''');
      //视频数据收藏对应数据表
      await db.execute('''
        CREATE TABLE collectvideo (id int PRIMARY KEY,uid varchar(255),categoryid INTEGER);
      ''');
      //app服务器地址
      await db.execute('''
        CREATE TABLE appurls (id int PRIMARY KEY,api varchar(255),upload varchar(255));
      ''');
      //接口数据本地保存内容 key=md(接口+参数)
      await db.execute('''
        CREATE TABLE apicontent (id int PRIMARY KEY,key varchar(32),content TEXT);
      ''');
      //隐私协议状态
      /*await db.execute('''
        CREATE TABLE apppolicy (id int PRIMARY KEY,key varchar(32),policy varchar(10));
      ''');*/
    },onUpgrade: (Database db,int oldVersion,int newVersion) async{
      print("sqlite update oldVersion:$oldVersion,newVersion:$newVersion");
      if(newVersion > oldVersion){
        if(newVersion == 3){
          //接口数据本地保存内容 key=md(接口+参数)
          await db.execute('''
            CREATE TABLE apicontent (id int PRIMARY KEY,key varchar(32),content TEXT);
          ''');
        }
      }
    });
  }

  Future<Database> get db async{
    if(_database != null) return _database;
    _database = await initDB();
    return _database;
  }



}