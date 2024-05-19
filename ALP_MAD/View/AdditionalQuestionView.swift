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
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        self.setUpAdditionalQuestionView(islandController: islandController, answer: $answer, showAlert: $showAlert, navToAnswerDescriptionView: $navToAnswerDescriptionView, countDownTimer: $countDownTimer, timerRunning: $timerRunning)
    }
    
    private func setUpAdditionalQuestionView(islandController: IslandController, answer: Binding<String>, showAlert: Binding<Bool>, navToAnswerDescriptionView: Binding<Bool>, countDownTimer: Binding<Int>, timerRunning: Binding<Bool>) -> some View {
        ScrollView {
            VStack(alignment: .center) {
                self.navigationBar()
                self.timer(countDownTimer: countDownTimer, timerRunning: timerRunning, showAlert: showAlert)
                self.question()
                self.answerOptions(islandController: islandController, navToAnswerDescriptionView: navToAnswerDescriptionView, answer: answer, showAlert: showAlert, timerRunning: timerRunning, countDownTimer: countDownTimer)
                self.poinStatus()
                self.knowledgeInformation()
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
            .frame(height: 70)
            .edgesIgnoringSafeArea(.top)
            .padding(.bottom, -70)
        }
    }
    
    private func navigationBar() -> some View {
        HStack(alignment: .center, content: {
            Spacer()
            Text("Bonus")
                .fontWeight(.semibold)
                .foregroundColor(Color.white)
                .font(.headline)
            Spacer()
        })
        .frame(height: 40)
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
        .padding(.bottom, 20)
    }
    
    private func timer(countDownTimer: Binding<Int>, timerRunning: Binding<Bool>, showAlert: Binding<Bool>) -> some View {
        ZStack(alignment: .center, content: {
            Image("backgroundTimer")
                .resizable()
                .frame(width:342, height: 175)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(
                            LinearGradient(
                                gradient: Gradient(colors: [Color("redColor(TeWaRa)"), Color("orangeColor(TeWaRa)")]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 4
                        )
                )
                .cornerRadius(10)
            Rectangle()
                .fill(Color.white.opacity(0.5))
                .frame(width: 334, height: 168)
                .cornerRadius(6)
            
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
                .font(.system(size: 44, weight: .black))
        })
        .padding(.bottom, 10)
    }
    
    private func question() -> some View {
        HStack(alignment: .center){
            Text("Budaya tersebut berasal dari provinsi...")
                .font(.system(size: 18, weight: .bold))
                .multilineTextAlignment(.center)
        }
        .padding(.bottom, 17)
    }
    
    private func answerOptions(islandController: IslandController, navToAnswerDescriptionView: Binding<Bool>, answer: Binding<String>, showAlert: Binding<Bool>, timerRunning: Binding<Bool>, countDownTimer: Binding<Int>) -> some View {
        LazyVGrid(columns: columns, spacing: 10) {
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
                                .font(.system(size: 24, weight: .heavy))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .frame(width: 164, height: 87)
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
                                .font(.system(size: 24, weight: .heavy))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .frame(width: 164, height: 87)
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
        .padding(.horizontal, 24)
        .padding(.bottom, 15)
    }
    
    private func poinStatus() -> some View {
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
            .frame(width: 340, height: 140)
            .cornerRadius(10)
            .overlay(
                HStack{
                    Spacer()
                    Text("Poin mu sekarang adalah \(ModelData.shared.currentUser.score)")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(.white)
                    Spacer()
                }
            )
            .padding(.bottom, 5)
    }
    
    private func knowledgeInformation() -> some View {
        Rectangle()
            .fill(Color.gray)
            .frame(width: 340, height: 60)
            .cornerRadius(10)
            .overlay(
                HStack{
                    Spacer()
                    Text("Semakin cepat kamu menjawab, poin mu akan lebih besar lho...")
                        .font(.system(size: 16, weight: .medium))
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
