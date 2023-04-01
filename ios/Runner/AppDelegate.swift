import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
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
            if(call.method == "setLauncher"){
                //changeIcon()
                print("call :" + call.method)
                self.changeIcon()
                result(1)
            }
            
        }
    }
        
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

}



