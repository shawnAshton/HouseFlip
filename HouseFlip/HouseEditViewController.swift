//
//  HouseEditViewController.swift
//  HouseFlip
//
//  Created by Shawn Ashton on 10/6/20.
//

import UIKit
import Firebase //needed for casting item from dictionary to timestamp

class HouseEditViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {


    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var ownerTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var purchaseDate: UIDatePicker!
    @IBOutlet weak var houseNotes: UITextView!
    @IBOutlet weak var categorySelector: UISegmentedControl!
    
    var activeTextField : UITextField? = nil
    var activeTextView : UITextView? = nil
    
    var myDict:[String:Any] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // pull info from Dictionary given from view controllers prepare function
        priceTextField.text! = myDict["price"] as! String
        ownerTextField.text! = myDict["owner"] as! String
        addressTextField.text! = myDict["address"] as! String
        let tsDate = myDict["purchaseDate"] as! Timestamp //gets the firestore timestamp
        let myDate:Date = tsDate.dateValue() //converts to a swift date object
        purchaseDate.date = myDate
        houseNotes.text! = myDict["houseNotes"] as! String
        categorySelector.selectedSegmentIndex = myDict["category"] as! Int
        
        //set up delegates
        addressTextField.delegate = self
        ownerTextField.delegate = self
        priceTextField.delegate = self
        houseNotes.delegate = self
        
        // listeners for when the keyboard will appear and dissapear
         NotificationCenter.default.addObserver(self, selector: #selector(InputHouseViewController.keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(InputHouseViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    //updates the information that was edited on the page
    @IBAction func updateHouse(_ sender: Any) {
        let dic = ["address":addressTextField.text!, "owner":ownerTextField.text!, "price":priceTextField.text!, "purchaseDate":purchaseDate.date, "houseNotes":houseNotes.text!, "category":categorySelector.selectedSegmentIndex] as [String : Any]
        //merge with db. (merge doesnt overwrite the id tag)
        db.collection("ShawnTest").document(myDict["id"] as! String).setData(dic, merge: true)
    }
    
    //changes screens
    @IBAction func goBack(_ sender: Any) {
        self.performSegue(withIdentifier: "goBack", sender: self)
    }
    
    //deletes the document, and then changes screens
    @IBAction func deleteDocument(_ sender: Any) {
        db.collection("ShawnTest").document(myDict["id"] as! String).delete()
        self.performSegue(withIdentifier: "goBack", sender: self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeTextField = nil
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.backgroundColor = UIColor.systemGray6
        self.activeTextView = textView
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

        // if active text field is not nil
        if let activeTextField = activeTextField {

          let bottomOfTextField = activeTextField.convert(activeTextField.bounds, to: self.view).maxY;

          let topOfKeyboard = self.view.frame.height - keyboardSize.height

          // if the bottom of Textfield is below the top of keyboard, move up
          if bottomOfTextField > topOfKeyboard {
            shouldMoveViewUp = true
          }
        }
         if let activeTextView = activeTextView {

          let bottomOfTextView = activeTextView.convert(activeTextView.bounds, to: self.view).maxY;

          let topOfKeyboard = self.view.frame.height - keyboardSize.height

          // if the bottom of Textfield is below the top of keyboard, move up
          if bottomOfTextView > topOfKeyboard {
            shouldMoveViewUp = true
          }
        }
        if(shouldMoveViewUp) {
          self.view.frame.origin.y = 0 - keyboardSize.height
        }
    }
}
