//
//  Data.swift
//  Todoey
//
//  Created by Enes Reha GILBAZ on 2/28/19.
//  Copyright © 2019 Enes Reha GILBAZ. All rights reserved.
//

import Foundation
import RealmSwift

//Object is a class that's used to define Realm model objects and we're subclassing it here. So it's a super class that we're going to use to enable us to persist our Data class.

class Data: Object{
    //Under any normal conditions if we weren't subclassing Object and we were just creating a new class to represent our data then this would be fine. However because we're using Realm we actually need to mark our variables with the keyword dynamic. Dynamic is a declaration modifier. It basically tells the runtime to use dynamic dispatch over the standart which is a statis dispatch. And this basically  allows this property "name" to be monitored for change at runtime. That means if the user changes the value of "name" while the app is running then that allows Realm to dynamically update those changes in the database. But dynamic dispatch is something that actually comes from the Objective C API. Basically we're using dynamic keyword so Realm can monitor for changes in the value of this property.
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
