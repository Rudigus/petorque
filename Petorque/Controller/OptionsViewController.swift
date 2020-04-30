//
//  OptionsViewController.swift
//  Petorque
//

import UIKit

class OptionsViewController: UITableViewController {
    
    // MARK: Outlet
    @IBOutlet weak var optionsNavigationItem: UINavigationItem!
    @IBOutlet var cells: [UITableViewCell]!
    
    // MARK: Constants
    static let defaultConfigs = ["Atividade": "Progressiva",
    "Descanso": "Regressiva"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCells()
    }
    
    func setupCells() {
        for cell in cells {
            guard let cellLabelText = cell.textLabel?.text else {
                return
            }
            guard let cellDetailLabel = cell.detailTextLabel else {
                return
            }
            cellDetailLabel.text = UserDefaults.standard.string(forKey: cellLabelText) ?? OptionsViewController.defaultConfigs[cellLabelText]!
        }
    }
    
    // This function sends the selected table view cell's primary text to the option modal view controller.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let timerCountOrder = segue.destination as? TimerCountOrderViewController else {
            print("Unable to cast segue destination to TimerCountOrderViewController.")
            return
        }
        guard let cell = sender as? UITableViewCell else {
            print("Unable to cast sender to UITableViewCell.")
            return
        }
        guard let screenName = cell.textLabel?.text else {
            print("The text label is nil.")
            return
        }
        timerCountOrder.screenName = screenName
    }
    
}
