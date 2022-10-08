/**
 * 网盘搜索类别 搜索网盘 搜索用户
 */
class PanSearchType {
  int _typeid;
  String _typename;

  int get typeid => _typeid;
  String get typename => _typename;

  PanSearchType({
    int typeid,
    String typename
  }){
    _typeid = typeid;
    _typename = typename;
  }

}