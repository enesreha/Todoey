//
//  ViewController.swift
//  Todoey
//
//  Created by Enes Reha GILBAZ on 2/12/19.
//  Copyright © 2019 Enes Reha GILBAZ. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    //MARK: - Constants and Variables
    var itemArray = [Item]()
    var selectedCategory:Category? {//we set it optional because it's going to be nil until we set it. After we set the selectedCategory we're gonna loadItems
        didSet{//everything that's between these curly braces is going to happen as soon as selectedCategory gets set with a value (we give it a value in CategoryViewController). That's because we call the loadItems method here
       //     loadItems()
            
        }
    }
     let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext// we're tapping into the UIApplication class. We're getting the shared singleton object which corresponds to the current app as an object. We're tapping into its delegate which has the data type of an optional UIApplicationDelegate. We're casting it into our class AppDelegate because they both inherit from the same superclass UIApplicationDelegate. And now we have access to our AppDelegate as an object. So we're able to tap into its property called persistentContainer and we're going to grab the viewContext of that persistentContainer.
    
    //MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: - viewDidLoad Method
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
     //   searchBar.delegate = self
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
        
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
         
//        //we need to get trigger the cellForRowAt method when we change the done property on our tableview. We do that with reloadDAta method. This method (reloadData) forces the tableview to call its datasource methods again and so it reloads the data.
//        tableView.reloadData()
  
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //MARK: - Add new items
    @IBAction func barButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
       
        let alert = UIAlertController(title: "Add New ToDoey Item", message: "", preferredStyle: UIAlertController.Style.alert)
        
        let action = UIAlertAction(title: "Add Item", style: UIAlertAction.Style.default) { (action) in
            //what will happen when the user clicks the Add Item button
//
//            let newItem = Item(context: self.context)
//            newItem.title = textField.text!
//            newItem.done = false
//            newItem.parentCategory = self.selectedCategory
//            self.itemArray.append(newItem)
//
//
            self.saveItems()
    
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
            
        }
    
    //MARK: - Model Manupulation Methods
    
    func saveItems(){
       //Here we need to be able to commit our context to permanent storage inside our persistentContainer. In order to do that we need to call try context.save(). And that basically transfers what's currently inside our staging area (context) to our permanent data storage.
        
        //Here we set up the code to use Core Data for saving our new items that have been added using UIAlert
        do{
            try context.save()
        }catch{
            print("Error saving context \(error)")
        }
        
        
        self.tableView.reloadData()
    }
    //Here 'with' is an external parameter, 'request' is internal parameter. The internal parameter (request) is gonna be used in the blocks of this function and the external parameter (with) is going to be used when we called the function
//    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
//        //By saying (with request : NSFetchRequest<Item> = Item.fetchRequest()), we're giving a default value. So if don't provide a value for the request it's gonna use the default value.
//        //This is going to fetch results in the form of Item. This request is basically just a blank request that pulls back everything that's currently inside our persistentContainer.
//
//        //Our items come from itemArray and itemArray comes from loadItems method which simply fetches all of the NSManagedObjects that belong in the item table or item entity. But in order for us to only load the items that have the parentCategory matching the selectedCategory we need to query our database for it and we need to filter the result. In order to do that we create a predicate. We initialize the predicate with the format that the parentCategory of all the items that we want back must have its name property matching the current selectedCategory's name. Then we need to add this predicate to the request.
//        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
//
//        if let additionalPredicate = predicate{
//            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
//        }else{
//            request.predicate = categoryPredicate
//        }
//
//        //Our application has to speak with context before we can do anything with our persistentContainer
//        do{
//        itemArray = try context.fetch(request)//The output of this method is going to be an array of Items that is storred in our persistentContainer.
//        }catch{
//            print("Error fetching data from context \(error)")
//        }
//        tableView.reloadData()
//    }
//
//
    }

//MARK: - SearchBar Methods
//extension ToDoListViewController: UISearchBarDelegate{
//
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        //In order to read from the context we have to create a request
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//        //In order to query objects using CoreData we need to use something called NSPredicate
//       let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)//we're going to look at title attribute of each of our items in itemArray and we're going to check that it contains a value (the other parameter argument is that we're going to substitute into this %@ sign). Argument is gonna be what wrote in the searchBar.
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        //now we're gonna run our request and fetch our results
//       loadItems(with: request, predicate: predicate)
//
//    }
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0 {
//            loadItems()
//
//            //DispatchQueue is the manager who assigns projects to different threads. We're asking it to garb us the main thread.
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//
//        }
//    }
//}



