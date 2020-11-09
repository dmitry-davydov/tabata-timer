//
//  Activity.swift
//  TabataPlus
//
//  Created by Дима Давыдов on 09.11.2020.
//

import SwiftUI

class Activity {
    private var configuration: TrainingConfiguration
    private var startAt: Date?
    private var endAt: Date?
    
    var currentCycle: Cycle?
    
    var cycles: [Cycle] = []
    
    init(_ conf: TrainingConfiguration) {
        configuration = conf
    }
    
    func start(){
        startAt = Date()
    }
    
    func end() {
        endAt = Date()
    }
    
    func getConfiguration() -> TrainingConfiguration {
        return self.configuration
    }
}
