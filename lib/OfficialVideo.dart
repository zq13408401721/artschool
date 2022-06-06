import 'package:flutter/material.dart';

import 'utils/Constant.dart';

/**
 * 官方视频
 */
class OfficialVideo extends Container{

  List<Widget> tabs = []; //官方视频tab
  List<Widget> gridVideos = []; //视频网格数据


  OfficialVideo({Key key}):super(key: key);


  /**
   * 获取视频的节点数据
   */
  getVideoCategory(){

  }

  /**
   * 创建网格数据
   */
  createGrid(){

  }


  @override
  Widget build(BuildContext context) {
      return Expanded(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: tabs,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(Constant.PADDING_LEFT, 0, Constant.PADDING_RIGHT, 0),
              child: Divider(),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(Constant.PADDING_LEFT, 0, Constant.PADDING_RIGHT, 0),
              child: Column(
                children:gridVideos,
              ),
            )
          ],
        ),
      );
  }

}