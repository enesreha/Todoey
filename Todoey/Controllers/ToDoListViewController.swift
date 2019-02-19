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
    //We're going to create a file path to the document folder
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    //This line of code means : default file manager is a shared file manager object. It's a singleton and this singleton contains a whole bunch of urls and they are organized by directory and domainmask. The search directory we need to tap into is the document directory. The location where we're gonna look for it is inside the userdomainmask. This is the user's home directory, the place where we're going to save their personal items associated with this current app. And because of this is an array we're going to grab its first item
    
  //  let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        print(dataFilePath)//when we follow this path we find a plist. This plist represent NSUserDefaults.
        //Inside our app instead of using NSUserDEfaults we're going to create our very own plist file. In order to do that we go to our dataFilePath and use appoendingPathComponent method. With this method we've merely created a path to this new plist that we're going to create. So now instead of using Userdefaults we're gonna create our own plist at the location of our dataFilePath.

        
        loadItems()
        

       
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
        saveItems()
         
//        //we need to get trigger the cellForRowAt method when we change the done property on our tableview. We do that with reloadDAta method. This method (reloadData) forces the tableview to call its datasource methods again and so it reloads the data.
//        tableView.reloadData()
  
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
           
//            self.defaults.set(self.itemArray, forKey: "ToDoListArray")
//            //when we're trying to save an array of custom objects (here Item objects) we're misusing user defaults. It crashes our app so we need to find some other way to do that. Because user defaults is for small piece of data for limited set of data types.
//            //(Userdefaults is a property list. It has whole bunch of key value pairs.)Userdefaults gets saved in plist file. Thats because everything we put in here has to be a key value pair. We add the item under a key and the we garb it back by using this key. In order to find where are our user defaults file we need to grab the file path our our sand box (every app lives in a sand box) that our app runs. We need the get the ID of the simulator and also we need the ID of the sandbox where our app lives in. In order to do that we go to didFinishLaunchingWithOptions method in AppDelegate
//            //When we add new item it doens't show up in our list because we haven't used it to retrieve the data. In order to do that we go to viewDidLoad
            
            self.saveItems()
    
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
            
        }
    func saveItems(){
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(itemArray)
            //encoder will encode our data namely our itemArray into a property list.
            try data.write(to: dataFilePath!)
            
        }catch{
            print("Error encoding item array, \(error)")
        }
        
        
        self.tableView.reloadData()
    }
    
    func loadItems(){
        //We're going to tap into our data by creating a constant called data.
       
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
            itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("Error decoding item array, \(error)")
            }
        }
            
        
       
    }
    }
    


