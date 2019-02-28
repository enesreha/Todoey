//
//  Category.swift
//  Todoey
//
//  Created by Enes Reha GILBAZ on 2/28/19.
//  Copyright © 2019 Enes Reha GILBAZ. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
 @objc dynamic var name: String = ""
    
    //We're gonna create a constant called items and it's gonna hold a list of item objects. And we're gonna initialize it as an empty list.
    //This defines the forward relationship i.e. inside each Category there's this thing called items that's going to point to a list of Item objects. In Realm inverse relationship is not defined automatically. Instead we have to go to Item class and create it ourselves. Each category has a one to many relationship with a list of items and each item has an inverse relationship to a category called the parentCategory.
    let items = List<Item>()
    
    
}
