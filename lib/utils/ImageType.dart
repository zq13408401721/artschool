
enum ImageType{
  fix, //固定width height
  scale, //不固定 用到发布功能里面
  smallOffical, //官方小图模式
  smallSchool, //学校小图
  fill, //拉伸填充方式
  normal, //server服务器上的资源
  issue //上传
}

/**
 * 视频的类别
 */
enum VideoType{
  official, //官方平台
  school //学校的视频
}

enum BigImageType {
  gallery,
  pan,
  issue,
  work,
  correct,
  book
}