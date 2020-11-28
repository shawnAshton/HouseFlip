//
//  AllTasksViewController.swift
//  HouseFlip
//
//  Created by Shawn Ashton on 11/27/20.
//

import UIKit
import Firebase //needed for casting item from dictionary to timestamp

class AllTasksViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, MyTableViewCellDelegate{

    
    @IBOutlet weak var myTableView: UITableView!
    var myTasks = [[String:Any]]()
    var indexOfTask = -1
    func didTapCell(with index: Int) {
        indexOfTask = index
        self.performSegue(withIdentifier: "allTasksToEditTask", sender: self)
    }
    
    //these 3 functions are for the tableview
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myTasks.count
    } //creates custom cells to fill the tableView
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyTableViewCell.indentifier, for: indexPath) as! MyTableViewCell
        //myTasks[indexPath.row] is a dictionary
        let tsDate = myTasks[indexPath.row]["dueDate"] as! Timestamp //gets the firestore timestamp
        let myDate:Date = tsDate.dateValue() //converts to a swift date object
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        var cellTitle:String = (myTasks[indexPath.row]["taskDescription"] as! String)
        if cellTitle.count > 30{
            cellTitle = cellTitle.prefix(30) + "..."
        }
        cellTitle = formatter.string(from: myDate) + "  " + cellTitle
        cell.configure(with: cellTitle, with: indexPath.row)
        cell.delegate = self
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTasks()
        myTableView.dataSource = self
        myTableView.register(MyTableViewCell.nib(), forCellReuseIdentifier: MyTableViewCell.indentifier)
        myTableView.delegate = self
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allTasksToEditTask" {
            let destinationController = segue.destination as! EditTasksViewController
            destinationController.taskDict = myTasks[indexOfTask]
            destinationController.fromAllTasks = true
        }
    }
    
    //This function loads the tasks into the tableView
    func loadTasks()
    {
        // if I want more accounts in future.. change collection name to accountName + "_tasks"
        db.collectionGroup("tasks").order(by: "dueDate").getDocuments() {
            snapshot, error in
            if let error = error {
                print("***************************************************\(error.localizedDescription)")
            }else{
                for document in snapshot!.documents{
                    let documentData = document.data()
                    self.myTasks.append(documentData)
                }
                
                DispatchQueue.main.async { //updates screen
                    self.myTableView.reloadData()
                }
            }
        }
    }
}


