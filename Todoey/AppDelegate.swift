//
//  AppDelegate.swift
//  Todoey
//
//  Created by Enes Reha GILBAZ on 2/12/19.
//  Copyright © 2019 Enes Reha GILBAZ. All rights reserved.
//

import UIKit
import RealmSwift
import Realm

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        //Realm dosyasinin konumu
    print(Realm.Configuration.defaultConfiguration.fileURL)
        
        //Realms like different persistent containers.
        do{
            _ = try Realm()//we're initializing our new realm but because we don't use the realm object we put underscore(_) instead of the (realm) and deleting the let keyword as well
        }catch{
            print("Error initialising new realm \(error)")
        }
        
        return true
    }




}

