//
//  WorkViewController.swift
//  Petorque
//
//  Created by Pedro Henrique Costa on 30/04/20.
//  Copyright © 2020 Petorqueiros. All rights reserved.
//

import UIKit

class WorkViewController: UIViewController, TimerDelegate {
    
    @IBOutlet var currentTaskLabel: UILabel!
    
    @IBOutlet var nextTask: UIButton!
    
    @IBOutlet var previousTask: UIButton!
    
    @IBOutlet var startTask: UIButton!
    
    @IBOutlet var finishTask: UIButton!
    
    @IBOutlet var timecountLabel: UILabel!
    
    @IBOutlet var timecountPlay: UIButton!
    
    @IBAction func timecountToggle(_ sender: UIButton) {
        taskTimer?.pauseTimer()
    }
    
    var taskTimer : TimerModel?
    
    var currentTask : Int = 0
    
    @IBAction func startCurrentTask(_ sender: UIButton) {
        let doingTasks = Database.shared.loadData(from: .doing)
        
        nextTask.isHidden = true
        previousTask.isHidden = true
        startTask.isHidden = true
        finishTask.isHidden = false
        timecountLabel.isHidden = false
        timecountPlay.isHidden = false
        
        taskTimer = TimerModel(
            count: ("Prog", "Prog"),
            cycles: doingTasks[currentTask].numberOfCycles,
            minutes: 2//doingTasks[currentTask].cycleDuration / 10
        )
        taskTimer?.delegate = self
        taskTimer?.startTimer(
            minutes: 2//doingTasks[currentTask].cycleDuration / 10
        )
    }
    
    @IBAction func finishCurrentTask(_ sender: UIButton) {
        finishedTask()
    }
    
    @IBAction func changeTask(_ sender: UIButton) {
        let senderName = sender.titleLabel?.text ?? "None"
   
        let doingTasks = Database.shared.loadData(from: .doing)

        if senderName == "PLOM" {
           if currentTask == doingTasks.count-1 {
               currentTask = 0
           } else {
               currentTask += 1
           }
        }

        if senderName == "PLIM" {
           if currentTask == 0 {
               currentTask = doingTasks.count-1
           } else {
               currentTask -= 1
           }
        }

        currentTaskLabel.text = doingTasks[currentTask].title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        currentTask = 0
        let doingTasks = Database.shared.loadData(from: .doing)
        currentTaskLabel.text = doingTasks[currentTask].title
    }
    
    func giveTimerLabel(_ timeText : String) {
        timecountLabel.text = timeText
    }
    
    func finishedTask() {
        taskTimer?.stopTimer()
        taskTimer = nil
        
        let doingTasks = Database.shared.loadData(from: .doing)
        
        let finishedTask : [Task] = [doingTasks[currentTask]]
        
        Database.shared.saveData(from: finishedTask, to: .done)
        
        timecountLabel.isHidden = true
        timecountPlay.isHidden = true
        finishTask.isHidden = true
        nextTask.isHidden = false
        previousTask.isHidden = false
        startTask.isHidden = false
    }

}
