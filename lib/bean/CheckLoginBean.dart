class CheckLoginBean {
    Data data;
    String errmsg;
    int errno;

    CheckLoginBean({this.data, this.errmsg, this.errno});

    factory CheckLoginBean.fromJson(Map<String, dynamic> json) {
        return CheckLoginBean(
            data: json['`data`'],
            errmsg: json['errmsg'], 
            errno: json['errno'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['errmsg'] = this.errmsg;
        data['errno'] = this.errno;
        if (this.data != null) {
            data['`data`'] = this.data;
        }
        return data;
    }
}
class Data{

}