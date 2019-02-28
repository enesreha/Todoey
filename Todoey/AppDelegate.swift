//
//  AppDelegate.swift
//  Todoey
//
//  Created by Enes Reha GILBAZ on 2/12/19.
//  Copyright © 2019 Enes Reha GILBAZ. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift
import Realm

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
//    print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
        //Locate where our Realm database is
        print(Realm.Configuration.defaultConfiguration.fileURL)//This is the location of the Realm file
      
        //Now we're gonna use realm to save new piece of data. Realm allows us to use OOP and persist objects. So now we're creating a new data object from Data class
        
        let data = Data()
        data.name = "Seyma"
        data.age = 33
        
        //Realms like different persistent containers.
        do{
            let realm = try Realm()
            try realm.write {//means commit the current state to persistent storage or to our Realm database
                realm.add(data)
            }
        }catch{
            print("Error initialising new realm \(error)")
        }
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
       
        //NSPersistentContainer is where we're gonna store all of our data. It's actually a SQLite database.
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
            
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    //This method saves our data when application gets terminated
    func saveContext () {
        let context = persistentContainer.viewContext // context is an area where we can change and update our data so we can undo and redo until we're happy with our data. And then we can save the data that's in the context or in the temporary area to the container which is for permenant storege. Context is similar to the staging area in Git.
        if context.hasChanges {
            do {
                try context.save()
            } catch {
               
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }


}

