import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/bean/issue_gallery_bean.dart';
import 'package:yhschool/bean/issue_mark_bean.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/DataUtils.dart';
import 'package:yhschool/utils/HttpUtils.dart';
import 'package:yhschool/utils/SizeUtil.dart';

/**
 * 发布作品添加标记的弹框面板
 */
class PopWindowMark extends StatefulWidget{

  Gallery gallery;

  PopWindowMark({Key key,@required this.gallery}):super(key: key);


  @override
  State<StatefulWidget> createState() {
    return PopWindowMarkState()
    ..gallery = gallery;
  }
}

class PopWindowMarkState extends BaseState{

  List<String> markList = ["课堂练习","课后作业","考试考题","参考资料","优秀作品","其他"];
  int selectMark = 0;
  Gallery gallery;

  String markname="";
  String comments="";

  TextEditingController _txtMarkController;
  TextEditingController _txtCommentController;


  @override
  void initState() {
    super.initState();
    _txtMarkController = TextEditingController();
    _txtCommentController = TextEditingController();

    //标签有效
    if(gallery.mark != null){
      // mark 1官方的标签
      if(gallery.mark == 1){
        for(var i=0; i<markList.length; i++){
          if(gallery.markname == markList[i]){
            selectMark = i;
            break;
          }
        }
      }else{
        selectMark = -1;
        markname = gallery.markname;
        _txtMarkController.text = markname;
      }
    }else{
      selectMark = -1;
    }
    //如果有评论就加入评论内容
    if(gallery.comments != null){
      comments = gallery.comments;
      _txtCommentController.text = comments;
    }
  }

  /**
   * 清除自定义的标记
   */
  void clearCoustMark(){
    _txtMarkController.text = "";
  }

  /**
   * 添加标签
   */
  void addMark(){

    if(selectMark == -1 && (markname == null || markname.length == 0)){
      showToast("请添加相应的标签");
      return;
    }

    var option = {
      "mark":selectMark == -1 ? 2 : 1,
      "markname":markname,
      "galleryid":gallery.id,
      "markid":gallery.markid != null ? gallery.markid : 0,
      "tid":gallery.tid
    };
    if(comments != null && comments.length > 0){
      option["comments"] = comments;
    }
    httpUtil.post(DataUtils.api_addissuegallerymark,data: option).then((value){
      IssueMarkBean _issueMark = IssueMarkBean.fromJson(json.decode(value));
      if(_issueMark.errno == 0){
        Navigator.pop(context,{
          "galleryid":gallery.id,
          "markid":_issueMark.data.markid,
          "markname":markname,
          "comments":comments
        });
      }else{
        showToast(_issueMark.errmsg);
      }
    }).catchError((onError){
      showToast(onError.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
          child: Center(
            child: Container(
              width: ScreenUtil().setWidth(SizeUtil.getWidth(660)),
              height: ScreenUtil().setHeight(SizeUtil.getHeight(960)),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20))
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment(1,1),
                            margin: EdgeInsets.only(
                              top: ScreenUtil().setHeight(SizeUtil.getHeight(30)),
                              right: ScreenUtil().setWidth(SizeUtil.getWidth(20))
                            ),
                            child: Image.asset("image/ic_fork.png"),
                          ),
                        ),
                        SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(40)),),
                        GridView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: markList.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: Constant.GARRERY_GRID_CROSSAXISSPACING,
                                mainAxisSpacing: ScreenUtil().setWidth(Constant.PADDING_GALLERY_CROSS),
                                crossAxisCount: 2,
                                childAspectRatio: 6
                            ),
                            itemBuilder: (context,index){
                              return GestureDetector(
                                onTap: (){
                                  setState(() {
                                    selectMark = index;
                                    markname = markList[selectMark];
                                    clearCoustMark();
                                  });
                                },
                                child: Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Checkbox(value: selectMark == index ? true : false, onChanged: (value){
                                        setState(() {
                                          selectMark = index;
                                          markname = markList[selectMark];
                                          clearCoustMark();
                                        });
                                      }),
                                      Text(markList[index],style: TextStyle(color: selectMark == index ? Colors.red : Colors.black87,fontSize: ScreenUtil().setSp(32)),)
                                    ],
                                  ),
                                ),
                              );
                            }),
                        SizedBox(height: ScreenUtil().setHeight(SizeUtil.getHeight(40)),),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20))
                          ),
                          child: TextField(
                            maxLength: 8,
                            maxLines: 1,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintText: "自定义标记（8个字以内）",
                                hintStyle: TextStyle(color: Colors.grey),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(color: Colors.grey)
                                )
                            ),
                            controller: _txtMarkController,
                            onChanged: (word){
                              markname = word;
                              if(word != null && word.length > 0){
                                if(selectMark >= 0){
                                  setState(() {
                                    selectMark = -1;
                                  });
                                }
                              }
                            },
                          ),
                        ),
                        Container(
                          alignment: Alignment(-1,0),
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20)),
                              vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20))
                          ),
                          child: Text("添加留言(选填)",style: TextStyle(fontSize: ScreenUtil().setSp(32)),),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(20))
                          ),
                          child: TextField(
                            maxLines: 3,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                isCollapsed: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: ScreenUtil().setHeight(SizeUtil.getHeight(20)),
                                    horizontal: ScreenUtil().setWidth(SizeUtil.getWidth(10))
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide(color:Colors.grey[100])
                                )
                            ),
                            controller: _txtCommentController,
                            onChanged: (word){
                              this.comments = word;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: (){
                      addMark();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: ScreenUtil().setHeight(SizeUtil.getHeight(30))
                      ),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10)
                          )
                      ),
                      alignment: Alignment(0,0),
                      child: Text("确 定",style: TextStyle(color: Colors.white,fontSize: ScreenUtil().setSp(SizeUtil.getFontSize(36))),),
                    ),
                  )
                ],
              ),
            ),
          )
      ),
    );
  }
}