//
//  AllCategoriesViewController.swift
//  ToDo
//
//  Created by Sariyya Abdullayeva on 07.03.2025.
//

import UIKit
import CHTCollectionViewWaterfallLayout
class AllCategoriesViewController: UIViewController {
    
    // MARK: - Properties
    private var collectionView: UICollectionView!
    
    // Data from db
    private var displayedCategories = [Category]()
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "All Categories"
        view.backgroundColor = .systemBackground
        
        setupCollectionView()
        loadCategories()
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        collectionView.addGestureRecognizer(longPress)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(with: .white)
        navigationController?.navigationBar.tintColor = .systemBlue
        loadCategories()
        
    }
    
    // MARK: - Data Handling
    private func loadCategories() {
        displayedCategories = CoreDataManager.shared.fetchCategories().reversed()
        for (index, category) in displayedCategories.enumerated() {
            let name = category.name ?? "Unnamed"
            let color = category.colorName ?? "nil"
            print("🧩 Category [\(index)]: \(name), color: \(color)")
        }
        collectionView.reloadData()
    }
    
    // MARK: - Setup Collection View
    private func setupCollectionView() {
            let layout = CHTCollectionViewWaterfallLayout() // ✅ Step 2: Use Waterfall layout
            layout.columnCount = 2
            layout.minimumColumnSpacing = 10
            layout.minimumInteritemSpacing = 10
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

            collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.backgroundColor = .clear
            collectionView.translatesAutoresizingMaskIntoConstraints = false

            // Register the new cell class
            collectionView.register(UINib(nibName: "CategoryGridCell", bundle: nil), forCellWithReuseIdentifier: CategoryGridCell.identifier)

            // Set delegates
            collectionView.dataSource = self
            collectionView.delegate = self

            // Add to view
            view.addSubview(collectionView)

            // Constraints
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    private func addCategory(name: String, colorName: String) {
        let newCategory = CoreDataManager.shared.createCategory(name: name, colorName: colorName)
            displayedCategories.append(newCategory)
            CoreDataManager.shared.saveCategory(newCategory)
            collectionView.reloadData()
    }
    
    
    @IBAction func addCategoryPressed(_ sender: UIBarButtonItem) {
        presentAddCategoryAlert { name, colorName in
                self.addCategory(name: name, colorName: colorName)
            }
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            let point = gesture.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: point) {
                let categoryToDelete = displayedCategories[indexPath.item]
                
                // Show confirmation alert
                let alert = UIAlertController(title: "Delete Category",
                                              message: "Are you sure you want to delete \"\(categoryToDelete.name ?? "this category")\"?",
                                              preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                    // Delete from Core Data
                    CoreDataManager.shared.deleteCategory(categoryToDelete)
                    
                    // Update local array + UI
                    self.displayedCategories.remove(at: indexPath.item)
                    self.collectionView.deleteItems(at: [indexPath])
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
                present(alert, animated: true)
            }
        }
    }
    
    
    // MARK: - Create Collection View Layout
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let itemInset: CGFloat = 8
        let numberOfColumns = 2
        
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            let availableWidth = environment.container.effectiveContentSize.width
            let totalSpacing = CGFloat((numberOfColumns + 1)) * itemInset
            let itemWidth = (availableWidth - totalSpacing) / CGFloat(numberOfColumns)
            
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .absolute(itemWidth),
                heightDimension: .estimated(150) // Dynamically sized
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: itemInset, leading: itemInset, bottom: itemInset, trailing: itemInset)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(150)
            )
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitems: [item]
            )
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 0
            section.contentInsets = NSDirectionalEdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0)
            
            return section
        }
        
        return layout
    }
}

// MARK: - UICollectionViewDataSource
extension AllCategoriesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryGridCell.identifier, for: indexPath) as! CategoryGridCell
        
        let category = displayedCategories[indexPath.item]
        
        // Fetch name
//        let rawName = category.name ?? "No Name"
//        let maxChars = 10
//        let trimmedName = rawName.count > maxChars ? String(rawName.prefix(maxChars)) + "..." : rawName
        let items = CoreDataManager.shared.fetchItems(for: category)
        
  
        // Fetch item count from relationship
        let itemCount = (category.items as? Set<Item>)?.count ?? 0
        
        
        // Configure cell with name and item count
//        cell.configure(with: trimmedName, taskCount: itemCount, items: items, colorName: category.colorName)
        
        cell.configure(with: category, taskCount: itemCount, items: items)

        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension AllCategoriesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCategory = displayedCategories[indexPath.item]
        performSegue(withIdentifier: "goToItemsFromAllCategories", sender: selectedCategory)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItemsFromAllCategories" {
            let destinationVC = segue.destination as! ToDoListViewController
            destinationVC.selectedCategory = sender as? Category
        }
    }
}


// ✅ Step 3: Conform to the layout delegate to provide item heights
extension AllCategoriesViewController: CHTCollectionViewDelegateWaterfallLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let category = displayedCategories[indexPath.item]
                let itemCount = (category.items as? Set<Item>)?.count ?? 0

                // 🆕 Dynamically calculate height based on item count
                let baseHeight: CGFloat = 100
                let extraHeightPerItem: CGFloat = 20

                let calculatedHeight = baseHeight + CGFloat(itemCount) * extraHeightPerItem
                return CGSize(width: 0, height: calculatedHeight)
    }
}
