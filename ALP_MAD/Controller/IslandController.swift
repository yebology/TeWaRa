//
//  IslandController.swift
//  ALP_MAD
//
//  Created by MacBook Pro on 12/05/24.
//

import Foundation
import UIKit

class IslandController : ObservableObject {
    
    @Published private var island : Island
    
    init(island: Island) {
        self.island = island
    }
    
    func getIsland() -> Island {
        return self.island
    }
    
    func navigateToPlaySumateraGame() {

    }
    
    func navigateToPlayKalimantanGame() {
        
    }
    
    func navigateToPlayPapuaGame() {
        
    }
    
    func navigateToPlaySulawesiGame() {
        
    }
    
    func navigateToPlayBaliGame() {
        
    }
    
    func navigateToPlayJavaGame() {
        
    }
    
    func checkTheAnswer(word: String, currentGame: String) {
//        if currentGame == "Traditional Dance" {
//            if word == self.island.traditionalDance.provinceOrigin {
//                
//            }
//        }
//        else{
//            
//        }
    }
}
