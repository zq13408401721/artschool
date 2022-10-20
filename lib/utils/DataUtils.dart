
import 'package:flutter/services.dart';
import 'package:yhschool/utils/Constant.dart';

class DataUtils{
  static const String api_urls = "apk/appNetUrl"; //获取appurl地址
  static const String api_app_version = "apk/appNewVersion"; //app版本信息
  static const String api_checklogin = "auth/checkLogin"; //检查登录是否有效
  static const String api_startadvert = "advert/startAdvert"; //开设的广告数据
  static const String api_advertvideo = "advert/queryAdvertVideo"; //视频广告
  static const String api_tab = "home/officialTab"; //主页tab接口
  static const String api_categorybytabid = "home/queryCategoryByTab"; //获取视频分类对应的分组数据
  static const String api_login = "user/login"; //登录接口 username password
  static const String api_updateuserinfo = "user/updateUserInfo"; //更新用户信息 nickname
  static const String api_videolist_category = "home/videoListCategory"; //主页根据章节获取视频列表
  static const String api_gallery = "home/galleryTabs"; //图库的tab数据
  static const String api_gallery_category = "home/galleryClassify"; //图库tab对应的节点数据列表
  static const String api_gallery_list = "home/galleryList"; //图库列表数据
  static const String api_gallery_more = "home/galleryClassifyList"; //图库类别list
  static const String api_video_category_list = "home/getVideoCategoryList"; //视频最后一个节点的列表数据
  static const String api_video_tab_category = "home/getVideoCategorysByTab"; //获取分类下的视频数据
  static const String api_video_list = "home/videoList"; //视频列表
  static const String api_video_category_more = "home/getVideoCategoryMore"; //获取视频更多节点
  static const String api_web_player = "video/webPlayer"; //web视频播放器
  static const String api_uploadfile = "upload/uploadFileNew"; //图片上传
  static const String api_issueupload = "issueupload"; //发布功能图片上传
  static const String api_issuelist = "issue/issueList"; //发布列表
  static const String api_issuegallerymore = "issue/issueGalleryMore"; //发布图片所有老师列表
  static const String api_issuegallery = "issue/newIssueGallery"; //发布图片列表
  static const String api_issuedateid = "issue/issueDateId"; //发布图片的日期id
  static const String api_issuedateidbyclass = "issue/issueDateIdByClass"; //获取发布作品班级对应的日期数据
  static const String api_issuedeletegallery = "issue/issueDeleteGallery"; //删除课堂对应的图片作品

  /********************pan******************************/
  static const String api_panclassify = "pan/panClassify"; //网盘分类
  static const String api_panmark = "pan/panMark"; //网盘分类对应的标记
  static const String api_pantabs = "pan/panTabs"; //获取网盘的tabs
  static const String api_pancreate = "pan/createPan"; //创建网盘
  static const String api_paneditor = "pan/editorPan"; //编辑网盘
  // schoolid uid不传 获取全部网盘数据，schoolid学校网盘数据 uid我的网盘数据
  static const String api_panlist = "pan/panlist";  // 获取网盘数据
  static const String api_querymypan = "pan/queryMyPan"; //查询我的网盘
  static const String api_searchpan = "pan/searchPan"; //网盘搜索
  static const String api_queryuserdetail = "pan/queryUserDetail"; //用户详情
  static const String api_queryuserpan = "pan/queryUserPan"; //查询用户网盘
  static const String api_queryuserpanimage = "pan/queryUserPanImage"; //查询用户网盘文件数据
  static const String api_querypanimagebyuser = "pan/queryPanImageByUser"; //查询用户的网盘图片数据
  static const String api_queryusercourse = "pan/queryUserCourse"; //查询用户的课程
  static const String api_queryuserlikepanimage = "pan/queryUserLikePanImage"; //查询用户喜欢的网盘图片
  static const String api_queryuserfollow = "pan/queryUserFollow"; //查询粉丝和关注用户列表
  static const String api_adduserfollow = "pan/addUserFollow"; //添加关注数据
  static const String api_pantopping = "pan/panTopping"; //网盘排序
  static const String api_panfiletopping = "pan/panFileTopping"; //网盘文件排序
  static const String api_pancopy = "pan/panCopy"; //复制网盘
  static const String api_pancopyfile = "pan/copyPanFile"; //复制网盘文件
  static const String api_addpanfilelike = "pan/addPanFileLike"; //添加网盘文件like
  static const String api_deletepan = "pan/deletePan"; //删除网盘
  static const String api_deletepanfile = "pan/deletePanFile"; //删除网盘文件
  static const String api_deletepanfilelike = "pan/deletePanFileLike"; //删除网盘文件like


  static const String api_panfoldercreate = "pan/createPanFolder"; //创建网盘目录
  static const String api_panfolderlist = "pan/panFolderList"; //盘目录列表
  static const String api_panupload = "pan_upload"; //盘文件上传
  static const String api_panfilelist = "pan/panFileList"; //网盘文件的列表
  static const String api_pandeletefile = "pan/deletePanFile"; //删除网盘文件
  static const String api_pandeletefolder = "pan/deletePanFolder"; //删除文件夹
  static const String api_pandelete = "pan/deletePan"; //删除网盘


  static const String api_getschoolteacher = "shared/getSchoolTeacher"; //获取学校老师
  static const String api_getsharedteacher = "shared/getSharedTeacher"; //获取分享的选择老师
  static const String api_addsharedteacher = "shared/addSharedTeacher"; //添加分享的老师
  static const String api_updatesharedsort = "shared/updateSharedSort"; //修改分享老师的选择顺序
  static const String api_deletesharedteacher = "shared/deleteSharedTeacher";  //删除分享的老师
  static const String api_panlistsharedteacher = "shared/sharedTeacherPanList"; //共享老师的盘列表
  static const String api_schoolclass = "issue/schoolAllClass"; //学校所有班级
  static const String api_classesbyteacher = "classes/queryClassByTeacher"; //老师所在的所有班级 后面老师和学生共用不再新加接口
  static const String api_manydatebyclass = "issue/issueManyClassDateId"; //根据班级获取对应的日期id
  static const String api_issueclassdate = "issue/issueListByClass"; //发布作品班级日期对应的列表数据
  static const String api_addissuegallerymark = "issue/addIssueGalleryMark"; //添加发布作品标签
  static const String api_choicelist = "choice/choiceList"; //官方精选
  static const String api_querynamegroup = "word/queryNamesGroup"; //滚动人名
  //参数以json格式上传{data:{classes:[],imgs:[]}}
  static const String api_collectpush = "issue/issuePush"; //收藏直接推送
  static const String api_doubleclassdate = "classroom/doubleClassDateId"; //获取双师课堂日期数据
  static const String api_classroomdatelist = "classroom/classRoomDateList"; //双师课堂日期列表数据
  static const String api_classroomaddvideo = "classroom/addVideoClass"; //双师课堂添加视频课程
  static const String api_delvideoclass = "classroom/delVideoClass"; //双师课堂添加视频课程
  static const String api_addcollect = "collect/addCollect"; //添加收藏
  static const String api_delcollect = "collect/delCollect"; //删除收藏
  static const String api_collectData = "collect/collectData"; //收藏列表
  static const String api_collectdate = "collect/collectDate"; //获取当天的收藏日期数据

  static const String api_collectvideolist = "collect/videoCollectList"; //视频收藏列表
  static const String api_addvideocollect = "collect/addVideoCollect"; //添加视频收藏
  static const String api_deletevideocollect = "collect/delVideoCollect"; //删除视频收藏



  static const String api_aivideo = "track/queryAIVideo"; //AI推荐视频数据
  static const String api_trackvideo = "track/trackVideo"; //视频数据追踪
  static const String api_workdate = "work/workDate"; //发布作业的日期
  static const String api_worklist = "work/workList";  //作业列表数据
  static const String api_workmark = "work/markWorkGrade"; //老师给学生作业打标记
  static const String api_workupload = "work_upload"; //作业提交
  static const String api_workcorrect = "work_correct"; //作业批改提交
  static const String api_workputscore = "work/putWorkScore"; //作业打分
  static const String api_getworkscorebyworkid = "work/getWorkScoreByWorkid"; //获取作业分数
  static const String api_workdelete = "work/deleteWork";  //删除作业
  static const String api_workdeletebyteacher = "work/deleteWorkByTeacher"; //老师删除学生作业

  static const String api_queryteacherbyschool = "home/queryTeacherBySchool"; //查询学校老师
  static const String api_pushnotice = "notice/pushNotice"; //发布公告
  static const String api_querynotice = "notice/queryNotice"; //获取学校通知 带noticeid就是回去下一条
  static const String api_querymywork = "work/queryMyWork"; //查询我的作业 带num表示要查的数量 不带查全部
  static const String api_headupload = "head_upload"; //用户头像上传
  static const String api_issuedateclasslist = "issue/issueDateClassListByCid"; //获取排课列表数据
  static const String api_issuevideopush = "issue/issueVideoPush"; //课堂视频推荐
  static const String api_issuevideolist = "issue/issueVideoList";  //课堂推荐视频列表
  static const String api_videostep = "home/queryVideoStep"; //获取视频步骤图
  static const String api_issuelistdateallclass = "issue/issueListDateAllClass"; //老师所在所有班级的日期数据
  static const String api_pushgallerytoissue = "issue/pushGalleryToIssue"; //推送图片到课堂
  static const String api_issueeditorupload = "issueeditorupload"; //课堂图片编辑后上传
  static const String api_issuelistbyteacher = "issue/issueListByTeacher"; //老师的课堂资料

  /************专栏**********************/
  static const String api_querycolumntype = "column/columnTypeList"; //专栏分类列表
  static const String api_querycolumnmine = "column/columnMineList"; //查询我的专栏数据
  static const String api_columnupload = "column_upload"; //专栏图片上传
  static const String api_addcolumn = "column/addSpecialColumn"; //添加专栏
  static const String api_columnlist = "column/specialColumnList"; //专栏列表
  static const String api_columngallery = "column/columnGalleryList"; //专栏图片列表
  static const String api_addcolumnsubscrible = "column/addColumnSubscrible"; //添加专栏订阅
  static const String api_removecolumnsubscrible = "column/removeColumnSubscrible"; //取消专栏订阅
  static const String api_columnsubscriblelist = "column/columnSubscribleList"; //专栏订阅列表
  static const String api_gallerylistbycolumn = "column/galleryListByColumn"; //获取专栏图片列表
  static const String api_unpdatecolumninfo = "column/updateColumnInfo"; //更新专栏信息
  static const String api_refreshcolumngallery = "column/refreshColumnGalleryList"; //刷新获取最新的专栏列表图片
  static const String api_loadmorecolumngallery = "column/loadMoreColumnGalleryList"; //加载更多专栏图片类别
  static const String api_refreshspecialcolumnlist = "column/refreshSpecialColumnList"; //刷新专栏列表
  static const String api_loadmorespecialcolumnlist = "column/loadMoreSpecialColumnList";  //加载更多专栏列表
  static const String api_deletegallerybycolumn = "column/deleteColumnGallery"; //删除专栏图片
  static const String api_deletecolumn = "column/deleteColumn"; //删除专栏


  /********************music and mv *******************/
  static const String api_loadmv = "other/loadMV"; //获取MV数据
  static const String api_loadmusic = "other/loadMusic"; //获取music数据

  /**************留言****************/
  static const String api_querymessage = "message/queryMessage"; // 查询留言信息
  static const String api_addmessage = "message/addMessage"; //添加留言信息
  static const String api_queryrelation = "message/queryRelation"; //查询关联信息

  /*************短视频***************/
  static const String api_uploadshortvideo = "video_upload"; //短视频上传


  /*************英语单词*****************/
  static const String api_queryegword = "word/queryEgWord"; //查询英文单词
  static const String api_queryegwordgroup = "word/queryEgWordGroup"; //查询英文单词词组

  /*************学校招生简章*************/
  static const String api_schoolbrochure = "advert/querySchoolBrochure"; //学校对应招生简章数据

  /*************激活账号****************/
  static const String api_activeuser = "user/activeUser";

  /*************直播相关****************/
  static const String api_liveroom = "live/getLiveRoom"; //学校对应的直播房间
  static const String api_recordlist = "live/getRoomRecordlist"; //录播列表
  static const String api_roomlivelist = "live/getRoomLiveList"; //获取房间直播
  static const String api_roominfo = "live/getRoomInfo"; //获取直播房间信息
  static const String api_editorliveroom = "live/editorRoomInfo"; //编辑直播房间信息
  static const String api_delliverecord = "live/delRoomLiveRecord"; //删除直播回放
  static const String api_liverooninfobysid = "live/getRoomInfoBySid"; //获取学校对应的直播房间信息

  static const String api_ccliverecordlist = "v2/record/info"; //cc直播回放
  static const String api_ccliveroominfo = "room/search"; //直播房间信息
  static const String api_ccliveroomstate = "rooms/publishing"; //直播间状态


}