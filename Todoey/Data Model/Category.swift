//
//  Category.swift
//  Todoey
//
//  Created by d.genkov on 9/13/18.
//  Copyright © 2018 d.genkov. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var cellColor: String = ""
    let items = List<Item>()
    
    
}
