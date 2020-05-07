//
//  DatabaseModel.swift
//  To-Do-List
//
//  Created by Tales Conrado on 29/04/20.
//  Copyright © 2020 Tales Conrado. All rights reserved.
//

import Foundation

enum DoingOrDone {
    case doing
    case done
}

class Database {
    
    var doing: URL
    var done: URL
    
    var emptyArray = [Task]()
    
    //Singleton: Access by using Database.shared.<function-name>
    static let shared = Database()
    
    private init(){
        let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let doingFileName = "doing.json"
        let doneFileName = "done.json"

        doing = documentsFolder.appendingPathComponent(doingFileName)
        done = documentsFolder.appendingPathComponent(doneFileName)
        
        //Caso os arquivos não existam, eles são criados no init
        if !(FileManager.default.fileExists(atPath: doing.path)){
            saveData(from: emptyArray, to: .doing)
        }
        if !(FileManager.default.fileExists(atPath: done.path)){
            saveData(from: emptyArray, to: .done)
        }
    }
    
    func loadData(from list: DoingOrDone) -> [Task] {
        
        var type: URL
        var loadedArray: [Task] = []
        
        switch list {
        case .doing:
            type = doing
        case .done:
            type = done
        }
    
        do {
            let arquivoASerLido = try Data(contentsOf: type)
            loadedArray = try JSONDecoder().decode([Task].self, from: arquivoASerLido)
        } catch {
            print(error.localizedDescription)
        }
        
        return loadedArray
    }
    
    func saveData(from array: [Task], to list: DoingOrDone){
        
        var type: URL
        
        switch list {
        case .doing:
            type = doing
        case .done:
            type = done
        }
        
        do {
            let jsonData = try JSONEncoder().encode(array)
            try jsonData.write(to: type)
        } catch {
            print("Impossível escrever no arquivo.")
        }
        
    }
    
    @discardableResult func deleteData(from list: DoingOrDone, at index: Int) -> Task {

        var loadedArray = loadData(from: list)
        let removedElement = loadedArray.remove(at: index)
        saveData(from: loadedArray, to: list)
        
        return removedElement
        
    }
    
    func addToDone(task: Task){
        var allDoneTasks = loadData(from: .done)
        allDoneTasks.append(task)
        saveData(from: allDoneTasks, to: .done)
    }
    
    func loadTodayTasks(from type : DoingOrDone) -> [Task] {
        let allTasks = loadData(from: type)
        let todayTasks = allTasks.filter({ task in
            let todayDate = getDate(of: .today)
            if task.date == todayDate {
                return true
            }
            return false
        })

        return todayTasks
    }
    
    func loadTomorrowTasks() -> [Task] {
        let allTasks = loadData(from: .doing)
        let tomorrowTasks = allTasks.filter({ task in
            let tomorrowDate = getDate(of: .tomorrow)
            if task.date == tomorrowDate {
                return true
            }
            return false
        })

        return tomorrowTasks
    }
    
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
}
