//
//  ViewController.swift
//  HouseFlip
//
//  Created by Shawn Ashton on 9/22/20.
//
import UIKit
import Firebase
var db:Firestore!

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var myTableView: UITableView!
    //create array of empty houses
    var houseArray = [House]()
    var indexOfHouse = -1
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.dataSource = self
        //creates some custom cells
        myTableView.register(MyTableViewCell.nib(), forCellReuseIdentifier: MyTableViewCell.indentifier)
        myTableView.delegate = self
        db = Firestore.firestore()
        loadHouses()
    }
    
    //these 3 functions are for the tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houseArray.count
    } //creates custom cells to fill the tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.indentifier, for: indexPath) as! MyTableViewCell
        let home = houseArray[indexPath.row]
        cell.configure(with: "\(home.address)", with: indexPath.row)
        cell.delegate = self
        //cell.textLabel!.text = "\(indexPath.row). \(home.address)"
        return cell
    }
    
    //This function loads the addresses into a TableView for the user
    func loadHouses()
    {
        db.collection("ShawnTest").getDocuments() {
            snapshot, error in
            if let error = error {
                print("\(error.localizedDescription)")
            }else{
                //fills the house array with documents from the database
                self.houseArray = snapshot!.documents.compactMap({House(dictionary: $0.data())})
                DispatchQueue.main.async { //updates screen
                    self.myTableView.reloadData()
                }
            }
        }
    }
    //helps pass information from this view controller to another
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewHouseSegue" {
            let destinationController = segue.destination as! HouseEditViewController
            destinationController.myDict = houseArray[indexOfHouse].dictionary
        }
    }
}//gets the index of the specific cell that was tapped.
extension ViewController: MyTableViewCellDelegate{
    func didTapCell(with index: Int) {
        indexOfHouse = index
        print(index)
        self.performSegue(withIdentifier: "ViewHouseSegue", sender: self)
    }
}
