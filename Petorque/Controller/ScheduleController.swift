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
    
    @IBOutlet weak var daySelectedControl: UISegmentedControl!
    
    @IBOutlet var dayLabel: UILabel!
    
    var tasks: [Task] = []
    
    var todayTasks: [Task] = []
    var tomorrowTasks: [Task] = []
    
    func createTodayArray() -> [Task] {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let task1 = Task(title: "Estudar Design", cycleDuration: 25, numberOfCycles: 3, date: Date(timeIntervalSinceReferenceDate: 410220000))
        let task2 = Task(title: "Fazer protótipo de alta fidelidade", cycleDuration: 25, numberOfCycles: 4, date: Date(timeIntervalSinceReferenceDate: 410220000))
        let task3 = Task(title: "Plantar babosa", cycleDuration: 20, numberOfCycles: 2, date: Date(timeIntervalSinceReferenceDate: 410220000))
        return [task1, task2, task3]
    }
    
    func createTomorrowArray() -> [Task] {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let task1 = Task(title: "Estudar View Code", cycleDuration: 25, numberOfCycles: 3, date: Date(timeIntervalSinceReferenceDate: 410220000))
        let task2 = Task(title: "Fazer ilustração de tela inicial", cycleDuration: 25, numberOfCycles: 4, date: Date(timeIntervalSinceReferenceDate: 410220000))
        return [task1, task2]
    }
    
    @IBOutlet weak var scheduleTableView: UITableView! {
        didSet {
            scheduleTableView.tableFooterView = UIView()
        }
    }
    
    //Placeholder info
    let temporaryScheduleTableViewCellContent = ["Estudar design", "Fazer protótipo de alta fidelidade", "Plantar a babosa"]
    
    let temporarySubtitles = ["3 ciclos - 20 minutos", "3 ciclo - 30 minutos", "1 ciclo - 10 minutos"]
    
    //Loads data from database
    let taskList = Database.shared.loadData(from: .doing)
    
    //Using this method to call a custom function for delegating the TableView's delegate and it's data source
    override func viewDidLoad() {
        super.viewDidLoad()
        todayTasks = createTodayArray()
        tomorrowTasks = createTomorrowArray()
        tasks = todayTasks
        setupTableView()
    }
    
    
    @IBAction func daySegmentedControl(_ sender: UISegmentedControl) {
        let dayIndex = daySelectedControl.selectedSegmentIndex
        switch (dayIndex) {
            case 0:
                dayLabel.text = "O que faremos hoje?"
                tasks = todayTasks
                DispatchQueue.main.async {
                    self.scheduleTableView.reloadData()
                }
            case 1:
                dayLabel.text = "O que faremos amanhã?"
                tasks = tomorrowTasks
                DispatchQueue.main.async {
                    self.scheduleTableView.reloadData()
                }
        default:
                dayLabel.text = "O que faremos hoje?"
        }
    }
    
    func setupTableView(){
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
    }
    
    //Setting tableView's size with the placeholder array
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tasks.count
    }
    
    //Creating cells based on the content from the placeholder array and setting backgroud color
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = scheduleTableView.dequeueReusableCell(withIdentifier: "scheduleTableViewCell", for: indexPath)
        cell.backgroundColor = UIColor.white
        cell.textLabel?.text = tasks[indexPath.row].title
        cell.detailTextLabel?.text = "\(tasks[indexPath.row].numberOfCycles) ciclos - \(tasks[indexPath.row].cycleDuration) minutos"
        return cell
    }
    
    //Triggering the Edit Task Page
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "editTaskSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? EditTaskScheduleViewController {
            destination.task = tasks[(scheduleTableView.indexPathForSelectedRow?.row)!]
        }
    }
}

//add task modal delegate
extension ScheduleController: AddTaskScheduleDelegate {
    func saveTask(title: String, cycleDuration: Int, numberOfCycles: Int, date: Date) {
        print("a")
    }
}
