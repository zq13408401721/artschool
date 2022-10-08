class PanClassifyBean {
    List<Data> data;
    String errmsg;
    int errno;

    PanClassifyBean({this.data, this.errmsg, this.errno});

    factory PanClassifyBean.fromJson(Map<String, dynamic> json) {
        return PanClassifyBean(
            data: json['data'] != null ? (json['data'] as List).map((i) => Data.fromJson(i)).toList() : null,
            errmsg: json['errmsg'],
            errno: json['errno'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['errmsg'] = this.errmsg;
        data['errno'] = this.errno;
        if (this.data != null) {
            data['data'] = this.data.map((v) => v.toJson()).toList();
        }
        return data;
    }

}

class Data {
    int id;
    int isuse;
    String name;
    int schoolid;
    int sort;
    bool _select = false;

    bool get select => _select;
    set select(bool _bool){
        _select = _bool;
    }

    Data({this.id, this.isuse, this.name, this.schoolid, this.sort});

    factory Data.fromJson(Map<String, dynamic> json) {
        return Data(
            id: json['id'],
            isuse: json['isuse'],
            name: json['name'],
            schoolid: json['schoolid'],
            sort: json['sort'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['id'] = this.id;
        data['isuse'] = this.isuse;
        data['name'] = this.name;
        data['schoolid'] = this.schoolid;
        data['sort'] = this.sort;
        return data;
    }
}
