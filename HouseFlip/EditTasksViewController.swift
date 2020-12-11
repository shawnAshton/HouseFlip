//
//  EditTasksViewController.swift
//  HouseFlip
//
//  Created by Shawn Ashton on 11/5/20.
//

import UIKit
import Firebase //needed for casting item from dictionary to timestamp

class EditTasksViewController: UIViewController, UITextViewDelegate {

    var myDict:[String:Any] = [:] // for house
    var taskDict:[String:Any] = [:]
    var fromAllTasks = false
    var segueName = ""
    
    @IBOutlet weak var dueDate: UIDatePicker!
    @IBOutlet weak var taskDescription: UITextView!
    
    var activeTextView : UITextView? = nil
    
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
        taskDescription.delegate = self
        
        if fromAllTasks == true
        {
            segueName = "backToAllTasks"
        }
        else
        {
            segueName = "backToTasks"
        }
        // listeners for when the keyboard will appear and dissapear
         NotificationCenter.default.addObserver(self, selector: #selector(InputHouseViewController.keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(InputHouseViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = UIColor.systemGray6
        self.activeTextView = textView
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.backgroundColor = UIColor.white
        self.activeTextView = nil
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
      self.view.frame.origin.y = 0
    }
    
    @objc func keyboardWillShow(notification: Notification)
    {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
          // if keyboard size is not available for some reason, dont do anything
          return
        }

        var shouldMoveViewUp = false

         if let activeTextView = activeTextView {

          let bottomOfTextView = activeTextView.convert(activeTextView.bounds, to: self.view).maxY;

          let topOfKeyboard = self.view.frame.height - keyboardSize.height

          // if the bottom of Textfield is below the top of keyboard, move up
          if bottomOfTextView > topOfKeyboard {
            shouldMoveViewUp = true
          }
        }
        if(shouldMoveViewUp) {
          self.view.frame.origin.y = 0 - 80//keyboardSize.height
        }
    }
}
