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
    
    func fetchCategories(limit: Int? = nil) -> [Category] {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        // Sort by `createdAt` in descending order (most recently used first)
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        // Apply fetch limit only if it is provided
        if let limit = limit {
            request.fetchLimit = limit
        }
        
        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching categories: \(error)")
            return []
        }
    }

    
    func fetchItems(for category: Category, limit: Int? = nil) -> [Item] {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        request.predicate = NSPredicate(format: "parentCategory == %@", category)
        

        if let limit = limit {
            request.fetchLimit = limit
        }

        do {
            return try context.fetch(request)
        } catch {
            print("Error fetching items: \(error)")
            return []
        }
    }
   

    func createCategory(name: String, colorName: String = CategoryColor.defaultColor) -> Category {
        let newCategory = Category(context: context)
        newCategory.name = name
        newCategory.colorName = colorName
        return newCategory
    }

//    func createCategory(name: String) -> Category {
//        let newCategory = Category(context: context)
//        newCategory.name = name
//        return newCategory
//    }
    
    func deleteCategory(_ category: Category) {
        context.delete(category)
        do {
            try context.save()
        } catch {
            print("Error deleting category: \(error)")
        }

    }

}
