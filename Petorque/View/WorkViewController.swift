//
//  WorkViewController.swift
//  Petorque
//
//  Created by Pedro Henrique Costa on 30/04/20.
//  Copyright © 2020 Petorqueiros. All rights reserved.
//

import UIKit

class WorkViewController: UIViewController {
    
    @IBOutlet var currentTaskLabel: UILabel!
    
    @IBOutlet var nextTask: UIButton!
    
    @IBOutlet var previousTask: UIButton!
    
    @IBOutlet var startTask: UIButton!
    
    @IBOutlet var finishTask: UIButton!
    
    var currentTask : Int = 0
    
    @IBAction func startCurrentTask(_ sender: UIButton) {
        nextTask.isHidden = true
        previousTask.isHidden = true
        startTask.isHidden = true
        finishTask.isHidden = false
    }
    
    @IBAction func finishCurrentTask(_ sender: UIButton) {
        let doingTasks = Database.shared.loadData(from: .doing)
        
        let finishedTask : [Task] = [doingTasks[currentTask]]
        
        Database.shared.saveData(from: finishedTask, to: .done)
        
        print("Done task: \(doingTasks[currentTask].title)")
        
        finishTask.isHidden = true
        nextTask.isHidden = false
        previousTask.isHidden = false
        startTask.isHidden = false
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

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        currentTask = 0
        let doingTasks = Database.shared.loadData(from: .doing)
        currentTaskLabel.text = doingTasks[currentTask].title
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
