//
//  TimerCountOrder.swift
//  Petorque
//

import UIKit

class TimerCountOrderViewController: UITableViewController {
    
    // MARK: Outlet
    @IBOutlet weak var timerCountOrderNavigationItem: UINavigationItem!
    
    // MARK: Segue
    var screenName: String = ""
    
    // MARK: Constants
    let cellsTexts = ["Progressiva", "Regressiva"]
    let defaultConfigs = ["Atividade": "Progressiva",
                          "Descanso": "Regressiva"]
    
    // MARK: Variables
    
    var timerCountOrder: String {
        get {
            // Gets the persisted configuration. If it doesn't exist, gets the default one.
            return UserDefaults.standard.string(forKey: screenName) ?? defaultConfigs[screenName]!
        }
        set(newTimerCountOrder) {
            UserDefaults.standard.set(newTimerCountOrder, forKey: screenName)
        }
    }
    
    override func viewDidLoad() {
        timerCountOrderNavigationItem.title = screenName
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if let cellText = cell?.textLabel?.text {
            if cellText != timerCountOrder {
                timerCountOrder = cellText
            }
        }
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = cellsTexts[indexPath.row]
        if cell.textLabel?.text == timerCountOrder {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
}
