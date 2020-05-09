//
//  File.swift
//  Petorque
//
//  Created by Eduardo Oliveira on 28/04/20.
//  Copyright © 2020 Petorqueiros. All rights reserved.
//
import UIKit

class CycleDurationPickerView: UIView {

    var nibName = "CycleDurationPicker"
    var contentView: UIView?
    
    @IBOutlet var durationCycleTextField: UITextField!
    
    var durationCyclePicker: UIPickerView!
    
    let durationCyclePickerData = ["20 minutos", "21 minutos", "22 minutos", "23 minutos", "24 minutos", "25 minutos", "26 minutos", "27 minutos", "28 minutos", "29 minutos", "30 minutos"]
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupXib()
        setupPicker()
    }
    
    private func setupPicker() {
        durationCyclePicker = UIPickerView()
        durationCyclePicker.delegate = self
        durationCyclePicker.dataSource = self
        durationCycleTextField.inputView = durationCyclePicker
        durationCycleTextField.borderStyle = .none
    }

    private func setupXib() {
        guard let view = loadViewFromNib() else { fatalError("Wrong Xib name") }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }

    func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
    func configure(with durationCycleValue: Int) {
        durationCycleTextField.text = "\(durationCycleValue) minutos"
        durationCyclePicker.selectRow(durationCycleValue - 20, inComponent: 0, animated: true)
    }
}

extension CycleDurationPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView( _ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return durationCyclePickerData.count
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
     return durationCyclePickerData[row]
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        durationCycleTextField.text = durationCyclePickerData[row]
    }
    func selectedRow(inComponent component: Int) -> Int {
        return 1
    }
}

