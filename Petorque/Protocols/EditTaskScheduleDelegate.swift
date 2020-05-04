//
//  EditTaskScheduleDelegate.swift
//  Petorque
//
//  Created by Eduardo Oliveira on 04/05/20.
//  Copyright © 2020 Petorqueiros. All rights reserved.
//

import Foundation

protocol EditTaskScheduleDelegate: class {
    func updateTask(title: String, cycleDuration: Int, numberOfCycles: Int, location: Int)
}
