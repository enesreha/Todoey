//
//  Item.swift
//  Todoey
//
//  Created by Enes Reha GILBAZ on 2/28/19.
//  Copyright © 2019 Enes Reha GILBAZ. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")//each item has a parentCategory that is of type Category and it comes from that property called "items"
}
