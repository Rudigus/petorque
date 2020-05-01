//
//  EditTaskScheduleViewController.swift
//  Petorque
//
//  Created by Eduardo Oliveira on 30/04/20.
//  Copyright © 2020 Petorqueiros. All rights reserved.
//

import UIKit

class EditTaskScheduleViewController: UITableViewController {
    var task: Task?
    
    @IBOutlet var nameTextfield: UITextField!
    
    @IBOutlet weak var numberOfCyclesTextfield: UITextField!
    
    @IBOutlet var cycleDurationContent: CycleDurationPickerView!
    
    let numberOfCyclesPicker = UIPickerView()
    
    let numberOfCyclesPickerData = [String](arrayLiteral: "1 ciclo", "2 ciclos", "3 ciclos", "4 ciclos", "5 ciclos")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        numberOfCyclesPicker.delegate = self
        numberOfCyclesPicker.selectRow(task!.numberOfCycles - 1, inComponent: 0, animated: true)
        numberOfCyclesTextfield.inputView = numberOfCyclesPicker
        numberOfCyclesTextfield.borderStyle = .none
        if (task?.numberOfCycles == 1) {
            numberOfCyclesTextfield.text = "1 ciclo"
        } else {
            numberOfCyclesTextfield.text = "\(task?.numberOfCycles ?? 0) ciclos"
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
    }
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        numberOfCyclesTextfield.resignFirstResponder()
    }
    
    @IBAction func CancelEditTask(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func FinishEditTask(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func DeleteTask(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension EditTaskScheduleViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
