//
//  ScheduleController.swift
//  Petorque
//
//  Created by Tales Conrado on 23/04/20.
//  Copyright © 2020 Petorqueiros. All rights reserved.
//

import UIKit

//Creates a controller class for Schedule
//It uses the protocol UITableViewDelegate and UITableViewDataSource for providing ways to update the TableView with the tasks
class ScheduleController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var scheduleTableView: UITableView! {
        didSet {
            //Used to erase extra lines in the tableview by creating an empty UIView object for the footer
            scheduleTableView.tableFooterView = UIView()
        }
    }
    
    //Placeholder info
    let temporaryScheduleTableViewCellContent = ["Estudar design", "Fazer protótipo de alta fidelidade", "Plantar a babosa"]
    
    let temporarySubtitles = ["3 ciclos - 20 minutos", "3 ciclo - 30 minutos", "1 ciclo - 10 minutos"]
    
    
    //Using this method to call a custom function for delegating the TableView's delegate and it's data source
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView(){
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
    }
    
    
    //Setting tableView's size with the placeholder array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        temporaryScheduleTableViewCellContent.count
    }
    
    //Creating cells based on the content from the placeholder array and setting backgroud color
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = scheduleTableView.dequeueReusableCell(withIdentifier: "scheduleTableViewCell", for: indexPath)
        cell.backgroundColor = UIColor.white
        cell.textLabel?.text = temporaryScheduleTableViewCellContent[indexPath.row]
        cell.detailTextLabel?.text = temporarySubtitles[indexPath.row]
        return cell
    }
    

}
