//
//  ViewController.swift
//  ToDo
//
//  Created by Sariyya Abdullayeva on 06.02.2025.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
//    @IBOutlet weak var UISearchBar: UISearchBar!

    var itemArray = [Item]()
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeader()
    }
    
    private func setHeader() {
        let headerLabel = UILabel()
            headerLabel.text = selectedCategory?.name ?? "To-Do List"
            headerLabel.font = UIFont(name: "Nunito-Bold", size: 30)
            headerLabel.numberOfLines = 0
//            headerLabel.textColor = .white
            
            // color of the category
            let categoryColor = UIColor(named: selectedCategory?.colorName ?? CategoryColor.defaultColor) ?? .systemBlue

            let padding: CGFloat = 16
            let labelHeight: CGFloat = 44
            headerLabel.frame = CGRect(x: padding, y: 8, width: tableView.frame.width - 2 * padding, height: labelHeight)
            
            // Container view for padding and background
            let containerHeight = labelHeight + 16
            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: containerHeight))
            
            containerView.backgroundColor =  categoryColor.withAlphaComponent(0.0)
            
            containerView.addSubview(headerLabel)
            tableView.tableHeaderView = containerView
            

        let backgroundView = UIView()
        backgroundView.backgroundColor = categoryColor
//        backgroundView.backgroundColor = categoryColor.withAlphaComponent(0.2)
        tableView.backgroundView = backgroundView
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar(with: .white)
        // Ensure back button and title are white
        navigationController?.navigationBar.tintColor = .systemBlue
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Enter new item"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let newItemText = alert.textFields?.first?.text, !newItemText.isEmpty {
                let newItem = Item(context: self.context)
                newItem.title = newItemText
                
                newItem.parentCategory = self.selectedCategory
                
                self.itemArray.append(newItem)
                self.saveData()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving data to Core Data: \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems() {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory == %@", selectedCategory!)
        
        request.predicate = categoryPredicate
        
        do {
            itemArray = try context.fetch(request)
            tableView.reloadData()
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
    }
}

//// MARK: - UISearchBarDelegate
//extension ToDoListViewController: UISearchBarDelegate {
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        DispatchQueue.main.async {
//            searchBar.becomeFirstResponder() // Forces keyboard to appear
//        }
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchBar.text?.count == 0{
//            loadItems()
//            DispatchQueue.main.async {
//                searchBar.resignFirstResponder()
//            }
//        }else {
//            filterItems(with: searchText)
//            tableView.reloadData()
//        }
//    }
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//    }
//    
//    private func filterItems(with searchText: String) {
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//        
//        
//        let categoryPredicate = NSPredicate(format: "parentCategory == %@", selectedCategory!)
//        let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
//        
//        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, searchPredicate])
//        
//        
//        do {
//            itemArray = try context.fetch(request)
//        } catch {
//            print("Error fetching filtered data: \(error)")
//        }
//    }
//}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ToDoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        cell.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemArray[indexPath.row].done.toggle()
        saveData()
        tableView.reloadRows(at: [indexPath], with: .automatic)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = itemArray[indexPath.row]
            
            // Show confirmation alert
            let alert = UIAlertController(title: "Delete Item",
                                          message: "Are you sure you want to delete \"\(itemToDelete.title ?? "this item")\"?",
                                          preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                self.context.delete(itemToDelete)
                self.itemArray.remove(at: indexPath.row)
                self.saveData()
            }))

            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                tableView.setEditing(false, animated: true)
            }))

            present(alert, animated: true)
        }
    }

}
