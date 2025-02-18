//
//  CategoryCell.swift
//  ToDo
//
//  Created by Sariyya Abdullayeva on 14.02.2025.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil // Reset text to avoid data being reused incorrectly
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true  // Ensures content respects the rounded corners
        
        // Add shadow for floating effect
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 4, height: 4)
        layer.shadowRadius = 6
        layer.masksToBounds = false // Ensures shadow is visible
        
        // Background color
        contentView.backgroundColor = .white
        
        // Optional border
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
    }
    
    // MARK: - Configure Cell
    func configure(with category: Category) {
        titleLabel.text = category.name
    }
}
