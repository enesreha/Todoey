//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Enes Reha GILBAZ on 2/20/19.
//  Copyright © 2019 Enes Reha GILBAZ. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    //First we need to initialize a new Realm
    let realm = try! Realm()
    
    var categories: Results<Category>? //(The property "categories" is what we're going to get back when we query our database). Results is a container type comes from RealmSwift and it's equivalent to List or Array. Results is an auto-updating container type in Realm returned from object queries. That means whenever we try to query our database the results we get back is in the form of a Results object. And because it's an auto-updating container type we don't need to append objects to categories. It will do that automatically.
   
    override func viewDidLoad() {
        super.viewDidLoad()
     loadCategories()

    }


   
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1 //if categories is not nil then return the count of it (categories.count) but if it was nil then return 1. This statement called "Nil Coalescing Operator"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet" //It means that if categories is not nil then we're going to get the item at the indexPath.row and we're gonna grab the name property, but if it is nil then we're simply gonna say the text is gonna be equal to "No categories added yet"
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    //MARK: - Data Manipulation Methods
    func save(category : Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saving categories \(error)")
        }
        tableView.reloadData()
    }
    func loadCategories(){
        //We're gonna read from our Realm database in this method
        
        categories = realm.objects(Category.self)//this will pull out all of the items inside our Realm that are of Category objects. The data type that we get back here is Results containing whole bunch of Categories.

        tableView.reloadData()//reloadData calles the tableView datasource methods again.
    }
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            
            //in here before we were appending our array but in here our categories is REsults data type and it is auto updating container and so now we don't have to append. It will simple auto update and monitor for those changes.
            
            self.save(category: newCategory)
         }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
