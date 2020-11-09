//
//  Cycle.swift
//  TabataPlus
//
//  Created by Дима Давыдов on 09.11.2020.
//

import SwiftUI

class Cycle {
    var rounds: [Round] = []
    var startedAt: Date?
    var endedAt: Date?
    var restTimeInSec: Int?
    
    func startSycle() {
        startedAt = Date()
    }
    
    func endCycle() {
        endedAt = Date()
    }
    
    func setRestTime(_ sec: Int) {
        restTimeInSec = sec
    }
    
    func addRound(_ round: Round) {
        rounds.append(round)
    }
}
