import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yhschool/BaseState.dart';
import 'package:yhschool/utils/Constant.dart';
import 'package:yhschool/utils/SizeUtil.dart';

class SchoolVerify extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new SchoolVerifyState();
  }
}

class SchoolVerifyState extends BaseState<SchoolVerify> {

  var schoolname = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: SizeUtil.getAppWidth(40)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text("机构验证",style: Constant.smallTitleTextStyle,),
                    TextField(
                      keyboardType: TextInputType.text,
                      maxLines: 1,
                      maxLength: 11,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      controller: TextEditingController(text: schoolname),
                      decoration: InputDecoration(
                        hintText: "请输入机构名称",
                        hintStyle: TextStyle(fontSize: SizeUtil.getAppFontSize(30),color: Colors.grey),
                        counterText: "",
                        fillColor: Colors.white,
                        isCollapsed: true,
                        filled: true,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white, width: 1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(SizeUtil.getAppWidth(10))
                          )
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(SizeUtil.getAppWidth(10))
                          ),
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 1
                          )
                        )
                      ),
                      onChanged: (value){
                        schoolname = value;
                      },
                    ),
                    InkWell(
                      onTap: (){

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(SizeUtil.getAppWidth(10))
                        ),
                        child: Text("确定",style: TextStyle(fontSize: SizeUtil.getAppFontSize(30),color: Colors.white),),
                      ),
                    )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}