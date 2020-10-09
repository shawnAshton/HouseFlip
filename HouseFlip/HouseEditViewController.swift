//
//  HouseEditViewController.swift
//  HouseFlip
//
//  Created by Shawn Ashton on 10/6/20.
//

import UIKit


class HouseEditViewController: UIViewController {


    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var ownerTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    
    var myDict:[String:Any] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        priceTextField.text! = myDict["price"] as! String
        ownerTextField.text! = myDict["owner"] as! String
        addressTextField.text! = myDict["address"] as! String
       // loadMyStackViews()
        print(myDict)

    }

    @IBAction func updateHouse(_ sender: Any) {
        let dic = ["address":addressTextField.text!, "owner":ownerTextField.text!, "price":priceTextField.text!]
        db.collection("ShawnTest").document(myDict["id"] as! String).setData(dic, merge: true)
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.performSegue(withIdentifier: "goBack", sender: self)
    }
    
    @IBAction func deleteDocument(_ sender: Any) {
        db.collection("ShawnTest").document(myDict["id"] as! String).delete()
        self.performSegue(withIdentifier: "goBack", sender: self)
    }
}
