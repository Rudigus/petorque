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
    
    
    @IBOutlet var messageView: UIView!
    
    @IBOutlet var dayLabel: UILabel!
    
    var tasks: [Task] = []
    
    var allTasks:[Task] = []
    
    //Remember user decision about showing overwork alerts
    var showOverWorkMessageToday = UserDefaults.standard.integer(forKey: "todayOverwork")
    
    var showOverWorkMessageTomorrow = UserDefaults.standard.integer(forKey: "tomorrowOverwork")
    
    @IBOutlet weak var dayControl: UISegmentedControl!
    
    @IBOutlet weak var scheduleTableView: UITableView! {
        didSet {
            scheduleTableView.tableFooterView = UIView()
        }
    }

    
    //Using this method to call a custom function for delegating the TableView's delegate and it's data source
    override func viewDidLoad() {
        super.viewDidLoad()
        allTasks = Database.shared.loadData(from: .doing)
        tasks = loadTodayTasks()
        messageIsHidden()
        setupTableView()
        setupDayControl()
        UserDefaults.standard.set(0, forKey: "todayOverwork")
        UserDefaults.standard.set(0, forKey: "tomorrowOverwork")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if daySelectedControl.selectedSegmentIndex == 0 {
            tasks = loadTodayTasks()
            if UserDefaults.standard.integer(forKey: "todayOverwork") == 1 {
                overWorkAlert(day: .today)
            }
        } else {
            tasks = loadTomorrowTasks()
            if UserDefaults.standard.integer(forKey: "tomorrowOverwork") == 1 {
                overWorkAlert(day: .tomorrow)
            }
        }
    }
    
    func setupDayControl()
    {
        dayControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
    }
    
    func messageIsHidden () {
        if (tasks.count == 0) {
            messageView.isHidden = false
        } else {
            messageView.isHidden = true
        }
    }
    
    @IBAction func daySegmentedControl(_ sender: UISegmentedControl) {
        let dayIndex = daySelectedControl.selectedSegmentIndex
        switch (dayIndex) {
            case 0:
                dayLabel.text = "O que faremos hoje?"
                tasks = loadTodayTasks()
                DispatchQueue.main.async {
                    self.scheduleTableView.reloadData()
                }
                if UserDefaults.standard.integer(forKey: "todayOverwork") == 1 {
                    overWorkAlert(day: .today)
                }
            case 1:
                dayLabel.text = "O que faremos amanhã?"
                tasks = loadTomorrowTasks()
                DispatchQueue.main.async {
                    self.scheduleTableView.reloadData()
                }
                if UserDefaults.standard.integer(forKey: "tomorrowOverwork") == 1 {
                    overWorkAlert(day: .tomorrow)
                }
        default:
                dayLabel.text = "O que faremos hoje?"
                tasks = loadTodayTasks()
                DispatchQueue.main.async {
                    self.scheduleTableView.reloadData()
                }
        }
        messageIsHidden()
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
            destination.location =
            allTasks.firstIndex(of: tasks[(scheduleTableView.indexPathForSelectedRow?.row)!])
            destination.editTaskScheduleDelegate = self
            destination.workingTooMuch = totalWorkedHours(list: tasks)
            destination.daySelected = daySelectedControl.selectedSegmentIndex
        }
        
        if let destination = segue.destination as? AddTaskScheduleViewController {
            destination.addTaskScheduleDelegate = self
            destination.workingTooMuch = isWorkHoursTooMuch(list: tasks)
            destination.daySelected = daySelectedControl.selectedSegmentIndex
        }
    }
}

enum TodayOrTomorrow {
    case today
    case tomorrow
}



extension ScheduleController: AddTaskScheduleDelegate, EditTaskScheduleDelegate {
    //add task modal delegate
    func saveTask(title: String, cycleDuration: Int, numberOfCycles: Int) {
        
        var date: Date
        var updatingTable: TodayOrTomorrow
        
        if daySelectedControl.selectedSegmentIndex == 1 {
            date = getDate(of: .tomorrow)
            updatingTable = .tomorrow
        } else {
            date = getDate(of: .today)
            updatingTable = .today
        }
        
        let newTask = Task(title: title, cycleDuration: cycleDuration, numberOfCycles: numberOfCycles, date: date)
        self.allTasks.append(newTask)
        Database.shared.saveData(from: self.allTasks, to: .doing)
        
        if updatingTable == .tomorrow {
            tasks = loadTomorrowTasks()
        } else {
            tasks = loadTodayTasks()
        }
        
        scheduleTableView.reloadData()
        messageIsHidden()
    }
    
    //edit task modal delegate
    func updateTask(title: String, cycleDuration: Int, numberOfCycles: Int, location: Int) {

        var date: Date
        var updatingTable: TodayOrTomorrow
        
        if daySelectedControl.selectedSegmentIndex == 1 {
            date = getDate(of: .tomorrow)
            updatingTable = .tomorrow
        } else {
            date = getDate(of: .today)
            updatingTable = .today
        }
        
        let newTask = Task(title: title, cycleDuration: cycleDuration, numberOfCycles: numberOfCycles, date: date)
        self.allTasks[location] = newTask
        Database.shared.saveData(from: self.allTasks, to: .doing)
        
        if updatingTable == .tomorrow {
            tasks = loadTomorrowTasks()
        } else {
            tasks = loadTodayTasks()
        }
        
        scheduleTableView.reloadData()
        messageIsHidden()
    }
    
    
    func deleteTask(location: Int) {
        var updatingTable: TodayOrTomorrow
        if daySelectedControl.selectedSegmentIndex == 1 {
            updatingTable = .tomorrow
        } else {
            updatingTable = .today
        }
        self.allTasks.remove(at: location)
        Database.shared.saveData(from: self.allTasks, to: .doing)
        
        if updatingTable == .tomorrow {
            tasks = loadTomorrowTasks()
        } else {
            tasks = loadTodayTasks()
        }
        
        scheduleTableView.reloadData()
        messageIsHidden()
    }
    
    //Utility function for getting the date
    func getDate(of day: TodayOrTomorrow) -> Date{
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
    
    //Loads today tasks filtering from the Database
    func loadTodayTasks() -> [Task] {
        let todayTasks = self.allTasks.filter({ task in
            let todayDate = getDate(of: .today)
            if task.date == todayDate {
                return true
            }
            return false
        })
        
        if isWorkHoursTooMuch(list: todayTasks) {
            if UserDefaults.standard.integer(forKey: "todayOverwork") == 0 {
                UserDefaults.standard.set(1, forKey: "todayOverwork")
            }
        }
        
        return todayTasks
    }
    
    func loadTomorrowTasks() -> [Task] {
        let tomorrowTasks = self.allTasks.filter({ task in
            let tomorrowDate = getDate(of: .tomorrow)
            if task.date == tomorrowDate {
                return true
            }
            return false
        })

        if isWorkHoursTooMuch(list: tomorrowTasks){
            if UserDefaults.standard.integer(forKey: "tomorrowOverwork") == 0 {
                UserDefaults.standard.set(1, forKey: "tomorrowOverwork")
            }
        }
        
        return tomorrowTasks
    }
    
    func isWorkHoursTooMuch(list: [Task]) -> Bool{
        
        var totalHours = 0
        
        for task in list {
            totalHours += (task.cycleDuration) * (task.numberOfCycles)
        }
        
        if totalHours >= 360 {
            return true
        }
        return false
    }
    
    func totalWorkedHours(list: [Task]) -> Int {
        var totalHours = 0
        
        for task in list {
            totalHours += (task.cycleDuration) * (task.numberOfCycles)
        }
        return totalHours
    }
    
    func overWorkAlert(day: TodayOrTomorrow) {
        let alert = UIAlertController(title: "Cuidado!", message: "O seu tempo de trabalho está alto! Tente não se sobrecarregar.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Entendi", style: .default, handler: {
            action in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Não mostrar novamente.", style: .cancel, handler: {
            action in
            if day == .today {
                UserDefaults.standard.set(2, forKey: "todayOverwork")
            } else {
                UserDefaults.standard.set(2, forKey: "tomorrowOverwork")
            }
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true)
    }
    
}
