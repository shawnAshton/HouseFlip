//
//  InputHouseViewController.swift
//  HouseFlip
//
//  Created by Shawn Ashton on 9/28/20.
//

import UIKit

class InputHouseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var AddressField: UITextField!
    @IBOutlet weak var OwnerField: UITextField!
    @IBOutlet weak var PriceField: UITextField!
    
    @IBAction func Submit(_ sender: Any) {
        //print("\(AddressField.text!) was submited")
        var dic = ["address":AddressField.text!, "owner":OwnerField.text!, "price":PriceField.text!]
        let myDoc = db.collection("ShawnTest").document()
        dic["id"] = myDoc.documentID
        myDoc.setData(dic, merge: true)
        self.performSegue(withIdentifier: "toListSegue", sender: self)
    }
    
    @IBAction func goBack(_ sender: Any) {
        self.performSegue(withIdentifier: "toListSegue", sender: self)
    }
    
}
