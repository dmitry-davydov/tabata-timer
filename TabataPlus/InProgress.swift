//
//  InProgress.swift
//  TabataPlus
//
//  Created by Дима Давыдов on 31.10.2020.
//

import SwiftUI

struct TrainingConfiguration {
    var prepareTimeout: Int
    var totalRounds: Int
    var workTime: Int
    var restTime: Int
}

struct Round {
    var startTime: Date
    var endTime: Date?
}

class Activity: ObservableObject {
    
    enum State {
        case prepare, work, rest
    }
    
    @Published var inProgress: Bool = false
    @Published var currentRoundNumber: Int = 0
    @Published var countdown: Float = 0
    @Published var state: State = .work
    @Published var countdownDuration: Float = 0
    
    var isStarted: Bool = false
    var countdownStartedAt: Date?
    var isPrepared: Bool = false
    var timer: Timer?
    var currentRound: Round?
    var roundsHostory: [Round] = []
    
    let trainingConfiguration: TrainingConfiguration
    
    init(training: TrainingConfiguration) {
        self.trainingConfiguration = training
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
        return (countdownDuration - countdown) / countdownDuration
    }
    
    //MARK: - Prepare round
    private func prepare() {
        state = .prepare
        setCoundown(trainingConfiguration.prepareTimeout)
        
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (t) in
            
            let ti = Float(t.timeInterval)
            
            if self.countdown - ti > 0 {
                self.countdown -= ti
                return
            }
            
            self.countdown = 0
            self.timer?.invalidate()
            self.isPrepared = true
            self.start()
        }
    }
    
    private func startRound() {
        
        print("startRound \(currentRoundNumber)")
        if currentRoundNumber >= trainingConfiguration.totalRounds {
            // остановить таймер
            // начать считать сколько времени прошло с момента окончания раунда
            
            return
        }
        
        state = .work
        setCoundown(trainingConfiguration.workTime)
        currentRoundNumber += 1
        currentRound = Round(startTime: Date(), endTime: nil)
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { (t) in
            
            let ti = Float(t.timeInterval)
            
            if self.countdown - ti > 0 {
                self.countdown -= ti
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
            state = .work
            return
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { (t) in
            
            let ti = Float(t.timeInterval)
            
            if self.countdown - ti > 0 {
                self.countdown -= ti
                return
            }
            
            self.countdown = 0
            self.timer?.invalidate()
            
            self.start()
        }
        
    }
    
    func start() {
        
        if !isPrepared {
            prepare()
            
            return
        }
        
        startRound()
    }
}

struct InProgress: View {
    
    @ObservedObject var activity = Activity(training: TrainingConfiguration(prepareTimeout: 5, totalRounds: 2, workTime: 20, restTime: 10))
    
    
    var body: some View {
        
        ZStack {
            Color
                .init("bg")
                .ignoresSafeArea();
            
            
            VStack {
                
                Text("Round \(activity.currentRoundNumber) of \(activity.trainingConfiguration.totalRounds)")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .font(.title)
                    .padding([.bottom], 20)
                
                
                Button(action: {
                    activity.start()
                }, label: {
                    ProgressBar(timer: activity.countdown, maxTimerValue: activity.countdownDuration, state: activity.state, progress: activity.progress)
                        
                })
                .frame(width: 200, height: 200, alignment: .center)

                Spacer(minLength: 1)
                    .frame(height: 200)
                
            }
        }
    }
}

struct ProgressBar: View {
    
    var timer: Float = 0
    var maxTimerValue: Float = 0
    
    var state: Activity.State
    var progress: Float
    
    var showMilliseconds: Bool {
        switch state {
        case .prepare, .rest:
            return false
        default:
            return true
        }
    }
    
    var imageName: String {
        switch state {
        case .prepare:
            return "prepare"
        case .rest:
            return "rest"
        case .work:
            return "work"
        }
    }
    
    var seconds: String {
        let value = Int(floor(timer))
        if !showMilliseconds {
            return String(format: "%d", value)
        }
        return String(format: "%02d", value)
    }
    
    var milliseconds: String {
        return String(format: "%02d", Int(timer.truncatingRemainder(dividingBy: 1) * 100))
    }
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color.init("panel"))
            
            Circle()
                .strokeBorder(lineWidth: 5.0)
                .opacity(0.3)
                .foregroundColor(Color.init(imageName))
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 5.0, lineCap: .round, lineJoin: .round))
                
                .foregroundColor(Color.init(imageName))
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
                .padding(2)
            
            if showMilliseconds {
                HStack(alignment: .center, spacing: 0.0, content: {
                    Text(seconds)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 60, alignment: .trailing)
                        .padding(0)
                        

                    Text(":")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text(milliseconds)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.leading)
                        .frame(width: 60, alignment: .leading)
                        .padding([.trailing], 0)
                        
                })
            } else {
                Text(seconds)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .clipped()
                    .padding([.leading, .trailing], 20)
            }
        }
    }
}

struct InProgress_Previews: PreviewProvider {
    static var previews: some View {
        InProgress()
    }
}
