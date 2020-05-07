//
//  Timecounter.swift
//  Petorque
//
//  Created by Pedro Henrique Costa on 04/05/20.
//  Copyright © 2020 Petorqueiros. All rights reserved.
//

import Foundation

class TimerModel {
    
    var timer : Timer?
    var elapsedSeconds : Int
    
    var counterDirection : (work: String?, break: String?)
    var remainingCycles : Int
    var minuteLimit : Int
    
    var paused : Bool
    var working : Bool
    var delegate : TimerDelegate?
    
    init(count type : (work: String?, break: String?), cycles cyc : Int, minutes min : Int) {
        self.elapsedSeconds = 0
        
        self.counterDirection = type
        self.remainingCycles = cyc
        self.minuteLimit = min
        
        self.paused = false
        self.working = true
    }
    
    func startTimer(minutes min : Int) {
        delegate?.changeCharacterImage(working)
        
        //var rotateIncrement : Float = .pi/180
        
        var timeDirection = ""
        if working {
            timeDirection = self.counterDirection.work!
        } else {
            timeDirection = self.counterDirection.break!
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            let minutes = self.elapsedSeconds / 60
            let seconds = self.elapsedSeconds - (60 * minutes)
            var timeText : String = ""
            
            self.elapsedSeconds += 1
            
            if timeDirection == "Progressiva" {
                timeText = String(format: "%.2d:%.2d", minutes, seconds)
                if minutes >= min {
                    self.stopTimer(reset: true)
                }
            } else {
                if seconds == 0 {
                    timeText = String(format: "%.2d:%.2d",
                                      (60 * min - self.elapsedSeconds) / 60,
                                      seconds
                    )
                } else {
                    timeText = String(format: "%.2d:%.2d",
                                      (60 * min - self.elapsedSeconds) / 60,
                                      (60 - seconds)
                    )
                }
                
                if self.elapsedSeconds >= 60 * min {
                    self.stopTimer(reset: true)
                }
            }
            
            let timeProgress : Double = Double(self.elapsedSeconds) / Double(min * 60)
            let barFrame : Int = Int(floor(11 * timeProgress))
            self.delegate?.updateProgressBar(frame: barFrame, direction: timeDirection)
            self.delegate?.giveTimerLabel(timeText)
        }
        timer?.fire()
    }
    
    func pauseTimer() {
        if paused {
            if working {
                startTimer(minutes: minuteLimit)
            } else {
                startTimer(minutes: 5)
            }
        } else {
            stopTimer()
        }
        paused.toggle()
        delegate?.changePausedButton(paused)
    }
    
    func stopTimer(reset res : Bool = false) {
        timer?.invalidate()
        timer = nil
        if res {
            elapsedSeconds = 0
            
            if working {
                remainingCycles -= 1
                if remainingCycles > 0 {
                    working.toggle()
                    startTimer(minutes: 5)
                } else {
                    self.delegate?.finishedTask()
                }
            } else {
                working.toggle()
                startTimer(minutes: minuteLimit)
            }
        }
    }
}
