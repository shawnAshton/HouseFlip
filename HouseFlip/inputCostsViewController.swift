//
//  inputCostsViewController.swift
//  HouseFlip
//
//  Created by Shawn Ashton on 11/12/20.
//

import UIKit

class inputCostsViewController: UIViewController, UITextViewDelegate {
    var myDict:[String:Any] = [:]
    var activeTextView : UITextView? = nil

    @IBOutlet weak var costAmount: UITextField!
    @IBOutlet weak var costDescription: UITextView!
    
    @IBAction func backFromAddCost(_ sender: Any) {
        self.performSegue(withIdentifier: "backFromAddCost", sender: self)
    }
    
    @IBAction func submitNewCost(_ sender: Any) {
        var dic:[String:Any] = [:]
        dic["costAmount"] = costAmount.text!
        //regular expressions...
        //let range = NSRange(location:0, length: dic["costAmount"].count)
        //let regex = try! NSRegularExpression(pattern: "[0-9]+\.?[0-9]{0,2}")
        dic["costDescription"] = costDescription.text!
        let myDoc = db.collection("ShawnTest").document(myDict["id"] as! String).collection("costs").document()
        dic["id"] = myDoc.documentID
        myDoc.setData(dic, merge: true)
        self.performSegue(withIdentifier: "backFromAddCost", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backFromAddCost"{
            let destinationController = segue.destination as! costsViewController
            destinationController.myDict = myDict
        }
    }
    

    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        costDescription.delegate = self
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
