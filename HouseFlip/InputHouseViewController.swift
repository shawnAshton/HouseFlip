//
//  InputHouseViewController.swift
//  HouseFlip
//
//  Created by Shawn Ashton on 9/28/20.
//

import UIKit

class InputHouseViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var AddressField: UITextField!
    @IBOutlet weak var OwnerField: UITextField!
    @IBOutlet weak var PriceField: UITextField!
    @IBOutlet weak var purchaseDate: UIDatePicker!
    @IBOutlet weak var houseNotes: UITextView!
    @IBOutlet weak var categorySelector: UISegmentedControl!
    
    var activeTextField : UITextField? = nil
    var activeTextView : UITextView? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        AddressField.delegate = self
        OwnerField.delegate = self
        PriceField.delegate = self
        houseNotes.delegate = self
        
       // the 2 notifications below are for helping move around the keyboard when typing
        NotificationCenter.default.addObserver(self, selector: #selector(InputHouseViewController.keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
          // call the 'keyboardWillHide' function when the view controller receives notification that keyboard is going to be hidden
        NotificationCenter.default.addObserver(self, selector: #selector(InputHouseViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func Submit(_ sender: Any) {
        //print("\(purchaseDate) was submited")
        var dic = ["address":AddressField.text!, "owner":OwnerField.text!, "price":PriceField.text!, "purchaseDate":purchaseDate.date,
                   "houseNotes": houseNotes.text!, "category" :categorySelector.selectedSegmentIndex] as [String : Any]
        let myDoc = db.collection("ShawnTest").document()
        dic["id"] = myDoc.documentID    
        myDoc.setData(dic, merge: true)
        self.performSegue(withIdentifier: "toListSegue", sender: self)
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.performSegue(withIdentifier: "toListSegue", sender: self)
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

