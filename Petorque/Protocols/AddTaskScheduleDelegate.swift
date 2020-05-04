//
//  AddTaskScheduleDelegate.swift
//  Petorque
//
//  Created by Tales Conrado on 30/04/20.
//  Copyright © 2020 Petorqueiros. All rights reserved.
//

import Foundation

protocol AddTaskScheduleDelegate: class {
    func saveTask(title: String, cycleDuration: Int, numberOfCycles: Int)
}
