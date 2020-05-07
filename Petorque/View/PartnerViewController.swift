//
//  PartnerViewController.swift
//  Petorque
//
//  Created by Pedro Henrique Costa on 30/04/20.
//  Copyright © 2020 Petorqueiros. All rights reserved.
//

import UIKit

class PartnerViewController: UIViewController {
    
    
    @IBOutlet var partnerView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        partnerView.image = UIImage(named: "takeyourtime-char1.png")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if checkWorkHours() >= 600 {
            partnerView.image = UIImage(named: "takeyourtime-char4.png")
        } else {
            partnerView.image = UIImage(named: "takeyourtime-char1.png")
        }
    }
    
    func checkWorkHours () -> Int {
        let doingToday : [Task] = Database.shared.loadTodayTasks(from: .doing)
        let doneToday : [Task] = Database.shared.loadTodayTasks(from: .done)
        var totalTime = 0
        
        for task in doingToday {
            totalTime += task.cycleDuration * task.numberOfCycles
        }
        
        for task in doneToday {
            totalTime += task.cycleDuration * task.numberOfCycles
        }
        
        return totalTime
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
