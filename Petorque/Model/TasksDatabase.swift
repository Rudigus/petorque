//
//  TasksDatabase.swift
//  Petorque
//
//  Created by Tales Conrado on 28/04/20.
//  Copyright © 2020 Petorqueiros. All rights reserved.
//

import Foundation

enum DoingOrDone {
    case doing
    case done
}

class Database {
    
    var doing: URL
    var done: URL
    
    var doingArray: [Task] = []
    var doneArray: [Task] = []
    
    init(){
        let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let doingFileName = "doing.db"
        let doneFileName = "done.db"

        doing = documentsFolder.appendingPathComponent(doingFileName)
        done = documentsFolder.appendingPathComponent(doneFileName)
        
        doingArray = loadData(from: .doing)
        doneArray = loadData(from: .done)
    }

    
    func loadData(from category: DoingOrDone) -> [Task] {
        
        //Load files
        switch category {
        case .doing:
            do {
                let doingData = try Data(contentsOf: doing)
                if let doingLoaded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(doingData) as? [Task]{
                    doingArray = doingLoaded
                }
            } catch {
                print("Couldn't read file.")
            }
            
            return doingArray
            
        case .done:
            do {
                let doneData = try Data(contentsOf: done)
                if let doneLoaded = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(doneData) as? [Task]{
                    doneArray = doneLoaded
                }
            } catch {
                print("Couldn't read file.")
            }
            return doneArray
        }
    }

    func saveData(of list: [Task], from category: DoingOrDone){
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: list, requiringSecureCoding: false)
            if category == .done{
                try data.write(to: done)
            } else {
                try data.write(to: doing)
            }
        } catch {
            print("Couldn't write file")
        }
    }
    
}
