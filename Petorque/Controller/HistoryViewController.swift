//
//  HistoryViewController.swift
//  Petorque
//
//  Created by Eduardo Oliveira on 22/04/20.
//  Copyright © 2020 Petorqueiros. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var tasks = [
        "Estudar Design",
        "Fazer protótipo de alta fidelidade",
        "Plantar babosa"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
}

extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       print("you tapped me!")
    }
}

extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row]
        return cell
    }
}
