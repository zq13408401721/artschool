import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class HorizontalListTab extends StatefulWidget{

  List<dynamic> datas; //对应的数据
  Function(dynamic _data) click;

  HorizontalListTab({Key key,@required this.datas,@required this.click}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HorizontalListTabState();
  }
}

class HorizontalListTabState extends BaseState<HorizontalListTab>{

  TextStyle normalStyle;
  TextStyle selectStyle;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    normalStyle = TextStyle(color: Colors.black87,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)));
    selectStyle = TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)));
    if(widget.datas.length > 0) {
      resetSelect(widget.datas[0].id);
    }
  }

  void resetSelect(int id){
    widget.datas.forEach((element) {
      if(element.id == id){
        element.select = true;
      }else{
        element.select = false;
      }
    });
    setState(() {
    });
  }

  Widget item(dynamic _data){
    return InkWell(
      onTap: (){
        resetSelect(_data.id);
        widget.click(_data);
      },
      child: Container(
        alignment: Alignment(0,0),
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(30)),
          vertical: ScreenUtil().setHeight(SizeUtil.getHeight(10))
        ),
        margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(10))
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(16))),
            topRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(8))),
            bottomLeft: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(8))),
            bottomRight: Radius.circular(ScreenUtil().setWidth(SizeUtil.getWidth(16)))
          ),
          border: Border.all(
            color: _data.select ? Colors.red : Colors.grey[200],
            width: 1,
          ),
          color: _data.select ? Colors.red : Colors.white
        ),
        child: Text(_data.name,style: _data.select ? selectStyle : normalStyle,),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.white,
      height: ScreenUtil().setHeight(SizeUtil.getHeight(115)),
      alignment: Alignment(-1,0),
      padding: EdgeInsets.only(
        left:SizeUtil.getAppWidth(20),
        right: SizeUtil.getAppWidth(20),
        bottom: ScreenUtil().setHeight(SizeUtil.getHeight(30))
      ),
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: widget.datas.length,
        itemBuilder: (context,index){
          return item(widget.datas[index]);
        },
      ),
    );
  }
}