//
//  AddTaskScheduleViewController.swift
//  Petorque
//
//  Created by Eduardo Oliveira on 23/04/20.
//  Copyright © 2020 Petorqueiros. All rights reserved.
//

import UIKit

class AddTaskScheduleViewController: UITableViewController {
    
    @IBOutlet weak var numberOfCyclesTextfield: UITextField!
    
    let numberOfCyclesPicker = UIPickerView()
    
    let numberOfCyclesPickerData = [String](arrayLiteral: "1 ciclo", "2 ciclos", "3 ciclos", "4 ciclos", "5 ciclos")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Adicionar"
        tableView.tableFooterView = UIView()
        numberOfCyclesPicker.delegate = self
        numberOfCyclesTextfield.inputView = numberOfCyclesPicker
    }
    @IBAction func CloseAddModally(_ sender: UIButton) {
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
}
