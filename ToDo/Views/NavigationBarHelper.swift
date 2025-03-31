//
//  NavigationBarHelper.swift
//  ToDo
//
//  Created by Sariyya Abdullayeva on 20.02.2025.
//

import UIKit

extension UIViewController {
    func setupNavigationBar(with color: UIColor) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = color
        appearance.shadowColor = nil

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
