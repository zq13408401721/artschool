import 'package:event_bus/event_bus.dart';

class EventBusUtils{
  //工厂模式 单列入口
  factory EventBusUtils() => _getInstance();

  static EventBusUtils get instance => _getInstance();

  static EventBusUtils _instance;

  EventBus _eventBus;

  //私有构造函数
  EventBusUtils._internal(){
    _eventBus = new EventBus();
  }

  static EventBusUtils _getInstance(){
    if(_instance == null){
      _instance = EventBusUtils._internal();
    }
    return _instance;
  }

  EventBus getEventBus(){
    return _eventBus;
  }

}