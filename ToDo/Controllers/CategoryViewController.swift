//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Sariyya Abdullayeva on 14.02.2025.
//

import UIKit

class CategoryViewController: UIViewController {
    // MARK: - Properties
    var categories = [Category]()

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addButton: UIButton!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Tasks"

        setupCollectionView()
        setupButtons()
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
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)

            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(150))
            let columns = environment.container.contentSize.width > 500 ? 2 : 1

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: Array(repeating: item, count: columns))
            group.interItemSpacing = .fixed(20)

            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 20
            section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)

            return section
        }
    }

    // MARK: - Data Handling
    private func loadCategories() {
        categories = CoreDataManager.shared.fetchCategories()
        collectionView.reloadData()
    }

    private func addCategory(name: String) {
        let newCategory = CoreDataManager.shared.createCategory(name: name)
        categories.append(newCategory)
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
        return categories.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCell
        cell.configure(with: categories[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: categories[indexPath.row])
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToItems" {
            let destinationVC = segue.destination as! ToDoListViewController
            destinationVC.selectedCategory = sender as? Category
        }
    }


}

