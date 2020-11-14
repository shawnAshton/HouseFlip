//
//  inputCostsViewController.swift
//  HouseFlip
//
//  Created by Shawn Ashton on 11/12/20.
//

import UIKit

class inputCostsViewController: UIViewController {
    var myDict:[String:Any] = [:]
    @IBOutlet weak var costAmount: UITextField!
    @IBOutlet weak var costDescription: UITextView!
    
    @IBAction func backFromAddCost(_ sender: Any) {
        self.performSegue(withIdentifier: "backFromAddCost", sender: self)
    }
    
    @IBAction func submitNewCost(_ sender: Any) {
        var dic:[String:Any] = [:]
        let myDoc = db.collection("ShawnTest").document(myDict["id"] as! String).collection("costs").document()
        dic["id"] = myDoc.documentID
        dic["costAmount"] = costAmount.text!
        dic["costDescription"] = costDescription.text!
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
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
