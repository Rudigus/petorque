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
        tempTasks = Database.shared.loadTodayTasks(from: .done)
        if let checkTasks = tempTasks {
            for num in 0..<checkTasks.count {
                tempFeedbackContent.append(checkTasks[num].title)
                tempFeedbackSubtitle.append("\(checkTasks[num].numberOfCycles) ciclos - \(checkTasks[num].cycleDuration) minutos")
            }
            self.navigationItem.setHidesBackButton(true, animated: false)
        } else {
            fatalError("Tasks done not properly loaded on Feedback screen")
        }
        
        alertWorkHours()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Database.shared.loadTodayTasks(from: .done).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = feedbackTableView.dequeueReusableCell(withIdentifier: "feedbackTableCell", for: indexPath)
        cell.backgroundColor = #colorLiteral(red: 0.9926550984, green: 0.9776508212, blue: 0.9066037536, alpha: 1)
        cell.textLabel?.text = tempFeedbackContent[indexPath.row]
        cell.detailTextLabel?.text = tempFeedbackSubtitle[indexPath.row]
        return cell
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    func checkWorkHours () -> Int {
        let todayTasks : [Task] = Database.shared.loadTodayTasks(from: .done)
        var totalTime = 0
        
        for task in todayTasks {
            totalTime += task.cycleDuration * task.numberOfCycles
        }
        
        return totalTime
    }
    
    func alertWorkHours() {
        if checkWorkHours() >= 600 {
            let alert = UIAlertController(title: "Que cansaço...", message: "Tenha cuidado com o quanto você trabalha! Isso faz mal para você e seu parceiro.", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Ver Parceiro", style: .default, handler: { action in
                self.tabBarController?.selectedIndex = 0
            }))

            self.present(alert, animated: true)
        }
    }

}
