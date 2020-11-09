//
//  Activity.swift
//  TabataPlus
//
//  Created by Дима Давыдов on 03.11.2020.
//

import SwiftUI

class ActivityManager: ObservableObject {
    
    enum State {
        case prepare, work, rest, none
    }
    
    @Published var inProgress: Bool = false
    @Published var currentRoundNumber: Int = 0
    @Published var countdown: Float = 0
    @Published var state: State = .none
    @Published var countdownDuration: Float = 0
    
    private var activity: Activity
    
    var countdownStartedAt: Date?
    var cicleEndAt: Date?
    
    var isStarted: Bool = false
    var isPrepared: Bool = false
    var timer: Timer?
    var currentCicle: Int = 0
    var currentRound: Round?
    var roundsHostory: [Round] = []
    
    init(training: TrainingConfiguration) {
        self.activity = Activity(training)
    }
    
    private func setCoundown(_ value: Int) {
        countdownDuration = Float(value)
        countdown = Float(value)
        countdownStartedAt = Date()
    }
    
    var progress: Float {
        if countdown == 0 {
            return 0
        }
        return (countdownDuration - countdown + 1) / countdownDuration
    }
    
    var isCiclesCompleted: Bool {
        return currentCicle == trainingConfiguration.cicles
    }
    
    //MARK: - Prepare round
    private func prepare() {
        state = .prepare
        setCoundown(trainingConfiguration.prepareTimeout)

        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            
            if self.countdown > 0 {
                self.countdown -= 1
                return
            }
            
            self.countdown = 0
            self.timer?.invalidate()
            self.isPrepared = true
            self.currentCicle += 1
            self.startRound()
        }
    }
    
    private func startRound() {
        
        print("startRound \(currentRoundNumber)")
        
        currentRoundNumber += 1
        state = .work
        setCoundown(trainingConfiguration.workTime)
        currentRound = Round(startTime: Date(), endTime: nil)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            
            if self.countdown > 0 {
                self.countdown -= 1
                return
            }
            
            self.countdown = 0
            self.timer?.invalidate()
            self.currentRound?.endTime = Date()
            self.startRest()
        }
    }
    
    private func startRest() {
        
        roundsHostory.append(currentRound!)
        currentRound = nil
        
        state = .rest
        setCoundown(trainingConfiguration.restTime)
        
        if currentRoundNumber == trainingConfiguration.totalRounds {
            didEndCicle()
            return
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (_) in
            
            if self.countdown > 0 {
                self.countdown -= 1
                return
            }
            
            self.countdown = 0
            self.timer?.invalidate()
            self.startRound()
        }
        
    }
    
    func didEndCicle() {
        print("didEndCicle")
        currentRoundNumber = 0
        inProgress.toggle()
        cicleEndAt = Date()
        state = .none
        countdown = 0
    }
    
    func start() {
        prepare()
    }
}
