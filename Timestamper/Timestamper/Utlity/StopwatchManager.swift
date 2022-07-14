//
//  StopwatchManager.swift
//  Timestamper
//
//  Created by Stu Greenham on 30/01/2022.
//

import SwiftUI


enum stopWatchMode {
    case running
    case stopped
    case paused
}

class StopWatchManager: ObservableObject {
    
    @Published var mode: stopWatchMode = .stopped
    @Published var secondsElapsed = 0
    
    var timer = Timer()
    
    func start() {
        mode = .running 
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            self.secondsElapsed = self.secondsElapsed + 1
        }
    }
    
    func pause() {
        timer.invalidate()
        mode = .paused
    }
    
    func stop() {
        timer.invalidate()
        secondsElapsed = 0
        mode = .stopped
    }
    
}

func secondsToMinutesAndSeconds(seconds: Int) -> String {
    let hours = "\(seconds / 3600)"
    let minutes = "\((seconds % 3600) / 60)"
    let seconds = "\((seconds % 3600) % 60)"
    let hourStamp = hours.count > 1 ? hours : "0" + hours
    let minuteStamp = minutes.count > 1 ? minutes : "0" + minutes
    let secondStamp = seconds.count > 1 ? seconds : "0" + seconds
    
    return "\(hourStamp):\(minuteStamp):\(secondStamp)"
}
