//
//  ProgressIndicator.swift
//  TabataPlus
//
//  Created by Дима Давыдов on 03.11.2020.
//

import SwiftUI

struct ProgressIndicator: View {
    
    var timer: Float = 0
    var maxTimerValue: Float = 0
    
    var state: ActivityManager.State
    var progress: Float

    var showMilliseconds: Bool {
        switch state {
        case .prepare, .rest, .none:
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
        case .none:
            return "work"
        }
    }
    
    var seconds: String {
        
        if state == .none {
            return String("GO!")
        }
        
        let value = Int(floor(timer))
        return String(format: "%d", value)
    }
    
    var body: some View {
        ZStack {
            
            
            Circle()
                .foregroundColor(Color.init("panel"))
            
            
            
            Circle()
                .strokeBorder(lineWidth: 15.0)
                .opacity(0.3)
                .foregroundColor(Color.init(imageName))
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 15.0, lineCap: .round, lineJoin: .round))
                
                .foregroundColor(Color.init(imageName))
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
                .padding(7)
            
            
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

struct ProgressIndicator_Previews: PreviewProvider {
    
    static var previews: some View {
        ProgressIndicator(state: ActivityManager.State.prepare, progress: 0.3)
    }
}
