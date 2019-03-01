//
//  ViewController.swift
//  Todoey
//
//  Created by Enes Reha GILBAZ on 2/12/19.
//  Copyright © 2019 Enes Reha GILBAZ. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController {
    
    //MARK: - Constants and Variables
    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory:Category? {//we set it optional because it's going to be nil until we set it. After we set the selectedCategory we're gonna loadItems
        didSet{//everything that's between these curly braces is going to happen as soon as selectedCategory gets set with a value (we give it a value in CategoryViewController). That's because we call the loadItems method here
          loadItems()
            
        }
    }
   
    //MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
      searchBar.delegate = self
      }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
  //This method gets called initially when the tableview gets loaded up.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      //  let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "ToDoItemCell")//we don't use this one because it will be a problem if we have let's say more than 10 cells. we need reuseable cells. otherwise our app will crash on memory pressure very fast.
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        //In this line of code we're saying go and find that prototypr cell called ToDoItemCell inside Main.Storyboard and generate whole bunch of it that we can reuse. Because we reuse the cells when we check a cell and scroll down that checkmark appears again because it is the same cell. To avoid that we need to associate a property not with the cell but the data. In order to do that we need MVC.
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }else{
         cell.textLabel?.text = "No items added"
        }
        
        return cell
    }

    //MARK: - Tableview Delegate Methods
    //That method detects which row was selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     //This is where we update our data. In here we select our cell to check or uncheck it
        
        if let item = todoItems?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            }catch{
                print("Error saving done status \(error)")
            }
        }
        
        //We delete items from Realm in here too.
//        if let item = todoItems?[indexPath.row]{
//            do{
//                try realm.write {
//                   realm.delete(item)
//                }
//            }catch{
//                print("Error deleting item \(error)")
//            }
//        }
        
        
        
        
        
        tableView.reloadData()// it calls the cellForRowAt method and it update the checkmark or no checkmark accessorytype
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //MARK: - Add new items
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
       
        let alert = UIAlertController(title: "Add New ToDoey Item", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Add Item", style: UIAlertAction.Style.default) { (action) in
            //what will happen when the user clicks the Add Item button

            if let currentCategory = self.selectedCategory{
                do{
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()//every new item that we create gets stamped with the current date and time
                  
                    currentCategory.items.append(newItem)//It means that if selectedCategory is not nil then go to currentCategory's items property which is a List and append the newItem to that List.
                }
                }catch{
                    print("Error saving new items \(error)")
                }
                
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
            
        }
    
    //MARK: - Model Manupulation Methods
   func loadItems(){
       
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)//All of the items that belong to the current selectedCategory will be sorted by keyPAth and ascending(alphabetically). In keyPAth it'll be sorted by the title of each item.

        tableView.reloadData()//we reload our tableview to call the tableview datasource methods
    }


    }

//MARK: - SearchBar Methods
extension ToDoListViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //When our serachBar gets clicked we want to filter our todoItems
//        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
     

    }
    //What should happen when we dismiss the searchbar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            //DispatchQueue is the manager who assigns projects to different threads. We're asking it to garb us the main thread.
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }
}



