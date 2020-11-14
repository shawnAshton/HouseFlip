//
//  editCostsViewController.swift
//  HouseFlip
//
//  Created by Shawn Ashton on 11/12/20.
//

import UIKit

class editCostsViewController: UIViewController {
    var myDict:[String:Any] = [:]
    @IBAction func backFromEditCost(_ sender: Any) {
        self.performSegue(withIdentifier: "backFromEditCosts", sender: self)
    }
    
    @IBAction func updateCost(_ sender: Any) {
    }
    
    @IBAction func deleteCost(_ sender: Any) {
        self.performSegue(withIdentifier: "backFromEditCosts", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backFromEditCosts" {
            let destinationController = segue.destination as! costsViewController
            destinationController.myDict = myDict
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
