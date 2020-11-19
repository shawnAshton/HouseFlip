//
//  costsViewController.swift
//  HouseFlip
//
//  Created by Shawn Ashton on 11/12/20.
//

import UIKit
import Firebase

class costsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MyTableViewCellDelegate {

    @IBOutlet weak var totalInvestments: UITextView!
    @IBOutlet weak var myTableView: UITableView!
    var myDict:[String:Any] = [:]
    var myCosts = [[String:Any]]()
    var indexOfCost = -1
    var totalInvestmentsVar = 0.0
    
    func didTapCell(with index: Int) {
        print("tapped \(index)")
        indexOfCost = index
        self.performSegue(withIdentifier: "toEditCosts", sender: self)
        
    }

    @IBAction func backFromCosts(_ sender: Any) {
        self.performSegue(withIdentifier: "backFromCosts", sender: self)
    }
    
    @IBAction func toAddCosts(_ sender: Any) {
        self.performSegue(withIdentifier: "toAddCost", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backFromCosts"{
            let destinationController = segue.destination as! HouseEditViewController
            destinationController.myDict = myDict
        }
        else if segue.identifier == "toAddCost" {
            let destinationController = segue.destination as! inputCostsViewController
            destinationController.myDict = myDict
        }
        else if segue.identifier == "toEditCosts" {
            let destinationController = segue.destination as! editCostsViewController
            destinationController.myDict = myDict
            destinationController.costDict = myCosts[indexOfCost]
        }
        
    }
    //This function loads the tasks into the tableView
    func loadCosts()
    {
        totalInvestmentsVar = 0.0
        db.collection("ShawnTest").document(myDict["id"] as! String).collection("costs").order(by: "costAmount").getDocuments() {
            snapshot, error in
            if let error = error {
                print("***************************************************\(error.localizedDescription)")
            }else{
                for document in snapshot!.documents{
                    //create Dict of costs
                    let documentData = document.data()
                    self.myCosts.append(documentData)
                    //create total of costs
                    self.totalInvestmentsVar += Double(documentData["costAmount"] as! String)!
                    print("loadingCosts - \(self.totalInvestmentsVar)")
                    //self.totalInvestments.text = String(self.totalInvestmentsVar)
                }
                DispatchQueue.main.async { //updates screen
                    self.totalInvestments.text = "$\(self.totalInvestmentsVar)"
                    self.myTableView.reloadData()
                }
            }
        }
    }
    
    
    //these 3 functions are for the tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCosts.count
    } //creates custom cells to fill the tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.indentifier, for: indexPath) as! MyTableViewCell

        var cellTitle:String = (myCosts[indexPath.row]["costDescription"] as! String)
        if cellTitle.count > 30{
            cellTitle = cellTitle.prefix(30) + "..."
        }
        cellTitle = "$" + (myCosts[indexPath.row]["costAmount"] as! String) + " - " + cellTitle
        cell.configure(with: cellTitle, with: indexPath.row)
        cell.delegate = self
        return cell
    }

    override func viewDidLoad() {
        loadCosts()
        myTableView.dataSource = self
        myTableView.register(MyTableViewCell.nib(), forCellReuseIdentifier: MyTableViewCell.indentifier)
        myTableView.delegate = self
        super.viewDidLoad()
    }

}
