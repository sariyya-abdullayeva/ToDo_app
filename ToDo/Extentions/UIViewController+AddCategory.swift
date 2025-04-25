//
//  UIViewController+AddCategory.swift
//  ToDo
//
//  Created by Sariyya Abdullah on 21.03.2025.
//

import UIKit

extension UIViewController {
    func presentAddCategoryAlert(onCategoryAdded: @escaping (String, String) -> Void) {
        let alert = UIAlertController(title: "New Category", message: "\n\n\n", preferredStyle: .alert)
        
        // Add text field for category name
        alert.addTextField { textField in
            textField.placeholder = "Category Name"
        }

        // Use color from CategoryColor mapping
        let colorOptions = CategoryColor.colorMapping.map { $0.color }
        let segmented = UISegmentedControl(items: colorOptions)
        
        // Set default selection
        if let defaultIndex = CategoryColor.colorMapping.firstIndex(where: { $0.name == CategoryColor.defaultColor }) {
            segmented.selectedSegmentIndex = defaultIndex
        } else {
            segmented.selectedSegmentIndex = 0
        }

        segmented.translatesAutoresizingMaskIntoConstraints = false
        alert.view.addSubview(segmented)

        // Auto Layout
        NSLayoutConstraint.activate([
            segmented.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 70),
            segmented.centerXAnchor.constraint(equalTo: alert.view.centerXAnchor),
            segmented.widthAnchor.constraint(equalToConstant: 250),
            segmented.heightAnchor.constraint(equalToConstant: 30)
        ])

        // Add button
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let rawName = alert.textFields?.first?.text else { return }
            let trimmedName = rawName.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedName.isEmpty else { return }

            let selectedColorName = CategoryColor.colorMapping[segmented.selectedSegmentIndex].name
            onCategoryAdded(trimmedName, selectedColorName)
        }

        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
}
