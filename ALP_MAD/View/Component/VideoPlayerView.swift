//
//  VideoPlayer.swift
//  ALP_MAD
//
//  Created by MacBook Pro on 04/06/24.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    
    var type: String
    let showAlert: Bool = true
    @StateObject private var playerWrapper: AVPlayerWrapper
    @Environment(\.scenePhase) private var scenePhase
    
    init(videoURL: URL, type: String) {
        _playerWrapper = StateObject(wrappedValue: AVPlayerWrapper(url: videoURL))
        self.type = type
    }
    
    //    init(videoURL: URL) {
    //        self.player = AVPlayer(url: videoURL)
    //    }
    
    var body: some View {
        if type == "Game" {
            VideoPlayer(player: playerWrapper.player)
                .frame(
                    width: ScreenSize.screenWidth > 600 ? ScreenSize.screenWidth / 1.3 : ScreenSize.screenWidth / 1.1,
                    height: ScreenSize.screenWidth > 600 ? ScreenSize.screenHeight / 3 : ScreenSize.screenHeight / 4
                )
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 5)
                .padding(.bottom, ScreenSize.screenWidth > 600 ? 8 : 12)
                .onAppear {
                    playerWrapper.play()
                }
                .onDisappear {
                    playerWrapper.pause()
                }
        }
        else if type == "Desc" {
            VideoPlayer(player: playerWrapper.player)
                .frame(height: ScreenSize.screenWidth > 600 ? ScreenSize.screenHeight/2.555 : ScreenSize.screenHeight/3.85)
                .clipShape(
                    RoundedCorner(cornerRadius: 40, corners: [.bottomLeft, .bottomRight])
                )
                .shadow(radius: 10, y: 4)
                .padding(.top, -8)
                .padding(.bottom, ScreenSize.screenWidth > 600 ? ScreenSize.screenHeight/40 : ScreenSize.screenHeight/80)
                .onAppear {
                    playerWrapper.play()
                }
                .onDisappear {
                    playerWrapper.pause()
                }
        }
        
//            .onChange(of: self.showAlert) { oldValue, newValue in
//                if newValue {
//                    playerWrapper.pause()
//                }
//                else {
//                    playerWrapper.play()
//                }
//            }
    }
}

class AVPlayerWrapper: ObservableObject {
    let player: AVPlayer
    
    init(url: URL) {
        self.player = AVPlayer(url: url)
    }
    
    func play() {
        player.play()
    }
    
    func pause() {
        player.pause()
    }
}
