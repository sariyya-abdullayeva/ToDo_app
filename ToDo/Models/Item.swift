//
//  Item.swift
//  ToDo
//
//  Created by Sariyya Abdullayeva on 10.02.2025.
//

import Foundation

class Item: Codable {
    var title: String
    var done: Bool
    
    init(title: String, done: Bool = false) {
        self.title = title
        self.done = done
    }
}
