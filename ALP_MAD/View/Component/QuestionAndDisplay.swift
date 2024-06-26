//
//  QuestionAndImage.swift
//  ALP_MAD
//
//  Created by MacBook Pro on 19/05/24.
//

import SwiftUI
import AVKit

struct QuestionAndDisplay: View {
    
    let type: String
    let currentIsland: Island
    @Binding var stopVideo: Bool

    var body: some View {
        switch type {
        case "Bahasa" :
            self.showTraditionalLanguageQuestionDetail()
        case "Tarian" :
            self.showTraditionalDanceQuestionDetail()
        default :
            self.showErrorDetail()
        }
        
    }
    
    private func showTraditionalDanceQuestionDetail() -> some View {
        VStack(content: {
            HStack(content: {
                Text("Tari tradisional dari Pulau \(currentIsland.islandName) yaitu...")
                    .font(ScreenSize.screenWidth > 600 ? .system(size: 38) : .title2)
                    .foregroundStyle(Color.black)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)

                Spacer()
            })
            .multilineTextAlignment(.leading)
            if let videoURL = Bundle.main.url(forResource: currentIsland.traditionalDance.image, withExtension: "mp4") {
                
                VideoPlayerView(videoURL: videoURL, type: "Game", stopVideo: $stopVideo)
            }
        })
        .padding(.top, ScreenSize.screenWidth > 600 ? 0 : 10)
    }
    
    private func showTraditionalLanguageQuestionDetail() -> some View {
        VStack(content: {
            HStack(content: {
                Text("\(currentIsland.traditionalLanguage.sentences) merupakan bahasa daerah...")
                    .font(ScreenSize.screenWidth > 600 ? .system(size: 38) : .title2)
                    .foregroundStyle(Color.black)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)


                Spacer()
            })
            .multilineTextAlignment(.leading)

            if let image = currentIsland.traditionalLanguage.image {
                Image(image)
                    .resizable()
                    .frame(
                        width: ScreenSize.screenWidth > 600 ? ScreenSize.screenWidth / 1.3 : ScreenSize.screenWidth / 1.1,
                        height: ScreenSize.screenWidth > 600 ? ScreenSize.screenHeight / 3 : ScreenSize.screenHeight / 4
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius:5)
                    .padding(.bottom, ScreenSize.screenWidth > 600 ? 8 : 12)
            }
            
        })
        .padding(.top, ScreenSize.screenWidth > 600 ? 0 : 10)
    }
    
    private func showErrorDetail() -> some View {
        VStack(content: {
            Text("404 Error!")
        })
    }
}
