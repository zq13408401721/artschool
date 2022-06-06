import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/message_add_bean.dart' as M;
import 'package:yhschool/bean/message_list_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';
import 'package:yhschool/widgets/RoundedButton.dart';

class MessagePage extends StatefulWidget{

  int relationid;
  MessagePage({Key key,@required this.relationid}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MessagePageState()
    ..relationid = relationid;
  }
}

class MessagePageState extends BaseState<MessagePage>{

  int page=1,size=50;
  int relationid;
  String touid;

  List<Data> list = [];
  String content;
  ScrollController _scrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();

    _queryMessage();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _scrollController.dispose();
    super.dispose();
  }
  
  void _queryMessage(){
    var option = {
      "page":page,
      "size":size,
      "relationid":relationid
    };
    httpUtil.post(DataUtils.api_querymessage,data: option).then((value){
      MessageListBean bean = MessageListBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        setState(() {
          list.addAll(bean.data);
        });
      }
    });
  }

  /**
   * 发布留言信息
   */
  void _sendMessage(){
    if(content == null || content.length == 0){
      showToast("请输入内容");
      return;
    }
    var option = {
      "touid":touid,
      "relationid":relationid,
      "content":content
    };
    httpUtil.post(DataUtils.api_addmessage,data:option).then((value){
      M.MessageAddBean bean = M.MessageAddBean.fromJson(json.decode(value));
      if(bean.errno == 0){
        setState(() {
          list.insert(0,Data(
            id: bean.data[0].id,
            fromuid: bean.data[0].fromuid,
            touid: bean.data[0].touid,
            content: bean.data[0].content,
            time:bean.data[0].time,
            relationid: bean.data[0].relationid,
            fromusername: bean.data[0].fromusername,
            fromnickname: bean.data[0].fromnickname,
            fromavater: bean.data[0].fromavater,
            tousername: bean.data[0].tousername,
            tonickname: bean.data[0].tonickname,
            toavater: bean.data[0].toavater
          ));
        });
      }else{
        showToast(bean.errmsg);
      }
    });
  }

  /**
   * 左边显示其他人聊天信息条目
   */
  Widget _leftMsgItem(Data _data,bool isend){
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20))
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: (_data.fromavater == null || _data.fromavater.length == 0) ?
                Image.asset("image/ic_head.png",width: ScreenUtil().setWidth(80),height: ScreenUtil().setWidth(80),) :
                CachedNetworkImage(imageUrl: _data.fromavater,width: ScreenUtil().setWidth(80),height: ScreenUtil().setWidth(80),fit: BoxFit.cover,),
              ),
              SizedBox(width:5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //时间
                    Text(_data.time,style: Constant.smallTitleTextStyle,),
                    SizedBox(height: 5,),
                    //内容
                    Text(_data.content,style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.black54),)
                  ],
                ),
              )
            ],
          ),
          SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(20)),),
          !isend ? Divider(height: 1,) : Container()
        ],
      ),
    );
  }

  /**
   * 信息右边条目
   */
  Widget _rightMsgItem(Data _data,bool isend){
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20))
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    //时间
                    Text(_data.time,style: Constant.smallTitleTextStyle,),
                    SizedBox(height: 5,),
                    //内容
                    Text(_data.content,style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),color: Colors.black54),)
                  ],
                ),
              ),
              SizedBox(width: 5,),
              ClipOval(
                child: (_data.fromavater == null || _data.fromavater.length == 0) ?
                Image.asset("image/ic_head.png",width: ScreenUtil().setWidth(80),height: ScreenUtil().setWidth(80),) :
                CachedNetworkImage(imageUrl: _data.fromavater,width: ScreenUtil().setWidth(80),height: ScreenUtil().setWidth(80),fit: BoxFit.cover,),
              ),
            ],
          ),
          SizedBox(height: ScreenUtil().setHeight(20),),
          !isend ? Divider(height: 1,) : Container()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10))
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
          vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20))
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: ScreenUtil().setHeight(20)
              ),
              child: Text("家长 / 学生留言",style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(30)),fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(20)),),
            TextField(
              decoration: InputDecoration(
                hintText: "写留言",
                filled: true,
                fillColor: Colors.grey[100],
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                  vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20))
                ),
                border: InputBorder.none,
                counterText: ""
              ),
              style: TextStyle(fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(25)),color: Colors.black54,),
              maxLines: 5,
              onChanged: (value){
                content = value;
              },
            ),
            InkWell(
              onTap: (){
                _sendMessage();
              },
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20))
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10))
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(40)),
                    vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20))
                  ),
                  child: Text("提 交",style: TextStyle(color:Colors.white),),
                ),
              ),
            ),
            Container(
              constraints: BoxConstraints(
                maxHeight: ScreenUtil().setHeight(500),
                minHeight: ScreenUtil().setHeight(0)
              ),
              child: ListView.builder(
                itemCount: list.length,
                //reverse: true,
                controller: _scrollController,
                itemBuilder: (context,index){
                  return (list[index].fromuid == m_uid ? this._rightMsgItem(list[index],list.length-1 == index) : this._leftMsgItem(list[index],list.length-1 == index));
                }
              ),
            )
          ],
        ),
      ),
    );
  }
}