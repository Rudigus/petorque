//
//  AddTaskScheduleViewController.swift
//  Petorque
//
//  Created by Eduardo Oliveira on 23/04/20.
//  Copyright © 2020 Petorqueiros. All rights reserved.
//

import UIKit

class AddTaskScheduleViewController: UITableViewController {
    
    @IBOutlet var nameTextfield: UITextField!
    
    @IBOutlet weak var numberOfCyclesTextfield: UITextField!
    
    @IBOutlet var cycleDurationContent: CycleDurationPickerView!
    
    let numberOfCyclesPicker = UIPickerView()
    
    let numberOfCyclesPickerData = [String](arrayLiteral: "1 ciclo", "2 ciclos", "3 ciclos", "4 ciclos", "5 ciclos")
    
    weak var addTaskScheduleDelegate: AddTaskScheduleDelegate?
    
    var workingTooMuch: Bool?
    
    var daySelected: Int?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        numberOfCyclesPicker.delegate = self
        numberOfCyclesTextfield.inputView = numberOfCyclesPicker
        numberOfCyclesTextfield.borderStyle = .none
        numberOfCyclesPicker.center = view.center
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        if let workingTooMuch = workingTooMuch, workingTooMuch, let daySelected = daySelected {
            if daySelected == 0 {
                addTaskScheduleDelegate?.overWorkAlert(day: .today)
            } else {
                addTaskScheduleDelegate?.overWorkAlert(day: .tomorrow)
            }
        }
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        numberOfCyclesTextfield.resignFirstResponder()
    }
    
    
    @IBAction func CancelAddTask(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func FinishAddTask(_ sender: Any) {
        
        if let nameTextField = nameTextfield.text {
            let numberOfCycles = numberOfCyclesPicker.selectedRow(inComponent: 0) + 1
            
            let cycleDuration = cycleDurationContent.durationCyclePicker.selectedRow(inComponent: 0) + 20
            
            addTaskScheduleDelegate?.saveTask(title: nameTextField, cycleDuration: cycleDuration, numberOfCycles: numberOfCycles)
        } else {
            //TEMPORARY
            print("Invalid value in texfield")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}

extension AddTaskScheduleViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberOfCyclesPickerData.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return numberOfCyclesPickerData[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        numberOfCyclesTextfield.text = numberOfCyclesPickerData[row]
    }
    
    func selectedRow(inComponent component: Int) -> Int {
        print(1)
        return 1
    }
}
