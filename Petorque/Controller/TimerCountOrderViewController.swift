//
//  TimerCountOrder.swift
//  Petorque
//

import UIKit

class TimerCountOrderViewController: UITableViewController {
    
    // MARK: Outlet
    @IBOutlet weak var timerCountOrderNavigationItem: UINavigationItem!
    @IBOutlet var cells: [UITableViewCell]!
    
    // MARK: Segue
    var screenName: String = ""
    
    // MARK: Variables
    
    var timerCountOrder: String {
        get {
            // Gets the persisted configuration. If it doesn't exist, gets the default one.
            return UserDefaults.standard.string(forKey: screenName) ?? OptionsViewController.defaultConfigs[screenName]!
        }
        set(newTimerCountOrder) {
            UserDefaults.standard.set(newTimerCountOrder, forKey: screenName)
        }
    }
    
    // MARK: Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerCountOrderNavigationItem.title = screenName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupCells()
    }
    
    func setupCells() {
        for cell in cells {
            guard let cellLabel = cell.textLabel else {
                return
            }
            if cellLabel.text == timerCountOrder {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let cellText = cell?.textLabel?.text {
            if cellText != timerCountOrder {
                timerCountOrder = cellText
                setupCells()
            }
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
}
