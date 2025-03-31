//
//  UIViewController+AddCategory.swift
//  ToDo
//
//  Created by Sariyya Abdullah on 21.03.2025.
//

import UIKit

extension UIViewController {
    func presentAddCategoryAlert(onCategoryAdded: @escaping (String) -> Void) {
        let alert = UIAlertController(title: "New Category", message: "Enter category name", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Category Name"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let categoryName = alert.textFields?.first?.text, !categoryName.isEmpty {
                onCategoryAdded(categoryName)
            }
        }
        
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}
