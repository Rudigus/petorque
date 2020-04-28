//
//  OptionsViewController.swift
//  Petorque
//

import UIKit

class OptionsViewController: UITableViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let timerCountOrder = segue.destination as? TimerCountOrderViewController
        {
            timerCountOrder.screenName = "joao"
        }
    }
    
}
