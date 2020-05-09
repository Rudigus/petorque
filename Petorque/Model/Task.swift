//
//  Task.swift
//  Petorque
//
//  Created by Eduardo Oliveira on 23/04/20.
//  Copyright © 2020 Petorqueiros. All rights reserved.
//

import Foundation

struct Task: Codable, Equatable {
    var title: String
    var cycleDuration: Int
    var numberOfCycles: Int
    var date: Date
}
