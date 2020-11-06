//
//  EditTasksViewController.swift
//  HouseFlip
//
//  Created by Shawn Ashton on 11/5/20.
//

import UIKit

class EditTasksViewController: UIViewController {

    var myDict:[String:Any] = [:]
    
    @IBAction func goBack(_ sender: Any) {
        self.performSegue(withIdentifier: "backToTasks", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToTasks" {
            let destinationController = segue.destination as! TasksViewController
            destinationController.myDict = myDict
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }

}
