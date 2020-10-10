//
//  HouseEditViewController.swift
//  HouseFlip
//
//  Created by Shawn Ashton on 10/6/20.
//

import UIKit
import Firebase //needed for casting item from dictionary to timestamp

class HouseEditViewController: UIViewController {


    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var ownerTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var purchaseDate: UIDatePicker!
    
    var myDict:[String:Any] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        priceTextField.text! = myDict["price"] as! String
        ownerTextField.text! = myDict["owner"] as! String
        addressTextField.text! = myDict["address"] as! String
        let tsDate = myDict["purchaseDate"] as! Timestamp //gets the firestore timestamp
        let myDate:Date = tsDate.dateValue() //converts to a swift date object
        purchaseDate.date = myDate
    }

    //updates the information that was edited on the page
    @IBAction func updateHouse(_ sender: Any) {
        let dic = ["address":addressTextField.text!, "owner":ownerTextField.text!, "price":priceTextField.text!, "purchaseDate":purchaseDate.date] as [String : Any]
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
}
