//
//  TimerCountOrder.swift
//  Petorque
//

import UIKit

class TimerCountOrderViewController: UIViewController {
    
    // MARK: Outlet
    @IBOutlet weak var timerCountOrderNavigationItem: UINavigationItem!
    
    // MARK: Segue
    var screenName: String = ""
    
    override func viewDidLoad() {
        self.title = "some title"
    }
    
}
