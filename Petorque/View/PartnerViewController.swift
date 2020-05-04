//
//  PartnerViewController.swift
//  Petorque
//
//  Created by Pedro Henrique Costa on 30/04/20.
//  Copyright © 2020 Petorqueiros. All rights reserved.
//

import UIKit

class PartnerViewController: UIViewController {

    func createArray() -> [Task] {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let task1 = Task(title: "Estudar Design", cycleDuration: 25, numberOfCycles: 3, date: Date(timeIntervalSinceReferenceDate: 410220000))
        let task2 = Task(title: "Fazer protótipo de alta fidelidade", cycleDuration: 25, numberOfCycles: 4, date: Date(timeIntervalSinceReferenceDate: 410220000))
        let task3 = Task(title: "Plantar minhas babosas", cycleDuration: 20, numberOfCycles: 2, date: Date(timeIntervalSinceReferenceDate: 410220000))
        return [task1, task2, task3]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let test : [Task] = createArray()
        //Database.shared.saveData(from: test, to: .doing)
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
