//
//  ViewController.swift
//  Todoey
//
//  Created by Enes Reha GILBAZ on 2/12/19.
//  Copyright © 2019 Enes Reha GILBAZ. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = ["Call the doctor", "Buy green tea", "Work for 5 hours"]
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = defaults.array(forKey: "ToDoListArray") as? [String] {// if our ToDoListArray actually exist it's all good but if it doesn't our app will crash. So we get it in if let
            itemArray = items
        }
    }
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      //  let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "ToDoItemCell")//we don't use this one because it will be a problem if we have let's say more than 10 cells. we need reuseable cells. otherwise our app will crash on memory pressure very fast.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }

    //MARK: - Tableview Delegate Methods
    //That method detects which row was selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  print(itemArray[indexPath.row])
        
        //We want to give a checkmark as an accessory to our cell when we click on it
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {// cellForRow(at: indexPath) grabbes a reference to the cell that is at a particular index path. This line of code means that the cell at this indexpath in our tableview is going to have an accessory type of checkmark. Here we say add a checkmark whenever a cell has been selected
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)//when we select a row it turns gray and stays like that. we don't want this. we want it to flash gray and than disappear
        
    }
    
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
       
        let alert = UIAlertController(title: "Add New ToDoey Item", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Add Item", style: UIAlertAction.Style.default) { (action) in
            //what will happen when the user clicks the Add Item button
           
            self.itemArray.append(textField.text!)
            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
            //Userdefaults gets saved in plist file. Thats because everything we put in here has to be a key value pair. We add the item under a key and the we garb it back by using this key. In order to find where are our user defaults file we need to grab the file path our our sand box (every app lives in a sand box) that our app runs. We need the get the ID of the simulator and also we need the ID of the sandbox where our app lives in. In order to do that we go to didFinishLaunchingWithOptions method in AppDelegate
            //When we add new item it doens't show up in our list because we haven't used it to retrieve the data. In order to do that we go to viewDidLoad
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
            
        }
    }
    


