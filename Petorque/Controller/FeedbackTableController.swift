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
    
    let tempTasks = Database.shared.loadData(from: .doing)
    
    var tempFeedbackContent : [String] = []
    
    var tempFeedbackSubtitle : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for num in 0..<tempTasks.count {
            tempFeedbackContent.append(tempTasks[num].title)
            tempFeedbackSubtitle.append("\(tempTasks[num].numberOfCycles) ciclos - \(tempTasks[num].cycleDuration) minutos")
        }
        self.navigationItem.setHidesBackButton(true, animated: false)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempTasks.count
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

}
