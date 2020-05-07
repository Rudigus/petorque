//
//  TableViewController.swift
//  Petorque
//
//  Created by Pedro Henrique Costa on 28/04/20.
//  Copyright © 2020 Petorqueiros. All rights reserved.
//

import UIKit

class FeedbackTableController: UITableViewController {
    
    @IBOutlet var feedbackTableView: UITableView! {
        didSet {
            feedbackTableView.tableFooterView = UIView()
        }
    }
    
    var tempTasks : [Task]?
    
    var tempFeedbackContent : [String] = []
    
    var tempFeedbackSubtitle : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tempTasks = loadTodayTasks()
        if let checkTasks = tempTasks {
            for num in 0..<checkTasks.count {
                tempFeedbackContent.append(checkTasks[num].title)
                tempFeedbackSubtitle.append("\(checkTasks[num].numberOfCycles) ciclos - \(checkTasks[num].cycleDuration) minutos")
            }
            self.navigationItem.setHidesBackButton(true, animated: false)
        } else {
            fatalError("Tasks done not properly loaded on Feedback screen")
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadTodayTasks().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedbackTableView.dequeueReusableCell(withIdentifier: "feedbackTableCell", for: indexPath)
        cell.backgroundColor = UIColor.white
        cell.textLabel?.text = tempFeedbackContent[indexPath.row]
        cell.detailTextLabel?.text = tempFeedbackSubtitle[indexPath.row]
        return cell
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.popToRootViewController(animated: false)
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

}
