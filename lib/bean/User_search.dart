
class UserSearch {
  UserSearch({
      this.errno, 
      this.errmsg, 
      this.data,});

  UserSearch.fromJson(dynamic json) {
    errno = json['errno'];
    errmsg = json['errmsg'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(Data.fromJson(v));
      });
    }
  }
  int errno;
  String errmsg;
  List<Data> data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['errno'] = errno;
    map['errmsg'] = errmsg;
    if (data != null) {
      map['data'] = data.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Data {
  Data({
    this.username,
    this.nickname,
    this.avater,
    this.role,
    this.follow,
    this.fansnum,});

  Data.fromJson(dynamic json) {
    username = json['username'];
    nickname = json['nickname'];
    avater = json['avater'];
    role = json['role'];
    follow = json['follow'];
    fansnum = json['fansnum'];
  }
  String username;
  dynamic nickname;
  dynamic avater;
  int role;
  int follow;
  int fansnum;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['username'] = username;
    map['nickname'] = nickname;
    map['avater'] = avater;
    map['role'] = role;
    map['follow'] = follow;
    map['fansnum'] = fansnum;
    return map;
  }

}