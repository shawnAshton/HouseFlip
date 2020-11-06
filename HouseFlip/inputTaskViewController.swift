//
//  inputTaskViewController.swift
//  HouseFlip
//
//  Created by Shawn Ashton on 10/30/20.
//

import UIKit

class inputTaskViewController: UIViewController {

    var myDict:[String:Any] = [:]
    @IBOutlet weak var dueDate: UIDatePicker!
    @IBOutlet weak var taskDescription: UITextView!
    
    @IBAction func goBack(_ sender: Any) {
        self.performSegue(withIdentifier: "createTaskToTasks", sender: self)
    }
    
    @IBAction func submitTaskToFirestore(_ sender: Any) {
        var dic:[String:Any] = [:]
        
        //adds the task to the tasks collection of the specific home.
        let myDoc = db.collection("ShawnTest").document(myDict["id"] as! String).collection("tasks").document()
        dic["id"] = myDoc.documentID
        dic["dueDate"] = dueDate.date
        dic["taskDescription"] = taskDescription.text!
        myDoc.setData(dic, merge: true)
        self.performSegue(withIdentifier: "createTaskToTasks", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createTaskToTasks" {
            let destinationController = segue.destination as! TasksViewController
            destinationController.myDict = myDict
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

    }
}
