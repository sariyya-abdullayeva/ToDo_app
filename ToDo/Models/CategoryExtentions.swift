//
//  CategoryExtentions.swift
//  ToDo
//
//  Created by Sariyya Abdullayeva on 20.02.2025.
//

import Foundation
import CoreData

extension Category {
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        self.createdAt = Date() // Auto-sets timestamp when a new category is created
    }
}
