//
//  CategoryColor.swift
//  ToDo
//
//  Created by Sariyya Abdullah on 01.04.2025.
//
import UIKit

struct CategoryColor {
    static let colorMapping: [(emoji: String, name: String)] = [
        ("🔵", "CategoryBlue"),
        ("🟢", "CategoryGreen"),
        ("🟡", "CategoryYellow"),
        ("🟣", "CategoryPurple")
    ]
    
    static var allColorNames: [String] {
        return colorMapping.map { $0.name }
    }

    static var allEmojis: [String] {
        return colorMapping.map { $0.emoji }
    }

    static var defaultColor: String {
        return colorMapping.first?.name ?? "CategoryBlue"
    }

    static func uiColor(for name: String) -> UIColor {
        return UIColor(named: name) ?? .white
    }
}
