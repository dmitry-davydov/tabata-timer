//
//  Settings.swift
//  TabataPlus
//
//  Created by Дима Давыдов on 03.11.2020.
//

import SwiftUI

struct SettingsModel {
    var cycles: Int = 0
    var rounds: Float = 0
}

struct Settings: View {
    
    @State var settingsModel = SettingsModel()
    
    var body: some View {
        
        NavigationView {
            VStack {
                
                
                NavigationLink(
                    destination: Activities(),
                    label: {
                        HStack(spacing: 5) {
                            
                            Image.init(systemName: "timer")
                                .foregroundColor(.black)
                                .opacity(0.5)
                            
                            Text("Training")
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                                .font(.body)
                                .opacity(0.5)
                        }
                    })
                    .padding([.top], -10)
                
                Spacer()
                
                Form {
                    Stepper("Cycles: \(settingsModel.cycles)", onIncrement: {
                        settingsModel.cycles += 1
                    }, onDecrement: {
                        settingsModel.cycles -= 1
                    })
                    
                    
                    VStack(alignment: .leading) {
                        Text("Rounds: \(Int(settingsModel.rounds))")
                        Slider(value: $settingsModel.rounds, in: 1...20, step: 1)
                    }
                    
                    

                 
            
                    
                }
                
                
            }
            .background(Color.blue)
        }
        .frame(minWidth: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealWidth: .infinity, maxWidth: .infinity, minHeight: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/, idealHeight: .infinity, maxHeight: .infinity, alignment: .center)
        
        .navigationBarTitle("")
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
