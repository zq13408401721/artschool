class Data {
    String date;
    int date_id;
    int id;
    String name;
    String tid;
    String url;

    Data({this.date, this.date_id, this.id, this.name, this.tid, this.url});

    factory Data.fromJson(Map<String, dynamic> json) {
        return Data(
            date: json['date'], 
            date_id: json['date_id'], 
            id: json['id'], 
            name: json['name'], 
            tid: json['tid'], 
            url: json['url'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['date'] = this.date;
        data['date_id'] = this.date_id;
        data['id'] = this.id;
        data['name'] = this.name;
        data['tid'] = this.tid;
        data['url'] = this.url;
        return data;
    }
}