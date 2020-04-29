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
    
    override func viewDidLoad() {
        timerCountOrderNavigationItem.title = screenName
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}
