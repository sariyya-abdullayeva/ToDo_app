//
//  CategoryCell.swift
//  ToDo
//
//  Created by Sariyya Abdullayeva on 14.02.2025.
//

import UIKit

class CategoryCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var todoTableView: UITableView!
    
    private var items: [Item] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
        setupTableView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        contentView.alpha = 1.0
        items.removeAll()
        todoTableView.reloadData()
    }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 15
        contentView.layer.masksToBounds = true
        
        //Top Glow Effect
        contentView.layer.borderColor = UIColor(white: 1.0, alpha: 1).cgColor // Adjust opacity for glow effect
        contentView.layer.borderWidth = 5 // Adjust thickness
        
        // Make table view background transparent
        todoTableView.backgroundColor = .clear
        todoTableView.isOpaque = false
        //        todoTableView.separatorStyle = .none // Optional: Hide separators for cleaner look
    }
    
    private func setupTableView() {
        todoTableView.delegate = self
        todoTableView.dataSource = self
        todoTableView.register(UITableViewCell.self, forCellReuseIdentifier: "ItemCell")
    }
    
    func configure(with category: Category, index: Int, totalCount: Int, items: [Item]) {
        titleLabel.text = category.name
        titleLabel.font = UIFont(name: "Nunito-SemiBold", size: 24)
        
        
        self.items = items
        todoTableView.reloadData()
        
        let colors: [UIColor] = [
            UIColor(red: 123/255, green: 211/255, blue: 234/255, alpha: 1.0),
            UIColor(red: 161/255, green: 238/255, blue: 189/255, alpha: 1.0),
            UIColor(red: 246/255, green: 247/255, blue: 196/255, alpha: 1.0),
            UIColor(red: 246/255, green: 214/255, blue: 214/255, alpha: 1.0)
        ]
        
        contentView.backgroundColor = colors[index % colors.count]
        
        let opacityStep: CGFloat = 0.25
        contentView.alpha = 1.0 - (CGFloat(totalCount - 1 - index) * opacityStep)
    }
    
    // MARK: - UITableView DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        cell.textLabel?.textColor = item.done ? .lightGray : .black
        cell.accessoryType = item.done ? .checkmark : .none
        
        // Add left padding
        let leftPadding: CGFloat = 12
        let insets = UIEdgeInsets(top: 0, left: leftPadding, bottom: 0, right: 0)
        
        cell.layoutMargins = insets
        cell.contentView.layoutMargins = insets
        cell.separatorInset = insets
        cell.preservesSuperviewLayoutMargins = false
        
        
        
        // Make cell background transparent
        cell.backgroundColor = .clear
        cell.isOpaque = false
        
        // Disable selection effect (prevent turning gray)
        cell.selectionStyle = .none
        return cell
    }
    
}
