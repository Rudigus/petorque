//
//  TimerDelegate.swift
//  Petorque
//
//  Created by Pedro Henrique Costa on 05/05/20.
//  Copyright © 2020 Petorqueiros. All rights reserved.
//

import Foundation

protocol TimerDelegate {
    
    func giveTimerLabel(_ timeText : String)
    
    func finishedTask()
    
    func changeCharacterImage(_ working : Bool)
    
    func changePausedButton(_ paused : Bool)
    
    func rotateProgressBar()
    
}
