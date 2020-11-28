//
//  EditTasksViewController.swift
//  HouseFlip
//
//  Created by Shawn Ashton on 11/5/20.
//

import UIKit
import Firebase //needed for casting item from dictionary to timestamp

class EditTasksViewController: UIViewController {

    var myDict:[String:Any] = [:] // for house
    var taskDict:[String:Any] = [:]
    var fromAllTasks = false
    var segueName = ""
    
    @IBOutlet weak var dueDate: UIDatePicker!
    @IBOutlet weak var taskDescription: UITextView!
    
    @IBAction func goBack(_ sender: Any) {
        self.performSegue(withIdentifier: segueName, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToTasks" {
            let destinationController = segue.destination as! TasksViewController
            destinationController.myDict = myDict
        }
    }
    
    @IBAction func updateTasks(_ sender: Any) {
        var dic:[String:Any] = [:]
        //adds the task to the tasks collection of the specific home.
        dic["dueDate"] = dueDate.date
        dic["taskDescription"] = taskDescription.text!
        db.collection("ShawnTest").document(taskDict["houseid"] as! String).collection("tasks").document(taskDict["id"] as! String).setData(dic, merge: true)
        self.performSegue(withIdentifier: segueName, sender: self)
    }
    
    @IBAction func deleteTask(_ sender: Any) {
        db.collection("ShawnTest").document(taskDict["houseid"] as! String).collection("tasks").document(taskDict["id"] as! String).delete()
        self.performSegue(withIdentifier: segueName, sender: self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        taskDescription.text! = taskDict["taskDescription"] as! String
        let tsDate = taskDict["dueDate"] as! Timestamp //gets the firestore timestamp
        let myDate:Date = tsDate.dateValue() //converts to a swift date object
        dueDate.date = myDate
        
        if fromAllTasks == true
        {
            segueName = "backToAllTasks"
        }
        else
        {
            segueName = "backToTasks"
        }
    }

}
