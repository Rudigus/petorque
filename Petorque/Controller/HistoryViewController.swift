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
    @IBOutlet weak var emptyTasksView: UIView!

    var historyTasks: [Task] = []
    
    func loadArray() -> [Task] {
        let tasks = Database.shared.loadData(from: .done)
        return tasks
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        historyTasks = loadArray()
        tableView.reloadData()
        emptyTasksView.isHidden = historyTasks.isEmpty ? false : true
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
