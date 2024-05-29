//
//  AnswerDescriptionView.swift
//  ALP_MAD
//
//  Created by MacBook Pro on 12/05/24.
//

import SwiftUI

struct AdditionalQuestionView: View {
    
    @StateObject private var islandController = IslandController(island: ModelData.shared.currentIslandObject)
    @State private var answer : String = ""
    @State private var showAlert = false
    @State private var navToAnswerDescriptionView = false
    @State private var countDownTimer = 30
    @State private var timerRunning = false
    
    private var screenSize = ScreenSize()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        let isIpad = self.screenSize.screenWidth > 600
        
        self.setUpAdditionalQuestionView(islandController: islandController, answer: $answer, showAlert: $showAlert, navToAnswerDescriptionView: $navToAnswerDescriptionView, countDownTimer: $countDownTimer, timerRunning: $timerRunning, isIpad: isIpad)
    }
    
    private func setUpAdditionalQuestionView(islandController: IslandController, answer: Binding<String>, showAlert: Binding<Bool>, navToAnswerDescriptionView: Binding<Bool>, countDownTimer: Binding<Int>, timerRunning: Binding<Bool>, isIpad: Bool) -> some View {
        ScrollView {
            VStack(alignment: .center) {
                self.navigationBar(isIpad: isIpad)
                self.timer(countDownTimer: countDownTimer, timerRunning: timerRunning, showAlert: showAlert, isIpad: isIpad)
                self.question(isIpad: isIpad)
                self.answerOptions(islandController: islandController, navToAnswerDescriptionView: navToAnswerDescriptionView, answer: answer, showAlert: showAlert, timerRunning: timerRunning, countDownTimer: countDownTimer, isIpad: isIpad)
                self.poinStatus(isIpad: isIpad)
                self.knowledgeInformation(isIpad: isIpad)
            }
            .onAppear{
                timerRunning.wrappedValue = true
            }
        }.safeAreaInset(edge: .top) {
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color("redColor(TeWaRa)"), location: 0.5),
                    .init(color: Color("orangeColor(TeWaRa)"), location: 1.0),
                    
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .frame(height: isIpad ? self.screenSize.screenHeight/35 : self.screenSize.screenHeight/12)
            .edgesIgnoringSafeArea(.top)
            .padding(.bottom, isIpad ? -40 : -70)
        }
    }
    
    private func navigationBar(isIpad: Bool) -> some View {
        HStack(alignment: .center, content: {
            Spacer()
            Text("Bonus")
                .fontWeight(.semibold)
                .foregroundColor(Color.white)
                .font(isIpad ?  .title2 : .headline)
                .padding(.bottom, isIpad ? 15 : 0)
            Spacer()
        })
        .frame(height: isIpad ? self.screenSize.screenHeight/30 : self.screenSize.screenHeight/20)
        .background(
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: Color("redColor(TeWaRa)"), location: 0.5),
                    .init(color: Color("orangeColor(TeWaRa)"), location: 1.0),
                    
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .padding(.bottom, isIpad ? self.screenSize.screenHeight/40 : self.screenSize.screenHeight/40)
    }
    
    private func timer(countDownTimer: Binding<Int>, timerRunning: Binding<Bool>, showAlert: Binding<Bool>, isIpad: Bool) -> some View {
        ZStack(alignment: .center, content: {
            Image("backgroundTimer")
                .resizable()
                .frame(width: isIpad ? self.screenSize.screenWidth/1.1 : self.screenSize.screenWidth/1.15, height: isIpad ? self.screenSize.screenHeight/3 : self.screenSize.screenHeight/4.85)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(
                            LinearGradient(
                                gradient: Gradient(colors: [Color("redColor(TeWaRa)"), Color("orangeColor(TeWaRa)")]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: isIpad ? 8 : 4
                        )
                )
                .cornerRadius(10)
            Rectangle()
                .fill(Color.white.opacity(0.5))
                .frame(width: isIpad ? self.screenSize.screenWidth/1.125 : self.screenSize.screenWidth/1.175, height: isIpad ? self.screenSize.screenHeight/3.12 : self.screenSize.screenHeight/5.1)
                .cornerRadius(isIpad ? 0 : 6)
            Text("00:00:\(String(format: "%02d", countDownTimer.wrappedValue))")
                .onReceive(timer) { _ in
                    if countDownTimer.wrappedValue > 0 && timerRunning.wrappedValue {
                        countDownTimer.wrappedValue -= 1
                    }
                    else if countDownTimer.wrappedValue == 0 {
                        timerRunning.wrappedValue = false
                        showAlert.wrappedValue = true
                    }
                }
                .font(.system(size: isIpad ? 60 : 44))
                .fontWeight(.black)
        })
        .padding(.bottom, isIpad ? self.screenSize.screenHeight/80 : self.screenSize.screenHeight/55)
    }
    
    private func question(isIpad: Bool) -> some View {
        HStack(alignment: .center){
            Text("Budaya tersebut berasal dari provinsi...")
                .font(.system(size: isIpad ? 35 : 18))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
        }
        .padding(.bottom, isIpad ? self.screenSize.screenHeight/50 : self.screenSize.screenHeight/50)
    }
    
    private func answerOptions(islandController: IslandController, navToAnswerDescriptionView: Binding<Bool>, answer: Binding<String>, showAlert: Binding<Bool>, timerRunning: Binding<Bool>, countDownTimer: Binding<Int>, isIpad: Bool) -> some View {
        LazyVGrid(columns: columns, spacing: isIpad ? self.screenSize.screenWidth/50 : self.screenSize.screenWidth/35) {
            if ModelData.shared.currentGame == "TraditionalDance" {
                ForEach(islandController.getIsland().traditionalDance.provinceOptions,  id: \.self) { provinceOption in
                    Button(
                        action: {
                            answer.wrappedValue = provinceOption
                            showAlert.wrappedValue = true
                            islandController.checkTheAnswer(word: answer.wrappedValue, currentIsland: ModelData.shared.currentIsland, currentGame: ModelData.shared.currentGame, timer: countDownTimer.wrappedValue)
                            timerRunning.wrappedValue = false
                        },
                        label: {
                            Text(provinceOption)
                                .font(.system(size: isIpad ? 30 : 24, weight: .heavy))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .frame(width: isIpad ? self.screenSize.screenWidth/2.25 : self.screenSize.screenWidth/2.38, height: isIpad ? self.screenSize.screenHeight/10 : self.screenSize.screenHeight/10)
                        })
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("redColor(TeWaRa)"), Color("darkredColor(TeWaRa)")]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(10)
                    .alert(isPresented: showAlert, content: {
                        if countDownTimer.wrappedValue != 0 {
                            Alert(
                                title: Text("Selamat!!!"),
                                message:
                                    Text("Kamu mendapatkan \(islandController.getNewScore()) poin."),
                                dismissButton: .default(Text("Lihat penjelasan")) {
                                    navToAnswerDescriptionView.wrappedValue = true
                                }
                            )
                        }
                        else{
                            Alert(
                                title: Text("Waktu Habis!"),
                                message: Text("Kamu tidak menjawab dalam waktu yang ditentukan."),
                                dismissButton: .default(Text("Lihat penjelasan")) {
                                    navToAnswerDescriptionView.wrappedValue = true
                                }
                            )
                        }
                    })
                    .fullScreenCover(isPresented: navToAnswerDescriptionView, content: {
                        AnswerDescriptionView()
                    })
                }
            }
            else {
                ForEach(islandController.getIsland().traditionalLanguage.provinceOptions,  id: \.self) { provinceOption in
                    Button(
                        action: {
                            answer.wrappedValue = provinceOption
                            islandController.checkTheAnswer(word: answer.wrappedValue, currentIsland: ModelData.shared.currentIsland, currentGame: ModelData.shared.currentGame, timer: countDownTimer.wrappedValue)
                            showAlert.wrappedValue = true
                            timerRunning.wrappedValue = false
                        },
                        label: {
                            Text(provinceOption)
                                .font(.system(size: isIpad ? 30 : 24, weight: .heavy))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .frame(width: isIpad ? self.screenSize.screenWidth/2.4 : self.screenSize.screenWidth/2.38, height: isIpad ? self.screenSize.screenHeight/10 : self.screenSize.screenHeight/10)
                        })
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("redColor(TeWaRa)"), Color("darkredColor(TeWaRa)")]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(10)
                    .alert(isPresented: $showAlert, content: {
                        if countDownTimer.wrappedValue != 0 {
                            Alert(
                                title: Text("Selamat!!!"),
                                message:
                                    Text("Kamu mendapatkan \(islandController.getNewScore()) poin."),
                                dismissButton: .default(Text("Lihat penjelasan")) {
                                    navToAnswerDescriptionView.wrappedValue = true
                                }
                            )
                        }
                        else{
                            Alert(
                                title: Text("Waktu Habis!"),
                                message: Text("Kamu tidak menjawab dalam waktu yang ditentukan."),
                                dismissButton: .default(Text("Lihat penjelasan")) {
                                    navToAnswerDescriptionView.wrappedValue = true
                                }
                            )
                        }
                    })
                    .fullScreenCover(isPresented: navToAnswerDescriptionView, content: {
                        AnswerDescriptionView()
                    })
                }
            }
        }
        .padding(.horizontal, isIpad ? self.screenSize.screenWidth/25 : 24)
        .padding(.bottom, isIpad ? self.screenSize.screenHeight/50 : 15)
    }
    
    private func poinStatus(isIpad: Bool) -> some View {
        Rectangle()
            .fill(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color("redColor(TeWaRa)"), location: 0.5),
                        .init(color: Color("orangeColor(TeWaRa)"), location: 1.0),
                        
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: isIpad ? self.screenSize.screenWidth/1.1 : self.screenSize.screenWidth/1.15, height: isIpad ? self.screenSize.screenHeight/9 : self.screenSize.screenHeight/6)
            .cornerRadius(10)
            .overlay(
                HStack{
                    Spacer()
                    Text("Poin mu sekarang adalah \(ModelData.shared.currentUser.score)")
                        .font(.system(size: isIpad ? 25 : 20, weight: .regular))
                        .foregroundColor(.white)
                    Spacer()
                }
            )
            .padding(.bottom, isIpad ? self.screenSize.screenHeight/120 : self.screenSize.screenHeight/100)
    }
    
    private func knowledgeInformation(isIpad: Bool) -> some View {
        Rectangle()
            .fill(Color.gray)
            .frame(width: isIpad ? self.screenSize.screenWidth/1.1 : self.screenSize.screenWidth/1.15, height: isIpad ? self.screenSize.screenHeight/20 : self.screenSize.screenHeight/15)
            .cornerRadius(10)
            .overlay(
                HStack{
                    Spacer()
                    Text("Semakin cepat kamu menjawab, poin mu akan lebih besar lho...")
                        .font(.system(size: isIpad ? 20 : 16, weight: .medium))
                        .italic()
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            )
    }
}

#Preview {
    AdditionalQuestionView()
}
