//
//  InProgress.swift
//  TabataPlus
//
//  Created by Дима Давыдов on 31.10.2020.
//

import SwiftUI
import Combine

struct TimerView: View {
    
    @ObservedObject var activity = ActivityManager(training: TrainingConfiguration(prepareTimeout: 3, totalRounds: 2, workTime: 2, restTime: 2, cicles: 7))
    
    
    var bgColor: Color {
        return activity.inProgress ? Color.black : Color.init("bg")
    }
    
    var buttonWidthHeight: CGFloat {
        return activity.inProgress ? 250 : 200
    }
    
    var endButtonOpacity: Double {
        return !activity.inProgress && activity.currentCicle > 0 ? 1 : 0
    }
    
    @State var buttonPressed: Bool = false
    
    @State var animateView: Bool = false
    
    
    var body: some View {
        
        NavigationView {
            VStack {
                NavigationLink(
                    destination: Activities(),
                    label: {
                        HStack(spacing: 5) {
                            
                            Image.init(systemName: "waveform.path.ecg")
                                .foregroundColor(.white)
                                .opacity(0.5)
                            
                            Text("Activities")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .font(.body)
                                .opacity(0.5)
                        }
                    })
                    .padding([.top], activity.inProgress ? -100 : 10)
                    .animation(.easeIn(duration: 0.5), value: activity.inProgress)

                Spacer()
                
//                Text("Round \(activity.currentRoundNumber) of \(activity.trainingConfiguration.totalRounds)")
//                    .fontWeight(.bold)
//                    .foregroundColor(.white)
//                    .font(.title)
                
                
                Text("Round \(activity.currentCicle)")
                    .foregroundColor(.white)
                    .font(.title)
                    .fontWeight(.bold)
                    .opacity(activity.currentCicle > 0 && !activity.inProgress ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5), value: activity.inProgress)
                    
                
                Button(action: {
                    if activity.inProgress { return }
                    activity.inProgress.toggle()
                    animateView.toggle()
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                        self.activity.start()
                    })
                    
                }, label: {
                    ProgressIndicator(timer: activity.countdown, maxTimerValue: activity.countdownDuration, state: activity.state, progress: activity.progress)
                    
                })
                .frame(width: buttonWidthHeight, height: buttonWidthHeight, alignment: .center)
                .animation(.easeIn(duration: 0.5), value: activity.inProgress)
                
                
                Button(action: {}, label: {
                    
                    Text("End")
                        .foregroundColor(.white)
                        .opacity(0.5)
                    
                })
                .padding([.top], 20)
                .opacity(activity.currentCicle > 0 && !activity.inProgress ? 1 : 0)
                .animation(.easeIn(duration: 0.5), value: activity.inProgress)
                
                Spacer()
                
                NavigationLink(
                    destination: Settings(),
                    label: {
                        HStack(spacing: 5) {
                            
                            Image.init(systemName: "gearshape")
                                .foregroundColor(.white)
                                .opacity(0.5)
                            
                            Text("Settings")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .font(.body)
                                .opacity(0.5)
                        }
                    })
                    .padding([.bottom], activity.inProgress ? -100 : 20)
                    .animation(.easeIn(duration: 0.5), value: activity.inProgress)
            }
            .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: .infinity, maxWidth: .infinity, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: .infinity, maxHeight: .infinity, alignment: .center)
            .background(
                bgColor
                    .animation(.easeIn(duration: 0.5), value: activity.inProgress)
                    .ignoresSafeArea()
            )
            
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}


struct TimerView_Previews: PreviewProvider {
    
    static var previews: some View {
        TimerView()
    }
}
