//
//  editCostsViewController.swift
//  HouseFlip
//
//  Created by Shawn Ashton on 11/12/20.
//

import UIKit

class editCostsViewController: UIViewController, UITextViewDelegate {
    var myDict:[String:Any] = [:]
    var costDict:[String:Any] = [:]
    var activeTextView : UITextView? = nil
    @IBOutlet weak var costDescription: UITextView!
    
    @IBOutlet weak var costAmount: UITextField!
    
    @IBAction func backFromEditCost(_ sender: Any) {
        self.performSegue(withIdentifier: "backFromEditCosts", sender: self)
    }
    
    @IBAction func updateCost(_ sender: Any) {
        var dic:[String:Any] = [:]
        //adds the task to the tasks collection of the specific home.
        dic["costAmount"] = costAmount.text!
        dic["costDescription"] = costDescription.text!
        db.collection("ShawnTest").document(myDict["id"] as! String).collection("costs").document(costDict["id"] as! String).setData(dic, merge: true)
        self.performSegue(withIdentifier: "backFromEditCosts", sender: self)
    }
    
    @IBAction func deleteCost(_ sender: Any) {
        db.collection("ShawnTest").document(myDict["id"] as! String).collection("costs").document(costDict["id"] as! String).delete()
        self.performSegue(withIdentifier: "backFromEditCosts", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backFromEditCosts" {
            let destinationController = segue.destination as! costsViewController
            destinationController.myDict = myDict
        }
    }
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        costDescription.text! = costDict["costDescription"] as! String
        costDescription.delegate = self
        costAmount.text! = costDict["costAmount"] as! String
        super.viewDidLoad()
        // listeners for when the keyboard will appear and dissapear
         NotificationCenter.default.addObserver(self, selector: #selector(InputHouseViewController.keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(InputHouseViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Do any additional setup after loading the view.
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
