import UIKit
import AVFoundation
import SwiftUI
import Flutter

    @UIApplicationMain
    @objc class AppDelegate: FlutterAppDelegate {
    
  var myAppDelegate = UIApplication.shared.delegate as? AppDelegate
    
  var screen_set:SCREEN_SET = .set_auto
        
        
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
   
    let messenger:FlutterBinaryMessenger = self.window.rootViewController as! FlutterBinaryMessenger
    initPlugin(messenger: messenger)
      
      GeneratedPluginRegistrant.register(with: self)
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    func initPlugin(messenger:FlutterBinaryMessenger) {
        let channel = FlutterMethodChannel.init(name:"toNativeChannel",binaryMessenger:messenger)
        channel.setMethodCallHandler{ (call:FlutterMethodCall,result:@escaping FlutterResult) in
            if (call.method == "setLauncher") {
                //changeIcon()
                print("call :" + call.method)
                //self.changeIcon()
                result(1)
            } else if(call.method == "changeOrientation") {
                //var screen:Int = call.arguments
                print("changeOrientation")
                print(call.arguments)
            
                
                //self.changeOrientation(screen: 1)
                /*if #available(iOS 16.0, *){
                    print("ios 16")
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    print("land ",windowScene?.interfaceOrientation.isLandscape)
                    windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations:.landscapeRight))
                    let nav=UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
                    nav?.topViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
                    print("land over ",windowScene?.interfaceOrientation.isLandscape);
                }else{
                    print("ios is not 16")
                    //UIDevice.switchNewOrientation(.landscapeLeft)
                }*/
            } else if(call.method == "setVideoPlay") {
                //let argument = call.arguments as? String
                //print(argument)
                
                if let argument = call.arguments {
                    var param:String = argument as! String
                    param = param.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    if let url:URL = URL(string: param) {
                        
                        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                        if #available(iOS 16.0, *) {
                            print("ios 16")
                            windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations:.landscapeRight))
                            UIApplication.shared.windows.first?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
                        } else {
                            // Fallback on earlier versions
                        }
                        UIApplication.shared.windows.first?.rootViewController =
                        UIHostingController(rootView: VideoPlayerPage(videoPlayer: AVPlayer(url:url)))
                        
                    } else {
                        print("url is nil")
                    }
                    
                }
                
                
                //AVPlayer(url: URL(string: "\(videoUrl)")!)
                
                //let url = URL(string: videoUrl)
                
               /* if let param = argument {
                    let url = URL(string: param as String)
                    UIApplication.shared.windows.first?.rootViewController =
                    UIHostingController(rootView: VideoPlayerPage(videoPlayer: AVPlayer(url: url!)))
                } else {
                    print(argument)
                } */

            }
            
        }
    }
        
        /*func gotoPlayerPage() {
            NavigationLink(destination: VideoPlayerPage(videoUrl: "http://res.yimios.com:9070/video/shortvideo/1/8/%E7%83%88%E7%84%B0%E7%BA%A2%E5%94%87%20(1).mp4"), label:Text(""))
        }*/
        
    func changeIcon() {
        if #available(iOS 10.3, *) {
            if UIApplication.shared.supportsAlternateIcons {
                print("you can change this app's icon")
                print("替换前图标：\(UIApplication.shared.alternateIconName ?? "原始图标")")
                UIApplication.shared.setAlternateIconName("春") { (error:Error?) in
                    print("替换后图标：\(UIApplication.shared.alternateIconName ?? "原始图标")")
                }
            }else {
                print("you cannot change this app's icon")
                return
            }
            
            /*if let name = UIApplication.shared.alternateIconName {
                // CHANGE TO PRIMARY ICON  恢复默认 icon
                UIApplication.shared.setAlternateIconName(nil) { (err:Error?) in
                    print("set icon error：\(String(describing: err))")
                }
                print("the alternate icon's name is \(name)")
            }else {
                // CHANGE TO ALTERNATE ICON 指定icon图标
                //UIApplication.shared.setAlternateIconName("春") { (err:Error?) in
                //    print("set icon error：\(String(describing: err))")
                //}
                
                print("替换前图标：\(UIApplication.shared.alternateIconName ?? "原始图标")")
                //当前显示的是原始图标
                UIApplication.shared.setAlternateIconName("春", completionHandler: { (error: Error?) in
                print("替换后图标：\(UIApplication.shared.alternateIconName ?? "原始图标")")
                })
            }*/
        }
    }
    
    func changeOrientation(screen:Int){
        var mode:SCREEN_SET = screen == 0 ? SCREEN_SET.set_port : SCREEN_SET.set_land
        switchScreenOrientation(vc: self.window.rootViewController!, mode: mode)
    }
    
    /**
    * 改变屏幕的方向
     */
    func switchScreenOrientation(vc:UIViewController,mode:SCREEN_SET) {
        self.screen_set = mode
        if #available(iOS 16.0, *) {
            // ios 16以上需要通过scene来实现屏幕方向设置
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            /* switch mode {
            case .set_port:
                windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations:.portrait))
                break
            case .set_land:
                windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .landscape))
                break
            case .set_auto:
                windowScene?.requestGeometryUpdate(.iOS(interfaceOrientations: .all))
                break
            } */
            print("horizontal")
            //UIWindowScene.requestGeometryUpdate(.iOS(interfaceOrientations:.landscapeRight))
            //vc.setNeedsUpdateOfSupportedInterfaceOrientations()
        } else {
            //UIDevice.switchScreenOrientation(.landscapeRight)
            /* switch mode {
            case .set_port:
                //强制设置成竖屏
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
                break
            case .set_land:
                //强制设置成横屏
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
                break
            case .set_auto:
                //设置自动旋转
                UIDevice.current.setValue(UIInterfaceOrientation.unknown.rawValue, forKey: "orientation")
                break;
            } */
        }
    }

}



