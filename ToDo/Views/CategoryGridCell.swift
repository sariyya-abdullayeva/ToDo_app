//
//  CategoryGridCell.swift
//  ToDo
//
//  Created by Sariyya Abdullayeva on 07.03.2025.
//

import UIKit

class CategoryGridCell: UICollectionViewCell {
    static let identifier = "CategoryGridCell"
    @IBOutlet weak var taskIcon: UIImageView!
    @IBOutlet weak var taskName: UILabel!
    @IBOutlet weak var taskLeft: UILabel!
    @IBOutlet weak var contentStackView: UIStackView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
    }
    
    func configure(with category: Category, taskCount: Int, items: [Item]) {
        taskName.text = category.name ?? "No Name"
        taskLeft.text = "\(taskCount)"
        print("🧩 Configuring Category Cell → Name: \(category.name ?? "No Name"), Color: \(category.colorName ?? "nil"), Tasks: \(taskCount)")

        let itemTitles = items.map { $0.title ?? "Unnamed" }
        print("🧩 Configuring Category Cell → Name: \(category.name ?? "No Name"), Color: \(category.colorName ?? "nil"), Tasks: \(taskCount), Items: \(itemTitles)")

        // 🌈 Apply background color from Core Data
        let colorName = category.colorName ?? CategoryColor.defaultColor
        contentView.backgroundColor = CategoryColor.uiColor(for: colorName)

        // Clean old item views
        contentStackView.arrangedSubviews
            .filter { $0.tag == 99 }
            .forEach {
                contentStackView.removeArrangedSubview($0)
                $0.removeFromSuperview()
            }

        // Add items
        for item in items {
            let label = UILabel()
            label.text = "- \(item.title ?? "")"
            label.font = UIFont(name: "Nunito-Regular", size: 14)
            label.textColor = item.done ? .lightGray : .darkText
            label.tag = 99
            contentStackView.addArrangedSubview(label)
        }
    }

    private func setupStyle() {
        // Label styles
        taskName.lineBreakMode = .byTruncatingTail
        taskName.numberOfLines = 1
        taskName.font = UIFont(name: "Nunito-SemiBold", size: 16)
        taskLeft.font = UIFont(name: "Nunito-Regular", size: 14)
        
        // Stack View padding
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)

        
        // Card styling
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .white


        
        // Shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.15
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
        layer.masksToBounds = false
    }
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        let targetSize = CGSize(width: attributes.frame.width, height: UIView.layoutFittingCompressedSize.height)
        let autoLayoutSize = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        attributes.frame.size.height = autoLayoutSize.height
        return attributes
    }

    
}
