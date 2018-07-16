//
//  Category.swift
//  Todoey
//
//  Created by Willie Fatimehin on 7/15/18.
//  Copyright © 2018 Opia. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
