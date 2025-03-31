//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Sariyya Abdullayeva on 14.02.2025.

import UIKit

class CategoryViewController: UIViewController {
    // MARK: - Properties
    private var displayedCategories = [Category]() // Categories currently visible
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addButton: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        setupButtons()
        loadCategories()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(with: .white)
        loadCategories()
    }
    
    // MARK: - UI Setup
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: "CategoryCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "CategoryCell")
        
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func setupButtons() {
        addButton.layer.cornerRadius = 0.5 * addButton.bounds.size.width
        addButton.clipsToBounds = true
    }
    
    // MARK: - Collection View Layout
    private func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, environment -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(350))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = -300 // Adjust for more/less overlap
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
            
            return section
        }
    }
    
    
    // MARK: - Data Handling
    private func loadCategories() {
        displayedCategories = CoreDataManager.shared.fetchCategories(limit: 4).reversed()
        collectionView.reloadData()
    }
    
    private func addCategory(name: String) {
        let newCategory = CoreDataManager.shared.createCategory(name: name)
        displayedCategories.append(newCategory)
        CoreDataManager.shared.saveCategory(newCategory)
        
        collectionView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func addButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "New Category", message: "Enter category name", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Category Name"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let categoryName = alert.textFields?.first?.text, !categoryName.isEmpty {
                self.addCategory(name: categoryName)
            }
        }
        
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }
    
    
}

// MARK: - UICollectionViewDataSource & UICollectionViewDelegate
extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        
        let category = displayedCategories[indexPath.item]
        var items: [Item] = []
        if indexPath.item == displayedCategories.count - 1 { // Only pass Items for the front-most card
            items = CoreDataManager.shared.fetchItems(for: category, limit: 4)
        }
        
        cell.configure(with: category, index: indexPath.item, totalCount: displayedCategories.count, items: items)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = displayedCategories[indexPath.item]
        selectedCategory.createdAt = Date()
        CoreDataManager.shared.saveCategory(selectedCategory)
        displayedCategories = CoreDataManager.shared.fetchCategories(limit: 4).reversed() // Refresh order based on recent selection
        collectionView.reloadData()
        
        performSegue(withIdentifier: "goToItemsFromCategory", sender: selectedCategory)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItemsFromCategory" {
            let destinationVC = segue.destination as! ToDoListViewController
            destinationVC.selectedCategory = sender as? Category
        }
    }
}

