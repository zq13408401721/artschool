import 'dart:core';

class PanMarkBean {
    List<Data> data;
    String errmsg;
    int errno;

    PanMarkBean({this.data, this.errmsg, this.errno});

    factory PanMarkBean.fromJson(Map<String, dynamic> json) {
        return PanMarkBean(
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
    int classifyid;
    int id;
    String name;
    int sort;
    int type;

    bool _select = false;
    set select(bool value) {
        this._select = value;
    }
    bool get select => this._select;

    Data({this.classifyid, this.id, this.name, this.sort, this.type});

    factory Data.fromJson(Map<String, dynamic> json) {
        return Data(
            classifyid: json['classifyid'],
            id: json['id'],
            name: json['name'],
            sort: json['sort'],
            type: json['type'],
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['classifyid'] = this.classifyid;
        data['id'] = this.id;
        data['name'] = this.name;
        data['sort'] = this.sort;
        data['type'] = this.type;
        return data;
    }
}