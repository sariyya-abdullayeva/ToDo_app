//
//  CoreDataManager.swift
//  ToDo
//
//  Created by Sariyya Abdullayeva on 17.02.2025.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager() // Singleton instance
    private init() {} // Prevent direct initialization

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func saveCategory(_ category: Category) {
        do {
            try context.save()
        } catch {
            print("Error saving: \(error)")
        }
    }

    func fetchCategories() -> [Category] {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching: \(error)")
            return []
        }
    }

    func createCategory(name: String) -> Category {
        let newCategory = Category(context: context)
        newCategory.name = name
        return newCategory
    }
}
