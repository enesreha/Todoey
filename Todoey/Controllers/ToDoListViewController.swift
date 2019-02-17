//
//  ViewController.swift
//  Todoey
//
//  Created by Enes Reha GILBAZ on 2/12/19.
//  Copyright © 2019 Enes Reha GILBAZ. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newItem = Item()
        newItem.title = "Call the doctor"
        itemArray.append(newItem)
        
        let newItem2 = Item()
        newItem2.title = "Buy eggos"
        itemArray.append(newItem2)
        
        let newItem3 = Item()
        newItem3.title = "Go to movies"
        itemArray.append(newItem3)
        
        //here we try to retrieve data that we have stored in user defaults
        if let items = defaults.array(forKey: "ToDoListArray") as? [Item] {// if our ToDoListArray actually exist it's all good but if it doesn't our app will crash. So we get it in if let
            itemArray = items
        }
       
    }
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
  //This method gets called initially when the tableview gets loaded up.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      //  let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "ToDoItemCell")//we don't use this one because it will be a problem if we have let's say more than 10 cells. we need reuseable cells. otherwise our app will crash on memory pressure very fast.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        //In this line of code we're saying go and find that prototypr cell called ToDoItemCell inside Main.Storyboard and generate whole bunch of it that we can reuse. Because we reuse the cells when we check a cell and scroll down that checkmark appears again because it is the same cell. To avoid that we need to associate a property not with the cell but the data. In order to do that we need MVC.
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
         //This method (cellForRowAt) figures out how we should display each of the cells. We set the title property up and here we're gonna set the done property
        
        //Ternary Operator ===>
        //value = condition ? valueIfTrue : valueIfFalse
//
//        if item.done == true{
//            cell.accessoryType = .checkmark
//        }else{
//            cell.accessoryType = .none
//        }
        
   //This is the ternary operator of the if statement
        // cell.accessoryType = item.done == true ? .checkmark : .none
        //Even shorter
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }

    //MARK: - Tableview Delegate Methods
    //That method detects which row was selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //we want to set the done property to equal the opposite of what it used to be.
          itemArray[indexPath.row].done = !itemArray[indexPath.row].done
         
        //we need to get trigger the cellForRowAt method when we change the done property on our tableview. We do that with reloadDAta method. This method (reloadData) forces the tableview to call its datasource methods again and so it reloads the data.
        tableView.reloadData()
  
        tableView.deselectRow(at: indexPath, animated: true)//when we select a row it turns gray and stays like that. we don't want this. we want it to flash gray and than disappear
        
    }
    //MARK: - Add new items
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
       
        let alert = UIAlertController(title: "Add New ToDoey Item", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Add Item", style: UIAlertAction.Style.default) { (action) in
            //what will happen when the user clicks the Add Item button
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
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
    


