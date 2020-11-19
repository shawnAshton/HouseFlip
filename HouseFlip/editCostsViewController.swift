//
//  editCostsViewController.swift
//  HouseFlip
//
//  Created by Shawn Ashton on 11/12/20.
//

import UIKit

class editCostsViewController: UIViewController {
    var myDict:[String:Any] = [:]
    var costDict:[String:Any] = [:]
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
        costAmount.text! = costDict["costAmount"] as! String
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
