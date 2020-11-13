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
    @IBOutlet weak var categorySelector: UISegmentedControl!
    
    //create array of empty houses
    var houseArrays = [[House]]()
    var indexOfHouse = -1
    var categoryOfHomes:Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryOfHomes = 3
        categorySelector.selectedSegmentIndex = categoryOfHomes
        db = Firestore.firestore()
        loadHouses()
        print("TELLOOOOOOOOOO FROM THE OTHER SIDEEEEEEEE \(self.houseArrays[3].count)")

        myTableView.dataSource = self
        //creates some custom cells
        myTableView.register(MyTableViewCell.nib(), forCellReuseIdentifier: MyTableViewCell.indentifier)
        myTableView.delegate = self
    }
        
    //This function loads the addresses into a TableView for the user
    func loadHouses()
    {
        for _ in 0...3 {
            self.houseArrays.append([House]())
        }
        db.collection("ShawnTest").order(by: "address").getDocuments() {
            snapshot, error in
            if let error = error {
                print("***************************************************\(error.localizedDescription)")
            }else{
                //fills the house array with documents from the database
                self.houseArrays[3] = snapshot!.documents.compactMap({House(dictionary: $0.data())})
                self.populateAllHouseArrays()
                //print("YELLOOOOOOOOOO FROM THE OTHER SIDEEEEEEEE \(self.houseArrays[3].count)")
                DispatchQueue.main.async { //updates screen
                    self.myTableView.reloadData()
                }
            }
        }
    }

    func populateAllHouseArrays(){
        //print("HELLOOOOOOOOOO FROM THE OTHER SIDEEEEEEEE \(self.houseArrays[3].count)")
        for home in self.houseArrays[3]{
            //print("HELLOOOOOOOOOO FROM THE INNER SIDEEEEEEEE")
            if home.dictionary["category"] as! Int == 0 {
                houseArrays[0].append(home)
                //print("Ggggeeetttttttinngg thererrreererere")
            }
            else if home.category == 1 {
                //print("Ggggeeetttttttinngg thererrreererere")
                houseArrays[1].append(home)
            }
            else if home.category == 2 {
                //print("Ggggeeetttttttinngg thererrreererere")
                houseArrays[2].append(home)
            }
        }
        
    }
    
    //these 3 functions are for the tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return houseArrays[categoryOfHomes].count
    } //creates custom cells to fill the tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.indentifier, for: indexPath) as! MyTableViewCell
        let home = houseArrays[categoryOfHomes][indexPath.row]
        cell.configure(with: "\(home.address)", with: indexPath.row)
        cell.delegate = self
        return cell
    }
    
    @IBAction func changeCustomView(_ sender: UISegmentedControl) {
        categoryOfHomes = sender.selectedSegmentIndex
        myTableView.reloadData()
    }
    
    
//helps pass information from this view controller to another
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewHouseSegue" {
            let destinationController = segue.destination as! HouseEditViewController
            destinationController.myDict = houseArrays[categoryOfHomes][indexOfHouse].dictionary
        }
    }
}//gets the index of the specific cell that was tapped.
extension ViewController: MyTableViewCellDelegate{
    func didTapCell(with index: Int) {
        indexOfHouse = index
        self.performSegue(withIdentifier: "ViewHouseSegue", sender: self)
    }
}

//hides keyboard on tap out of selection
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
