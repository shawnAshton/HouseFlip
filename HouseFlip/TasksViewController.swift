//
//  TasksViewController.swift
//  HouseFlip
//
//  Created by Shawn Ashton on 10/30/20.
//

import UIKit
import Firebase //needed for casting item from dictionary to timestamp

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var myTableView: UITableView!
    var myDict:[String:Any] = [:]
    var myTasks = [[String:Any]]()
    var indexOfTask = -1
    
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
    
    @IBAction func goBackFromTasks(_ sender: Any) {
        self.performSegue(withIdentifier: "goBackFromTasks", sender: self)
    }
    
    @IBAction func createTask(_ sender: Any) {
        self.performSegue(withIdentifier: "tasksToCreateTask", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goBackFromTasks" {
            let destinationController = segue.destination as! HouseEditViewController
            destinationController.myDict = myDict
        }
        else if segue.identifier == "tasksToCreateTask" {
            let destinationController = segue.destination as! inputTaskViewController
            destinationController.myDict = myDict
        }
        else if segue.identifier == "toEditTasks" {
            let destinationController = segue.destination as! EditTasksViewController
            destinationController.myDict = myDict
            destinationController.taskDict = myTasks[indexOfTask]
        }
    }
    
    //This function loads the tasks into the tableView
    func loadTasks()
    {
        db.collection("ShawnTest").document(myDict["id"] as! String).collection("tasks").order(by: "dueDate").getDocuments() {
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

//gets the index of the specific cell that was tapped.
extension TasksViewController: MyTableViewCellDelegate{
    func didTapCell(with index: Int) {
        print("tapped \(index)")
        indexOfTask = index
        self.performSegue(withIdentifier: "toEditTasks", sender: self)
    }
}
