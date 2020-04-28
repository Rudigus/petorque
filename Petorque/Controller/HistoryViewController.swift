//
//  HistoryViewController.swift
//  Petorque
//
//  Created by Eduardo Oliveira on 22/04/20.
//  Copyright © 2020 Petorqueiros. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.tableFooterView = UIView()
        }
    }

    var historyTasks: [Task] = []
    
    func createArray() -> [Task] {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let task1 = Task(title: "Estudar Design", cycleDuration: 25, numberOfCycles: 3, date: Date(timeIntervalSinceReferenceDate: 410220000))
        let task2 = Task(title: "Fazer protótipo de alta fidelidade", cycleDuration: 25, numberOfCycles: 4, date: Date(timeIntervalSinceReferenceDate: 410220000))
        let task3 = Task(title: "Plantar babosa", cycleDuration: 20, numberOfCycles: 2, date: Date(timeIntervalSinceReferenceDate: 410220000))
        return [task1, task2, task3]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        historyTasks = createArray()
        setupTableView()
    }
    
    func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print("you tapped me!")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyTableViewCell", for: indexPath)
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "pt_BR")
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMMdyyyy")
        cell.textLabel?.text = historyTasks[indexPath.row].title
        cell.detailTextLabel?.text = dateFormatter.string(from: historyTasks[indexPath.row].date)
        return cell
    }
}
