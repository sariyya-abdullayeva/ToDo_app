//
//  ViewController.swift
//  ToDo
//
//  Created by Sariyya Abdullayeva on 06.02.2025.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    var itemArray = [Item]()
    
    
    // Core Data context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //load previous data
        loadItems()
        
        // Desing code:
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // Ensures no transparency
        appearance.backgroundColor = UIColor.systemBlue // Change this to your desired color
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    //Mark - Tableview Datasource Methods
    //Make items in items array listed in table view
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    //Create an populate cells of the table
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text =  item.title// Set cell text to the corresponding item
        
        cell.accessoryType = item.done ? .checkmark : .none //Set the checkmark based on the `done` property of the item
        
        return cell
    }
    
    //Mark- tableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1. Toggle the 'done' property in Core Data
        itemArray[indexPath.row].done.toggle()
        
        // 2. Save the updated state
        saveData()
        
        // 3. Reload the row to update the checkmark
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        // 4. Deselect the row after selection to remove the highlight effect
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)

        // Text field for user input
        alert.addTextField { (textField) in
            textField.placeholder = "Enter new item"
        }

        // "Add" action
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let newItemText = alert.textFields?.first?.text, !newItemText.isEmpty {
                
                // 1. Create a new Item using the stored Core Data context
                let newItem = Item(context: self.context)
                newItem.title = newItemText
                // 2. Add to itemArray
                self.itemArray.append(newItem)
                
                // 3. Save using saveData()
                self.saveData()
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(addAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }
    
    
    //Mark - Core data functions
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving data to Core Data: \(error)")
        }

        tableView.reloadData()
    }

    
    func loadItems() {
        // 1. Create a fetch request for the Item entity
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            // 2. Fetch items from Core Data and assign them to itemArray
            itemArray = try context.fetch(request)
            tableView.reloadData()  // Refresh the table view with fetched data
            print("Loaded \(itemArray.count) items from Core Data")
        } catch {
            print("Error fetching data from Core Data: \(error)")
        }
    }
}

