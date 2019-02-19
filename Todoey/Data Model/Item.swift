//
//  Item.swift
//  Todoey
//
//  Created by Enes Reha GILBAZ on 2/15/19.
//  Copyright © 2019 Enes Reha GILBAZ. All rights reserved.
//

import Foundation

class Item : Codable{
    //Conforming the protocol Encodable means that the item type is now able to encode itself into a plist or inti JSON and for a class to be able to be encodable all of its propeties must have standard data types like string, integer, bool, array, dictionary etc. It can not have custom class.
    var title: String = ""
    var done : Bool = false
}
