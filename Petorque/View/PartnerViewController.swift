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

    func getDate(of day: TodayOrTomorrow) -> Date {
        let now = Calendar.current.dateComponents(in: .current, from: Date())
        
        switch day {
        case .today:
            let today = DateComponents(year: now.year, month: now.month, day: now.day)
            let dateToday = Calendar.current.date(from: today)!
            
            return dateToday
            
        case .tomorrow:
            let tomorrow = DateComponents(year: now.year, month: now.month, day: now.day! + 1)
            let dateTomorrow = Calendar.current.date(from: tomorrow)!
            
            return dateTomorrow
        }
    }
    
    func loadTodayTasks() -> [Task] {
        let todayTasks = Database.shared.loadData(from: .done).filter({ task in
            let todayDate = getDate(of: .today)
            if task.date == todayDate {
                return true
            }
            return false
        })

        return todayTasks
    }
    
    func checkWorkHours () -> Int {
        let todayTasks : [Task] = loadTodayTasks()
        var totalTime = 0
        
        for task in todayTasks {
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
