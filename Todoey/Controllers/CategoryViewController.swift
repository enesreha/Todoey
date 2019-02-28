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
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()

    }


   
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
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
//        
//        let request: NSFetchRequest<Category> = Category.fetchRequest()//To be able to read data from our context we need to specify a request of a data type of NSFetchRequest that is going to return an array of Category items. And this is going to be equal to a broad request. So we want to grab all of the category objects. By saying = Category.fetchRequest(), we get back all the NSManagedObjects that were created using the Category entity
//        
//        do{
//        categoryArray = try context.fetch(request)//if fetching our request succeeds then we're going to save the output or whatever gets returned from this method into our categoryArray
//        }catch{
//          print("Error fetching data from context \(error)")
//        }
//        tableView.reloadData()
    }
    
    
    //MARK: - Add New Categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
            self.categoryArray.append(newCategory)
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
