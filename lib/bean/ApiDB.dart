class ApiDB {
    String api;
    int id;
    String result;
    String version;

    ApiDB({this.api, this.id, this.result, this.version="1.0"});

    factory ApiDB.fromJson(Map<String, dynamic> json) {
        return ApiDB(
            api: json['api'], 
            id: json['id'], 
            result: json['result'], 
            version: json['version'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['api'] = this.api;
        data['id'] = this.id;
        data['result'] = this.result;
        data['version'] = this.version;
        return data;
    }
}