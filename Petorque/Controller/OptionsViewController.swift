//
//  OptionsViewController.swift
//  Petorque
//

import UIKit

class OptionsViewController: UITableViewController {
    
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
        
        // TODO: Deselect the selected table row after dismissing the options modal, with smooth animation.
    }
    
}
