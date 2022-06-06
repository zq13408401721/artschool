import 'dart:convert';

import 'package:yhschool/bean/ApiDB.dart';
import 'package:yhschool/bean/CollectDB.dart';
import 'package:yhschool/bean/CollectDateDB.dart';
import 'package:yhschool/bean/CollectVideoDB.dart';
import 'package:yhschool/bean/GalleryTabDB.dart';
import 'package:yhschool/bean/UrlsDB.dart';
import 'package:sqflite/sqflite.dart';

import 'DB.dart';

/**
 * 本地数据库操作类
 * 目前对收藏数据操作
 */
class DBUtils{

  //数据库操作类
  static Database _db;
  DBUtils(){
  }

  static Future<void> init() async{
    _db = await DB().db;
  }

  static DBUtils _dbUtils;

  static Future<DBUtils> get dbUtils async {
    if(_dbUtils == null) _dbUtils = DBUtils();
    await init();
    return _dbUtils;
  }

  /**
   * 插入收藏数据
   */
  Future<bool> insertCollectDate(CollectDateDB _data) async{
    //插入数据 如果已经存在直接放弃
    var result = await _db.insert('collectdate', _data.toJson(),conflictAlgorithm: ConflictAlgorithm.ignore);
    return result > 0;
  }

  /**
   * 查询是否存在对应的收藏数据
   */
  Future<int> queryCollectDate(String uid,String date)async{
    List<Map> maps = await _db.query('collectdate',where: 'uid=? and date=?',whereArgs: [uid,date]);
    if(maps.length == 0) return 0;
    if(maps[0].values.length == 0) return 0;
    return maps[0].values.toList()[2];
  }

  /**
   * 插入收藏数据
   */
  Future<bool> insertCollect(CollectDB _data) async{
    //插入数据 如果已经存在直接放弃
    var result = await _db.insert('collect', _data.toJson(),conflictAlgorithm: ConflictAlgorithm.ignore);
    return result > 0;
  }

  /**
   * 查询是否存在对应的收藏数据
   */
  Future<bool> checkCollect(String uid,int from,int fromid)async{
    List<Map> maps = await _db.query('collect',where: 'uid=? and `from`=? and fromid=?',whereArgs: [uid,from,fromid]);
    return maps.length > 0;
  }

  /**
   * 删除收藏数据
   */
  Future<bool> delCollect(String uid,int from,int fromid) async{
    return await _db.delete('collect',where:'uid=? and `from`=? and fromid=?',whereArgs: [uid,from,fromid]) > 0;
  }

  /**
   * 插入图库分类数据
   */
  Future<bool> insertGalleryTab(GalleryTabDB _data) async{
    //插入数据 如果已经存在直接放弃
    var result = await _db.insert('gallerytab', _data.toJson(),conflictAlgorithm: ConflictAlgorithm.ignore);
    return result > 0;
  }

  /**
   * 查询所有保存的分类数据
   */
  Future<List<GalleryTabDB>> queryGalleryTabs(String uid)async{
    List<Map> maps = await _db.query('gallerytab',where: 'uid=?',whereArgs: [uid]);
    List<GalleryTabDB> list = [];
    maps.forEach((element) {
      GalleryTabDB tab = GalleryTabDB(id: element['id'],tabid: element['tabid'],name: element['name'],uid: element['uid'],sort: element['sort']);
      list.add(tab);
    });
    return list;
  }

  /**
   * 删除分类相关数据
   */
  Future<bool> delGallery(String uid,int tabid) async{
    return await _db.delete('gallerytab',where:'uid=? and tabid=?',whereArgs: [uid,tabid]) > 0;
  }

  /**
   * 插入API接口数据
   */
  Future<bool> insertApi(ApiDB _data) async{
    //插入数据 如果已经存在直接放弃
    var result = await _db.insert('unchangeapi', _data.toJson(),conflictAlgorithm: ConflictAlgorithm.ignore);
    return result > 0;
  }

  /**
   * 查询api接口对应的数据
   */
  Future<String> queryApiData(String api)async{
    List<Map> maps = await _db.query('unchangeapi',where: 'api=?',whereArgs: [api]);
    return maps.length == 0 ? "" : maps[0]["result"];
  }

  /**
   * 删除某些接口对应的数据
   */
  Future<bool> delApiData(String api) async{
    return await _db.delete('unchangeapi',where:'api',whereArgs: [api]) > 0;
  }

  /**
   * 插入视频收藏
   */
  Future<bool> insertCollectVideo(CollectVideoDB _data) async{
    //插入数据 如果已经存在直接放弃
    var result = await _db.insert('collectvideo', _data.toJson(),conflictAlgorithm: ConflictAlgorithm.ignore);
    return result > 0;
  }

  /**
   * 收藏接口对应的数据
   */
  Future<List<CollectVideoDB>> queryCollectVideo(String uid,int categoryid)async{
    List<Map> maps = await _db.query('collectvideo',where: 'uid=? and categoryid=?',whereArgs: [uid,categoryid]);
    List<CollectVideoDB> list = [];
    maps.forEach((element) {
      CollectVideoDB tab = CollectVideoDB(id: element['id'],categoryid: element['categoryid'],uid: element['uid']);
      list.add(tab);
    });
    return list;
  }

  /**
   * 查看视频是否收藏
   */
  Future<bool> checkVideoCollect(String uid,int categoryid)async{
    List<Map> maps = await _db.query('collectvideo',where: 'uid=? and categoryid=?',whereArgs: [uid,categoryid]);
    return maps.length > 0;
  }

  /**
   * 删除视频收藏对应的数据
   */
  Future<bool> delCollectVideo(String uid,int categoryid) async{
    return await _db.delete('collectvideo',where:'uid=? and categoryid=?',whereArgs: [uid,categoryid]) > 0;
  }



  /**
   * 插入API接口数据
   */
  Future<bool> insertUrls(UrlsDB _data) async{
    //插入数据 如果已经存在直接放弃
    var result = await _db.insert('appurls', _data.toJson(),conflictAlgorithm: ConflictAlgorithm.ignore);
    return result > 0;
  }

  /**
   * 查询api接口对应的数据
   */
  Future<UrlsDB> queryUrls()async{
    List<Map> maps = await _db.query('appurls');
    UrlsDB urlsDB;
    if(maps != null && maps.length > 0){
      urlsDB = UrlsDB(id:maps[0]["id"],apiurl: maps[0]["api"],uploadurl: maps[0]["upload"]);
    }
    return urlsDB;
  }

  /**
   * 删除某些接口对应的数据
   */
  Future<bool> delUrls(int id) async{
    return await _db.delete('appurls',where:'id',whereArgs: [id]) > 0;
  }


  /**
   * 插入API接口内容数据
   */
  Future<bool> insertAppContent(String key, String content) async{
    //插入数据 如果已经存在直接放弃
    Map<String,String> _map = Map();
    _map["key"] = key;
    _map["content"] = content;
    var result = await _db.insert('apicontent', _map,conflictAlgorithm: ConflictAlgorithm.ignore);
    return result > 0;
  }

  /**
   * 查询api接口对应的数据
   */
  Future<String> queryAppContent(String key)async{
    List<Map> maps = await _db.query('apicontent',where: 'key=?',whereArgs: [key]);
    String content="";
    if(maps != null && maps.length > 0){
      content  = maps[0]["content"];
    }
    return content;
  }

  /**
   * 删除某些接口对应的数据
   */
  Future<bool> delApiContent(String key) async{
    return await _db.delete('apicontent',where:'key',whereArgs: [key]) > 0;
  }

  /**
   * 插入协议是否阅读状态
   */
  Future<bool> insertPolicy(String key, String policy) async{
    //插入数据 如果已经存在直接放弃
    Map<String,String> _map = Map();
    _map["key"] = key;
    _map["policy"] = policy;
    var result = await _db.insert('apppolicy', _map,conflictAlgorithm: ConflictAlgorithm.ignore);
    return result > 0;
  }

  /**
   * 查询隐私协议阅读状态
   */
  Future<String> queryPolicy(String key) async{
    List<Map> maps = await _db.query('apppolicy',where: 'key=?',whereArgs: [key]);
    String content="";
    if(maps != null && maps.length > 0){
      content  = maps[0]["policy"];
    }
    return content;
  }

  Future<bool> clearTable() async{
    await _db.execute("delete from gallerytab",[]);
    await _db.execute("delete from unchangeapi",[]);
    await _db.execute("delete from appurls",[]);
    await _db.execute("delete from apicontent",[]);
    return true;
  }

}