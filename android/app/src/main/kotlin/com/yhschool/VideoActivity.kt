package com.yhschool

import android.app.Activity
import android.app.PendingIntent
import android.app.RemoteAction
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.ActivityInfo
import android.graphics.SurfaceTexture
import android.graphics.drawable.Icon
import android.media.AudioManager
import android.os.Build
import android.os.Bundle
import android.text.TextUtils
import android.view.*
import android.widget.RelativeLayout
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.Fragment
import androidx.fragment.app.FragmentManager
import androidx.fragment.app.FragmentPagerAdapter
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.observe
import com.bokecc.sdk.mobile.exception.HuodeException
import com.bokecc.sdk.mobile.play.DWIjkMediaPlayer
import com.bokecc.sdk.mobile.play.MediaMode
import com.bokecc.sdk.mobile.play.OnDreamWinErrorListener
import com.bokecc.sdk.mobile.play.PlayInfo
import com.bumptech.glide.Glide
import com.bumptech.glide.load.engine.DiskCacheStrategy
import com.yhschool.data.VideoData
import com.yhschool.evts.CallBack
import com.yhschool.ui.VideoListFragment
import com.yhschool.utils.ConfigUtil
import com.yhschool.utils.MultiUtils
import com.yhschool.vm.VideoViewModel
import com.yhschool.widget.HotspotSeekBar
import com.yhschool.R
import kotlinx.android.synthetic.main.activity_video.*
import tv.danmaku.ijk.media.player.IMediaPlayer
import java.util.*
import kotlin.collections.ArrayList

class VideoActivity : AppCompatActivity(),
        TextureView.SurfaceTextureListener, IMediaPlayer.OnPreparedListener,IMediaPlayer.OnInfoListener,IMediaPlayer.OnBufferingUpdateListener,
        IMediaPlayer.OnCompletionListener,OnDreamWinErrorListener,IMediaPlayer.OnErrorListener
{

    private lateinit var vm:VideoViewModel

    private lateinit var playSurface:Surface
    private lateinit var player:DWIjkMediaPlayer
    private lateinit var myFragmentAdapter:MyFragmentAdapter
    private lateinit var playInfo:PlayInfo
    private var playUrl:String = ""
    private var isFullScreen=false
    private var isPrepared = false
    private var videoWidth:Int = 0
    private var videoHeight:Int = 0
    private var currentPosition:Int = 0 //当前视频的位置
    private var videoDuration:Int=0  //视频总时长
    //记录网络状态 0：无网络 1：WIFI 2：移动网络 3：WIFI和移动网络
    private var netWorkStatus:Int = 1 //网络状态值
    private var isNoNetPause:Boolean = false
    private var isSmallWindow:Boolean = false //小窗口
    private var returnListenTime:Int = 0

    private var landScapeHeight = 0
    private  var landScapeMarginTop:Int = 0

    //滑动调节进度亮度和音量
    private var downX = 0f  //滑动调节进度亮度和音量
    private var downY = 0f  //滑动调节进度亮度和音量
    private var upX = 0f  //滑动调节进度亮度和音量
    private var upY = 0f  //滑动调节进度亮度和音量
    private var xMove = 0f  //滑动调节进度亮度和音量
    private var yMove = 0f  //滑动调节进度亮度和音量
    private var absxMove = 0f  //滑动调节进度亮度和音量
    private var absyMove = 0f  //滑动调节进度亮度和音量
    private var lastX = 0f  //滑动调节进度亮度和音量
    private var lastY = 0f
    private var audioManager: AudioManager? = null
    private var currentVolume = 100
    private  var maxVolume:Int = 100

    private val maxBrightness = 100
    private  var halfWidth:Int = 0
    private  var controlChange:Int = 70
    private var isChangeBrightness = false

    private var currentVideoSizePos = 1
    private  var currentBrightness:Int = 0
    private  var lastPlayPosition:Int = 0

    //授权验证码
    private var verificationCode: String? = null

    //是否锁定
    private val isLock = false

    /*private val ll_brightness: LinearLayout? = null
    private val pb_brightness: ProgressBar? = null*/
    private var slideProgress: Long = 0

    private val smallWindowAction = "com.bokecc.vod.play.SMALL_WINDOW"
    private var actions: ArrayList<RemoteAction>? = null
    private val SMALL_WINDOW_PLAY_OR_PAUSE = 5
    private var pauseRemoteAction: RemoteAction? = null
    private  var playRemoteAction:RemoteAction? = null
    private var smallWindowReceiver: SmallWindowReceiver? = null
    private var playedTime: Long = 0
    private var controlHide = 8

    private var videoId:String = "7BDE44F7BFD8A3C7FC9558351D509E7C ";

    private var fragments = arrayListOf<Fragment>()
    private var tabs = arrayListOf<String>("目录", "详情", "评论")
    private var playInit:Boolean = false
    private var videos:ArrayList<VideoData.Data> = arrayListOf()

    private var activity:Activity? = null

    private  var controlHideTask:ControlHideTask? = null
    private  var hideTimer:Timer? = null
    private  var timer:Timer? = null
    private  var videoTask:VideoTask? = null
    private var stageW:Int = 0;
    private var stageH:Int = 0;

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_video)
        var display = windowManager.getDefaultDisplay()
        stageW = display.getWidth();
        stageH = display.getHeight();
        activity = this
        initVM()
        initView()
        initData()
        //playVideoOrAudio(false,false)

        //查看上次退出前是否有保存数据
        if(savedInstanceState != null){
            if(savedInstanceState.containsKey("isFullScreen")){
                isFullScreen = savedInstanceState.getBoolean("isFullScreen")
                if(isFullScreen){
                    setLandScape()
                }
                currentPosition = savedInstanceState.getLong("position").toInt()
            }
        }
    }

    private fun initVM(){
        vm = ViewModelProvider.AndroidViewModelFactory(application).create(VideoViewModel::class.java)
        vm.parseIntent(intent)
        //监听完了数据请求返回
        vm.videoData.observe(this, {
            videos = it as ArrayList<VideoData.Data>
            (fragments.get(0) as VideoListFragment).setData(videos)
            if (playInit) {
                if (videos.get(0).ccid != null) {
                    this.videoId = videos.get(0).ccid as String
                    playVideoOrAudio(false, false)
                }
            }
        })

        //获取视频列表
        vm.getVideoList()
    }

    fun initView() {

        tabVideo.addTab(tabVideo.newTab().setText(tabs[0]))
        tabVideo.addTab(tabVideo.newTab().setText(tabs[1]))
        tabVideo.addTab(tabVideo.newTab().setText(tabs[2]))
        fragments.add(VideoListFragment.listFragment)
        fragments.add(Fragment())
        fragments.add(Fragment())
        myFragmentAdapter = MyFragmentAdapter(supportFragmentManager)
        viewPager.adapter = myFragmentAdapter
        tabVideo.setupWithViewPager(viewPager)
        tabVideo.getTabAt(0)!!.select()
        initVideo()
        initPlayer()

        VideoListFragment.listFragment.addClickEvt(object : CallBack {
            override fun onClick(data: Any) {
                if ((data as VideoData.Data).ccid != null) {
                    videoId = (data as VideoData.Data).ccid
                    playVideoOrAudio(false, false)
                }
            }
        })
    }

    fun initVideo(){
        tv_video.surfaceTextureListener = this

        tv_video.setOnClickListener({
            if (ll_progress_and_fullscreen.visibility == View.VISIBLE) {
                hideOtherOperations()
                cancelVideoTimer()
            } else {
                showOtherOperations()
                startVideoTimer()

            }
        })

        //全屏监听
        iv_video_full_screen.setOnClickListener({
            if (isFullScreen) {
                setPortrait()
            } else {
                setLandScape()
            }
        })

        /**
         * 暂停 / 播放
         */
        iv_play_pause.setOnClickListener({
            if(player != null && player.isPlaying){
                iv_play_pause.setImageResource(R.mipmap.iv_play)
                player.pause()
            }else{
                iv_play_pause.setImageResource(R.mipmap.iv_pause)
                player.start()
            }
        })

        //拖动视频
        sb_progress.setOnSeekBarChangeListener(object : HotspotSeekBar.OnSeekBarChangeListener {
            override fun onStartTrackingTouch(seekBar: HotspotSeekBar) {
                returnListenTime = seekBar.progress
            }

            override fun onStopTrackingTouch(seekBar: HotspotSeekBar, trackStopPercent: Float) {
                val stopPostion = (trackStopPercent * player.duration).toInt()
                player.seekTo(stopPostion.toLong())
            }
        })

        sb_portrait_progress.setOnSeekBarChangeListener(object : HotspotSeekBar.OnSeekBarChangeListener {
            override fun onStartTrackingTouch(seekBar: HotspotSeekBar) {
                returnListenTime = seekBar.progress
            }

            override fun onStopTrackingTouch(seekBar: HotspotSeekBar, trackStopPercent: Float) {
                val stopPostion = (trackStopPercent * player.duration).toInt()
                player.seekTo(stopPostion.toLong())
            }
        })

        //点击打点位置，从这个位置开始播放

        //点击打点位置，从这个位置开始播放
        sb_progress.setOnIndicatorTouchListener { currentPosition ->
            player.seekTo((currentPosition * 1000).toLong())
        }

        sb_portrait_progress.setOnIndicatorTouchListener { currentPosition ->
            player.seekTo((currentPosition * 1000).toLong())
        }

        audioManager = getSystemService(AUDIO_SERVICE) as AudioManager
        //maxVolume = audioManager!!.getStreamMaxVolume(AudioManager.STREAM_MUSIC)
        //currentVolume = audioManager!!.getStreamVolume(AudioManager.STREAM_MUSIC)

        audioManager!!.setStreamVolume(AudioManager.STREAM_MUSIC,currentVolume,0)

        /*pb_volume.setMax(maxVolume)
        pb_volume.setProgress(currentVolume)*/

        //获取当前亮度
        /*currentBrightness = MultiUtils.getSystemBrightness(this)
        pb_brightness.setMax(maxBrightness)
        pb_brightness.setProgress(currentBrightness)*/

        //滑动调节

        //滑动调节
        rl_play_video.setOnTouchListener { v, event ->
            val action = event.action
            when (action) {
                MotionEvent.ACTION_DOWN -> {
                    downX = event.x
                    downY = event.y
                    lastX = downX
                    lastY = downY
                    slideProgress = currentPosition.toLong()
                    halfWidth = MultiUtils.getScreenWidth(this) / 2
                    if (downX > halfWidth) {
                        isChangeBrightness = false
                        controlChange = 70
                    } else {
                        isChangeBrightness = true
                        controlChange = 15
                    }
                }
                MotionEvent.ACTION_MOVE -> {
                    val x = event.x
                    val y = event.y
                    val xMoveVolume: Float = x - lastX
                    val yMoveVolume: Float = y - lastY
                    val absxMoveVolume = Math.abs(xMoveVolume)
                    val absyMoveVolume = Math.abs(yMoveVolume)
                    if (absyMoveVolume > absxMoveVolume && absyMoveVolume > controlChange && !isLock) {
                        lastX = x
                        lastY = y
                        if (isChangeBrightness) {
                            //调节亮度
                            val changeBrightness = (absyMoveVolume / controlChange) as Int
                            if (yMoveVolume > 0) {
                                currentBrightness = currentBrightness - changeBrightness
                            } else {
                                currentBrightness = currentBrightness + changeBrightness
                            }
                            if (currentBrightness < 0) {
                                currentBrightness = 0
                            }
                            if (currentBrightness > maxBrightness) {
                                currentBrightness = maxBrightness
                            }
                            //ll_brightness.setVisibility(View.VISIBLE)
                            //ll_volume.setVisibility(View.GONE)
                            changeBrightness(this, currentBrightness)
                            //pb_brightness.setProgress(currentBrightness)
                        } else {
                            /*currentVolume  = audioManager!!.getStreamVolume(AudioManager.STREAM_MUSIC)
                            //调节音量
                            val changeVolume = (absyMoveVolume / controlChange) as Int
                            if (yMoveVolume > 0) {
                                currentVolume = currentVolume - changeVolume
                            } else {
                                currentVolume = currentVolume + changeVolume
                            }
                            if (currentVolume < 0) {
                                currentVolume = 0
                            }
                            if (currentVolume > maxVolume) {
                                currentVolume = maxVolume
                            }*/
                            //ll_volume.setVisibility(View.VISIBLE)
                            //ll_brightness.setVisibility(View.GONE)
                            //audioManager!!.setStreamVolume(AudioManager.STREAM_MUSIC, currentVolume, 0)
                            //pb_volume.setProgress(currentVolume)
                        }
                    } else if (absxMoveVolume > absyMoveVolume && absxMoveVolume > 50 && !isLock) {
                        lastX = x
                        lastY = y
                        val screenWidth = MultiUtils.getScreenWidth(this)
                        val changeProgress = (absxMoveVolume * videoDuration / screenWidth).toLong()
                        if (xMoveVolume > 0) {
                            //往右滑
                            slideProgress = slideProgress + changeProgress
                        } else {
                            //往左滑
                            slideProgress = slideProgress - changeProgress
                        }
                        if (slideProgress > videoDuration) {
                            slideProgress = videoDuration.toLong()
                        }
                        if (slideProgress < 0) {
                            slideProgress = 0
                        }
                        val videoTime = MultiUtils.millsecondsToMinuteSecondStr(videoDuration.toLong())
                        val currentTime = MultiUtils.millsecondsToMinuteSecondStr(slideProgress)
                        /*tv_slide_progress.setVisibility(View.VISIBLE)
                        tv_slide_progress.setText("$currentTime/$videoTime")*/
                    }
                }
                MotionEvent.ACTION_UP -> {
                    upX = event.x
                    upY = event.y
                    xMove = upX - downX
                    yMove = upY - downY
                    absxMove = Math.abs(xMove)
                    absyMove = Math.abs(yMove)
                    if (absxMove >= absyMove && absxMove > 50 && !isLock) {
                        //调节进度
                        player.seekTo(slideProgress.toLong())
                    }
                }
            }
            false
        }

        verificationCode = MultiUtils.getVerificationCode()


        //小窗播放

        //小窗播放
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            //iv_small_window_play.setVisibility(View.VISIBLE)
            actions = ArrayList<RemoteAction>()
            val icon: Icon = Icon.createWithResource(this, R.mipmap.iv_small_window_pause)
            val pauseIntent = PendingIntent.getBroadcast(this,
                    SMALL_WINDOW_PLAY_OR_PAUSE,
                    Intent(smallWindowAction).putExtra("control", 1),
                    PendingIntent.FLAG_UPDATE_CURRENT)
            pauseRemoteAction = RemoteAction(icon, "", "", pauseIntent)
            val iconPlay: Icon = Icon.createWithResource(this, R.mipmap.iv_small_window_play)
            val playIntent = PendingIntent.getBroadcast(this,
                    SMALL_WINDOW_PLAY_OR_PAUSE,
                    Intent(smallWindowAction).putExtra("control", 2),
                    PendingIntent.FLAG_UPDATE_CURRENT)
            playRemoteAction = RemoteAction(iconPlay, "", "", playIntent)
            smallWindowReceiver = SmallWindowReceiver()
            val intentFilter: IntentFilter = IntentFilter(smallWindowAction)
            registerReceiver(smallWindowReceiver, intentFilter)
        }
    }

    fun initPlayer(){
        player = DWIjkMediaPlayer()
        player.setOnPreparedListener(this)
        player.isAutoPlay = ConfigUtil.AutoPlay
        player.setOnInfoListener(this)
        player.setOnBufferingUpdateListener(this)
        player.setOnCompletionListener(this)
        player.setOnDreamWinErrorListener(this)
        player.setOnErrorListener(this)
    }

    fun initData() {

        //mViewModel.parseIntent(intent)
        /*var map = HashMap<String, String>()
        map.put("categoryid", mViewModel.categoryid.toString())
        map.put("page", mViewModel.page.toString())
        map.put("size", mViewModel.size.toString())
        mViewModel.getVideoList(map)*/
    }



    inner class MyFragmentAdapter(fm: FragmentManager):FragmentPagerAdapter(fm){
        override fun getCount(): Int {
            return tabs.size
        }

        override fun getItem(position: Int): Fragment {
            return fragments[position]
        }

        override fun getPageTitle(position: Int): CharSequence? {
            return tabs[position]
        }

    }

    override fun onSurfaceTextureAvailable(surface: SurfaceTexture, width: Int, height: Int) {
        playSurface = Surface(surface)
        player.setSurface(playSurface)
        playInit = true
        if(videos.size > 0 && videos.get(0).ccid != null){
            this.videoId = videos.get(0).ccid
            playVideoOrAudio(false, false)
        }

    }

    override fun onSurfaceTextureSizeChanged(surface: SurfaceTexture, width: Int, height: Int) {
        if (player.getOnSubtitleMsgListener() != null) {
            player.getOnSubtitleMsgListener().onSizeChanged(width, height)
        }
    }

    override fun onSurfaceTextureDestroyed(surface: SurfaceTexture): Boolean {
        return false
    }

    override fun onSurfaceTextureUpdated(surface: SurfaceTexture) {

    }

    override fun onPrepared(mp: IMediaPlayer) {
        playInfo = player.playInfo
        if (!TextUtils.isEmpty(playInfo.getCoverImage())) {
            Glide.with(this).load(playInfo.getCoverImage())
                    .skipMemoryCache(true)
                    .diskCacheStrategy(DiskCacheStrategy.NONE)
                    .into(coverImage)
        } else {
            Glide.with(this).load(R.drawable.test).into(coverImage)
        }
        if (player.definitionChanged()) {
            coverImage.visibility = View.INVISIBLE
            iv_play_pause.setImageResource(R.mipmap.iv_pause)
        } else {
            coverImage.visibility = if (player.isAutoPlay) View.INVISIBLE else View.VISIBLE
        }
        if (playInfo != null) {
            playUrl = playInfo.getPlayUrl()
        }

        hidePlayErrorView()
        //得到视频的宽和高
        //得到视频的宽和高
        videoHeight = player.videoHeight
        videoWidth = player.videoWidth

        //设置生成gif图片的分辨率


        if (!isFullScreen) {
            setPortVideo()
        } else {
            //重置画面大小
            setSize(1)
        }
        ll_load_video.visibility = View.GONE
        clv_logo.show()



        //设置视频总时长
        //设置视频总时长
        videoDuration = player.duration.toInt()
        tv_video_time.text = MultiUtils.millsecondsToMinuteSecondStr(videoDuration.toLong())
        tv_portrait_video_time.text = MultiUtils.millsecondsToMinuteSecondStr(videoDuration.toLong())

        showOtherOperations()
        //更新播放进度
        //更新播放进度
        startVideoTimer()
        //控制界面的隐藏
        //控制界面的隐藏
        controlHideView()

    }

    //设置画面尺寸
    private fun setSize(position: Int) {
        currentVideoSizePos = position
        if (videoHeight > 0) {
            val videoParams = tv_video.layoutParams
            var landVideoHeight = MultiUtils.getScreenHeight(this)
            var landVideoWidth = landVideoHeight * videoWidth / videoHeight
            val screenHeight = MultiUtils.getScreenWidth(this)
            if (landVideoWidth > screenHeight) {
                landVideoWidth = screenHeight
                landVideoHeight = landVideoWidth * videoHeight / videoWidth
            }
            if (position == 0) {
                landVideoHeight = MultiUtils.getScreenHeight(this)
                landVideoWidth = MultiUtils.getScreenWidth(this)
            } else if (position == 1) {
                landVideoHeight = 1 * landVideoHeight
                landVideoWidth = 1 * landVideoWidth
            } else if (position == 2) {
                landVideoHeight = (0.75 * landVideoHeight).toInt()
                landVideoWidth = (0.75 * landVideoWidth).toInt()
            } else if (position == 3) {
                landVideoHeight = (0.5 * landVideoHeight).toInt()
                landVideoWidth = (0.5 * landVideoWidth).toInt()
            }
            videoParams.height = landVideoHeight
            videoParams.width = landVideoWidth
            tv_video.layoutParams = videoParams
        }
    }

    private fun hidePlayErrorView() {
        ll_load_video.visibility = View.VISIBLE
        ll_play_error.visibility = View.GONE
    }

    override fun onInfo(p0: IMediaPlayer?, p1: Int, p2: Int): Boolean {
        when (p1) {
            DWIjkMediaPlayer.MEDIA_INFO_BUFFERING_START -> {

                netWorkStatus = MultiUtils.getNetWorkStatus(this)
                if (netWorkStatus == 0) {
                    isNoNetPause = true
                    showPlayErrorView()
                    hideOtherOperations()
                    tv_error_info.text = "请检查你的网络连接"
                    tv_operation.text = "重试"
                    tv_operation.setOnClickListener {
                        hidePlayErrorView()
                        playVideoOrAudio(false, false)
                    }
                } else {
                    ll_load_video.visibility = View.VISIBLE
                }
            }
            DWIjkMediaPlayer.MEDIA_INFO_BUFFERING_END -> {
                if (player.isAutoPlay) {
                    iv_play_pause.setImageResource(R.mipmap.iv_pause)
                }
                ll_load_video.visibility = View.GONE
            }
        }
        return false
    }

    private fun showPlayErrorView() {
        ll_load_video.visibility = View.GONE
        ll_play_error.visibility = View.VISIBLE
    }

    //显示视频操作
    private fun showOtherOperations() {
        ll_progress_and_fullscreen.visibility = View.VISIBLE
        /*ll_title_and_audio.setVisibility(View.VISIBLE)
        if (isProjectioning) {
            ll_title_and_audio.setBackgroundColor(resources.getColor(R.color.transparent))
            iv_switch_to_audio.setVisibility(View.INVISIBLE)
            iv_small_window_play.setVisibility(View.INVISIBLE)
            iv_portrait_projection.setVisibility(View.INVISIBLE)
            iv_portrait_screenshot.setVisibility(View.INVISIBLE)
        } else {
            if (!isFullScreen) {
                iv_switch_to_audio.setVisibility(View.VISIBLE)
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    iv_small_window_play.setVisibility(View.VISIBLE)
                }
                iv_portrait_projection.setVisibility(View.VISIBLE)
                if (!isAudioMode) {
                    iv_portrait_screenshot.setVisibility(View.VISIBLE)
                }
            }
            ll_title_and_audio.setBackgroundColor(resources.getColor(R.color.play_ope_bac_color))
        }
        iv_back.setVisibility(View.VISIBLE)*/
    }

    //隐藏视频操作
    private fun hideOtherOperations() {
        ll_progress_and_fullscreen.visibility = View.INVISIBLE
    }

    /**
     * 播放音视频
     *
     * @param isAudioMode 是否是音频模式
     * @param isResetPos  是否重置当前记录播放的位置
     */
    private fun playVideoOrAudio(isAudioMode: Boolean, isResetPos: Boolean) {
        //iv_back.setVisibility(View.VISIBLE)

        //updateLastPlayPosition()
        isPrepared = false
       // getLastVideoPostion()
        tv_play_definition.visibility = View.VISIBLE
        player.setDefaultPlayMode(MediaMode.VIDEOAUDIO) { }
        ll_load_video.visibility = View.VISIBLE
        hideOtherOperations()
        player.pause()
        player.stop()
        player.reset()
        //setClientId()方法在setVideoPlayInfo()前调用，可以通过此方法设置用户标识，出问题时方便排查
        player.setClientId("")
        player.setVideoPlayInfo(videoId, ConfigUtil.USER_ID, ConfigUtil.API_KEY, verificationCode, this)
        player.setSurface(playSurface)
        MyApp.Companion.drmServer!!.resetLocalPlay()
        //player.setSpeed(currentSpeed)
        //player.setAudioPlay(isAudioMode)
        player.prepareAsync()
        if(currentPosition > 0){
            player.seekTo(currentPosition.toLong())
        }
        //updatePlayingItem()
    }

    //缓冲进度
    override fun onBufferingUpdate(p0: IMediaPlayer?, percent: Int) {
        sb_progress.setSecondaryProgress(percent)
        sb_portrait_progress.setSecondaryProgress(percent)
    }

    //播放完成
    override fun onCompletion(p0: IMediaPlayer?) {
        if (isSmallWindow) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                sendBroadcast(Intent("com.bokecc.vod.play.SMALL_WINDOW").putExtra("control", 3))
            }
            return
        }
        //updatePlayCompleted()
    }

    //获得场景视频自定义错误类型
    override fun onPlayError(e: HuodeException) {
        runOnUiThread {
            when (e.getIntErrorCode()) {
                103 -> {
                    tv_error_info.text = "音频无播放节点（" + e.getIntErrorCode() + "）"
                    showPlayErrorView()
                    hideOtherOperations()
                    tv_operation.text = "切换到视频"
                    tv_operation.setOnClickListener {
                        hidePlayErrorView()
                        playVideoOrAudio(false, false)
                    }
                }
                102 -> {
                    //切换到音频
                    /* isAudioMode = true
                    playVideoOrAudio(isAudioMode, false)*/
                }
                104 -> {
                    tv_error_info.text = "授权验证失败（" + e.getIntErrorCode() + "）"
                    showPlayErrorView()
                    hideOtherOperations()
                    tv_operation.visibility = View.GONE
                }
                108 -> {
                    tv_error_info.text = "账号信息不匹配（" + e.getIntErrorCode() + "）"
                    showPlayErrorView()
                    hideOtherOperations()
                    tv_operation.visibility = View.GONE
                }
                else -> {
                    tv_error_info.text = "播放异常（" + e.getIntErrorCode() + "）"
                    showPlayErrorView()
                    hideOtherOperations()
                    tv_operation.visibility = View.GONE
                }
            }
        }
    }

    //播放错误
    override fun onError(p0: IMediaPlayer?, what: Int, i1: Int): Boolean {
        runOnUiThread(Runnable {
            netWorkStatus = MultiUtils.getNetWorkStatus(this)
            if (netWorkStatus == 0) {
                isNoNetPause = true
            }
            /*if (what == -10000 && netWorkStatus != 0 && retryPlayTimes < 3 && !isLocalPlay) {
                playVideoOrAudio(isAudioMode, false)
                retryPlayTimes++
                return@Runnable
            }*/
            tv_error_info.text = "播放出现异常（$what）"
            showPlayErrorView()
            hideOtherOperations()
            tv_operation.visibility = View.VISIBLE
            tv_operation.text = "重试"
            tv_operation.setOnClickListener(View.OnClickListener {
                if (netWorkStatus == 0) {
                    MultiUtils.showToast(this, "请检查你的网络连接")
                    return@OnClickListener
                }
                hidePlayErrorView()
                playVideoOrAudio(false, false)
            })
        })
        return true
    }

    //开启更新播放进度任务
    private fun startVideoTimer() {
        cancelVideoTimer()
        timer = Timer()
        videoTask = VideoTask()
        timer!!.schedule(videoTask, 0, 1000)
    }


    //取消更新播放进度任务
    private fun cancelVideoTimer() {
        if (timer != null) {
            timer!!.cancel()
        }
        if (videoTask != null) {
            videoTask!!.cancel()
        }
    }

    // 播放进度计时器
    inner class VideoTask : TimerTask() {
        override fun run() {
            if (MultiUtils.isActivityAlive(activity)) {
                activity!!.runOnUiThread(Runnable {
                    currentPosition = player.getCurrentPosition().toInt()
                    if (playedTime < currentPosition) {
                        playedTime = currentPosition.toLong()
                    }
                    tv_current_time.setText(MultiUtils.millsecondsToMinuteSecondStr(currentPosition.toLong()))
                    tv_portrait_current_time.setText(MultiUtils.millsecondsToMinuteSecondStr(currentPosition.toLong()))
                    sb_progress.setProgress(currentPosition as Int, videoDuration as Int)
                    sb_portrait_progress.setProgress(currentPosition as Int, videoDuration as Int)
                })
            }
        }
    }

    private fun hideViews() {
        hideOtherOperations()
        /*iv_landscape_screenshot.setVisibility(View.GONE)
        iv_back.setVisibility(View.GONE)
        iv_lock_or_unlock.setVisibility(View.GONE)*/
    }

    //控制界面的隐藏
    private fun controlHideView() {
        cancelControlHideView()
        controlHide = 8
        hideTimer = Timer()
        controlHideTask = ControlHideTask()
        hideTimer!!.schedule(controlHideTask, 0, 1000)
    }

    //取消控制界面的隐藏
    private fun cancelControlHideView() {
        if (hideTimer != null) {
            hideTimer!!.cancel()
        }
        if (controlHideTask != null) {
            controlHideTask!!.cancel()
        }
    }

    // 控制界面的隐藏计时器
    inner class ControlHideTask : TimerTask() {
        override fun run() {
            if (MultiUtils.isActivityAlive(activity)) {
                activity!!.runOnUiThread(Runnable {
                    controlHide = controlHide - 1
                    if (controlHide == 0) {
                        hideViews()
                    }
                })
            }
        }
    }

    /**
     * brightnessValue 取值范围0-100
     */
    private fun changeBrightness(context: Activity, brightnessValue: Int) {
        val localWindow = context.window
        val localLayoutParams = localWindow.attributes
        localLayoutParams.screenBrightness = brightnessValue / 100.0f
        localWindow.attributes = localLayoutParams
    }


    internal class SmallWindowReceiver : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val control = intent.getIntExtra("control", 0)
            /*if (control == 1 || control == 2) {
                playOrPauseVideo()
                updateSmallWindowActions()
            } else if (control == 3) {
                if (isSmallWindow) {
                    finish()
                }
            }*/
        }
    }

    /************全屏设置***************/
    //退出全屏播放
    private fun setPortrait() {
        iv_video_full_screen.visibility = View.VISIBLE
        ll_speed_def_select.visibility = View.GONE
        iv_next_video.visibility = View.GONE

        ll_landscape_progress.visibility = View.GONE
        ll_portrait_progress.visibility = View.VISIBLE

        //小屏播放隐藏打点信息
        sb_progress.setHotspotShown(false)
        sb_portrait_progress.setHotspotShown(false)
        window.clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
        activity!!.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT
        val videoLayoutParams = rl_play_video.layoutParams as RelativeLayout.LayoutParams
        videoLayoutParams.topMargin = landScapeMarginTop
        videoLayoutParams.width = ViewGroup.LayoutParams.MATCH_PARENT
        videoLayoutParams.height = landScapeHeight
        rl_play_video.layoutParams = videoLayoutParams
        //设置竖屏TextureView的宽和高
        setPortVideo()
        isFullScreen = false
        clv_logo.refreshView()
    }

    //设置为全屏播放
    private fun setLandScape() {
        iv_video_full_screen.visibility = View.GONE
        //倍数 清晰选集
        //ll_speed_def_select.visibility = View.VISIBLE


        /*iv_small_window_play.setVisibility(View.GONE)
        iv_portrait_screenshot.setVisibility(View.GONE)
        iv_portrait_projection.setVisibility(View.GONE)*/
        ll_landscape_progress.visibility = View.VISIBLE
        ll_portrait_progress.visibility = View.GONE


        //全屏播放展示打点信息
        sb_progress.setHotspotShown(true)
        sb_portrait_progress.setHotspotShown(true)
        window.addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
        activity!!.requestedOrientation = ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE
        val videoLayoutParams = rl_play_video.layoutParams as RelativeLayout.LayoutParams
        landScapeHeight = videoLayoutParams.height
        landScapeMarginTop = videoLayoutParams.topMargin
        videoLayoutParams.topMargin = 0
        videoLayoutParams.width = ViewGroup.LayoutParams.MATCH_PARENT
        videoLayoutParams.height = ViewGroup.LayoutParams.MATCH_PARENT
        rl_play_video.layoutParams = videoLayoutParams
        setLandScapeVideo()
        isFullScreen = true

        clv_logo.refreshView()
    }

    //设置横屏TextureView的宽和高,使视频高度和屏幕宽度一致
    private fun setLandScapeVideo() {
        if (videoHeight > 0) {
            val videoParams = tv_video.layoutParams
            var landVideoHeight = MultiUtils.getScreenWidth(activity)
            var limitedVideoWidth = MultiUtils.getScreenHeight(activity)
            val screenWidth = MultiUtils.getScreenWidth(activity)
            val screenHeight = MultiUtils.getScreenHeight(activity)
            if (screenWidth > screenHeight) {
                landVideoHeight = screenHeight
                limitedVideoWidth = screenWidth
            }
            var landVideoWidth = landVideoHeight * videoWidth / videoHeight
            if (landVideoWidth > limitedVideoWidth) {
                landVideoWidth = limitedVideoWidth
                landVideoHeight = landVideoWidth * videoHeight / videoWidth
            }
            videoParams.height = landVideoHeight
            videoParams.width = landVideoWidth
            tv_video.layoutParams = videoParams
        }
    }

    //小屏播放时按比例计算宽和高，使视频不变形
    private fun setPortVideo() {
        if (videoHeight > 0) {
            val videoParams = tv_video.layoutParams
            var portVideoHeight = MultiUtils.dipToPx(activity, 300F)
            val limitedVideoHeight = MultiUtils.dipToPx(activity, 300F)
            var portVideoWidth = portVideoHeight * videoWidth / videoHeight
            var phoneWidth = 0
            val screenWidth = MultiUtils.getScreenWidth(activity)
            val screenHeight = MultiUtils.getScreenHeight(activity)
            phoneWidth = if (screenWidth > screenHeight) {
                screenHeight
            } else {
                screenWidth
            }
            portVideoWidth = phoneWidth
            portVideoHeight = portVideoWidth * videoHeight / videoWidth
            if (portVideoHeight > limitedVideoHeight) {
                portVideoHeight = limitedVideoHeight
                portVideoWidth = portVideoHeight * videoWidth / videoHeight
            }
            videoParams.height = portVideoHeight
            videoParams.width = portVideoWidth
            tv_video.layoutParams = videoParams
        }
    }

    /**
     * 屏幕旋转的时候保存页面数据
     */
    override fun onSaveInstanceState(outState: Bundle) {
        super.onSaveInstanceState(outState)
        outState.putBoolean("isFullScreen",isFullScreen)
        if(player.isPlaying){ //如果正在播放 存储当前播放的进度
            outState.putLong("position",player.currentPosition)
            player.stop()
        }
    }

    /**
     * 监听返回键
     * 如果当前是全屏播放 先退出全屏播放 如果当前是小屏播放 直接退回到上一个页面
     */
    override fun onKeyUp(keyCode: Int, event: KeyEvent?): Boolean {
        if(keyCode == KeyEvent.KEYCODE_BACK && event!!.action == KeyEvent.ACTION_UP){
            if(isFullScreen){
                isFullScreen = false
                setPortrait() //退出全屏
                return true
            }else{
                //退到上一个页面
                return super.onKeyUp(keyCode, event)
            }
        }
        return super.onKeyUp(keyCode, event)
    }

    override fun onDestroy() {
        super.onDestroy()
        if(player != null && player.isPlaying){
            player.stop()
        }
    }

}