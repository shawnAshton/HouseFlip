//
//  inputTaskViewController.swift
//  HouseFlip
//
//  Created by Shawn Ashton on 10/30/20.
//

import UIKit

class inputTaskViewController: UIViewController, UITextViewDelegate {

    var myDict:[String:Any] = [:]
    var activeTextView : UITextView? = nil
    @IBOutlet weak var dueDate: UIDatePicker!
    @IBOutlet weak var taskDescription: UITextView!
    
    @IBAction func goBack(_ sender: Any) {
        self.performSegue(withIdentifier: "createTaskToTasks", sender: self)
    }
    
    @IBAction func submitTaskToFirestore(_ sender: Any) {
        var dic:[String:Any] = [:]
        
        //adds the task to the tasks collection of the specific home.
        let myDoc = db.collection("ShawnTest").document(myDict["id"] as! String).collection("tasks").document()
        dic["houseid"] = myDict["id"] as! String
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
        taskDescription.delegate = self
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
