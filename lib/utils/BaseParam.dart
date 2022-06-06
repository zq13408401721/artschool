/**
 * 参数基类
 */
abstract class BaseParam{

  // 当前数据的基本类型
  dynamic data;

  String param;

  // 读取参数json格式内容
  @override
  String toString(){
    return param != null ? param : "";
  }

}