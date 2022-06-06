package com.yhschool.utils;

/**
 * ConfigUtil
 *
 * @author xxx
 */
public class ConfigUtil {
    /**
     * 账号ID 可以替换为自己的USER_ID
     * 391E6E3340A00767
     */

    public static final String USER_ID = "A478E06B5AA1107B";

    /**
     * 可以替换为自己的API_KEY
     * T8WdOUuvFEiOsou1xjDr4U73v12M7iNa
     */
    public static final String API_KEY = "0HA3SvI0x13GwQoQ9McU1o6xyJHW9KtV";
    /**
     * 获取视频信息的地址
     */

    public final static String DATA_URL = "https://p.bokecc.com/demo/videoinfo.json";

    /**
     * 配置下载文件路径
     */
    public final static String DOWNLOAD_PATH = "HuodeDownload";

    /**
     * 下载重试次数
     */
    public final static int DOWNLOAD_RECONNECT_LIMIT = 60;

    /**
     * 配置同时下载个数
     */
    public final static int DOWNLOADING_MAX = 2;

    /**
     * 配置同时上传个数
     */
    public final static int UPLOADING_MAX = 2;

    public final static int DOWNLOAD_FRAGMENT_MAX_TAB_SIZE = 2;

    public final static String ACTION_UPLOAD = "video.upload";

    /**
     * 配置视频回调地址
     */
    public final static String NOTIFY_URL = "http://www.example.com";

    public static boolean AutoPlay = true;

}
