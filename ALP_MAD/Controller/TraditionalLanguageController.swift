//
//  TraditionalLanguageController.swift
//  ALP_MAD
//
//  Created by MacBook Pro on 12/05/24.
//

import Foundation
import UIKit

class TraditionalLanguageController : ObservableObject {
    
    @Published private var traditionalLanguage : TraditionalLanguage
//    @Published private var user : User
    
    init(traditionalLanguage: TraditionalLanguage) {
        self.traditionalLanguage = traditionalLanguage
//        self.user = user
    }
    
//    func getUser() -> User {
//        return self.user
//    }
//    
    func wrongAnswer() {
        
    }
    
    func guessWord(word : String, remainingTime: Int) {
        if (traditionalLanguage.answer == word.uppercased()) {
            correctAnswer(remainingTime: remainingTime)
        }
        else {
            wrongAnswer()
        }
    }
    
    func correctAnswer(remainingTime: Int) {
        
    }
    
    func accumulatePoint() {
        
    }
    
    func getTraditionalLanguage() -> TraditionalLanguage {
        return self.traditionalLanguage
    }
    
    func navigateToAdditionalQuestionView() {
        
    }
}
