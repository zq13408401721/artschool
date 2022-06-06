class UrlsDB{
  int id;
  String apiurl;
  String uploadurl;

  UrlsDB({this.id,this.apiurl,this.uploadurl});

  factory UrlsDB.fromJson(Map<String,dynamic> json){
    return UrlsDB(
      id: json['id'],
      apiurl: json['apiurl'],
      uploadurl: json['uploadurl']
    );
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data['id'] = this.id;
    data['apiurl'] = this.apiurl;
    data['uploadurl'] = this.uploadurl;
    return data;
  }

}