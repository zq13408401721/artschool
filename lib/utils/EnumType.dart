enum PlatformType{
  iphone,
  pad
}

/**
 * 发布类别
 * issue 发布  pan网盘功能 avatar头像 work 作业 column 专栏  plan图文排课
 */
enum UploadType{
  ISSUE,
  PAN,
  AVATAR,
  WORK,
  COLUMN,
  PLAN
}

/**
 * 我的页面触发刷新的命令
 */
enum CMD_MINE{
  //修改昵称刷新
  CMD_NICKNAME,
  //登录刷新
  CMD_LOGIN,
  CMD_PAGE_COLUMN_MINE, //我的专栏
  CMD_PAGE_CLASSPLAN, //我的课件
  CMD_PAGE_MYWORK, //我的作业
  CMD_PAGE_VIDEO, //视频播放页
}

/**
 * 教案中的分类Class 今日课堂  NET 电教
 */
enum TEACH{
  CLASS,
  NET,
  WORK
}

/**
 * 我的页面图标类型
 */
enum IconType{
  SUBJECT,COLLECT,MATERIAL,PHONE,PRICE,VERSION
}

/**
 * 自定义Tile类型
 */
enum TileType{
  IMAGE,WORD,CheckBox
}

/**
 * 删除网盘或删除网盘图片
 */
enum PanDeleteType{
  PAN,FILE
}

/**
 * 网盘编辑
 */
enum PanEditor{
  EDITOR,DELETE
}
