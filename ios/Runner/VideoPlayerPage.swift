//
//  VideoPlayerPage.swift
//  Runner
//
//  Created by 张权 on 2023/5/20.
//

import SwiftUI
import AVKit

struct VideoPlayerPage: View {
    
    var videoPlayer:AVPlayer
    
    @Environment (\.verticalSizeClass) var verticalSizeClass
    
    @State var isLand = false
    let orientationPublisher = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
    var body: some View {
    
        if #available(iOS 16.0, *) {
            //let layout = verticalSizeClass == .compact ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout())
            let layout = AnyLayout(HStackLayout())
            layout {
                VideoPlayer(player:videoPlayer)
                
            }
        } else {
            // Fallback on earlier versions
        }
        
        
        /*Text(isLand ? "我现在是横屏" : "我现在是竖屏")
                    .onReceive(orientationPublisher) { _ in
                        let windowScene = UIApplication.shared.windows.first? .windowScene
                        self.isLand = windowScene?.interfaceOrientation.isLandscape ?? false
                    }*/
        
    }
}

struct VideoPlayerPage_Previews: PreviewProvider {
    static var previews: some View {
        VideoPlayerPage(videoPlayer: AVPlayer())
    }
}
