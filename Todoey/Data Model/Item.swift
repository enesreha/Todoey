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
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")//LonkingObjects is an auto-updating container type. It represents zero or more objects that are linked to its owning model object through a property relationship. It's simply defining the inverse relationship of items. Each category has a one to many relationship with a list of items and each item has an inverse relationship to a category called the parentCategory. Each item has a parentCategory that is of type Category and it comes from that property called "items". (if we just write Category it's not a type it is a class but if we write Category.self it becomes a type)
}
