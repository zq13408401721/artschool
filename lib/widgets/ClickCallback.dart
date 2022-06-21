//定义ItemClick的类型为函数
import 'package:yhschool/utils/EnumType.dart';

typedef ItemClick = void Function(Object object);

class ClickCallback{
  ItemClick itemClick;

  ClickCallback({ItemClick this.itemClick});  //设置回调接口

}

// 主页接口回调
typedef CallBack = void Function(CMD_MINE _cmd,bool _bool,dynamic data);

// 专栏导航切换
typedef CallBack_Column = void Function();