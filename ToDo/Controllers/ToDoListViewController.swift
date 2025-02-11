//
//  ViewController.swift
//  ToDo
//
//  Created by Sariyya Abdullayeva on 06.02.2025.
//

import UIKit

class ToDoListViewController: UITableViewController {
    var itemArray: [Item] = [
        Item(title: "Buy groceries"),
        Item(title: "Walk the dog"),
        Item(title: "Finish Swift tutorial"),
    ]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load saved items from the .plist
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
        saveItems()
        return cell
    }
    
    //Mark- tableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Add a checkmark to the selected cell (toggle checkmark)
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // Reload the row to update the checkmark
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        // Animation: Deselect the row after selection to remove the highlight effect
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        // Let's create add new item functionality to our todoapp.
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle:.alert)
        
        //Text field to the alert
        alert.addTextField { (textField) in
            textField.placeholder = "Enter new item"
        }
        
        // "Add" action
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            // Get the text fron the text field
            if let newItem = alert.textFields?.first?.text, !newItem.isEmpty{
                //add item to itemArray
                self.itemArray.append(Item(title: newItem))
                
                // saving for persisstency
                self.saveItems()
                
                // reload the table view to display the new item
                self.tableView.reloadData()
            }
        }
        
        
        // Add "Cancel" action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        // Add actions to the alert controller
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        //Present the alert
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        // Get the path to the "Items.plist" file in the Documents directory
        guard let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") else {
            print("Failed to get file path")
            return
        }
        
        // Encode the itemArray into Data using PropertyListEncoder
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath)
            print("Items saved successfully to \(dataFilePath)")
        } catch {
            print("Failed to save items: \(error)")
        }
    }
    
    func loadItems() {
        // Get the path to the "Items.plist" file in the Documents directory
        guard let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") else {
            print("Failed to get file path")
            return
        }
        
        // Check if the file exists before attempting to read it
        if !FileManager.default.fileExists(atPath: dataFilePath.path) {
            print("No existing file found, skipping load.")
            return
        }
        // Decode the data from the .plist file using PropertyListDecoder
        let decoder = PropertyListDecoder()
        do {
            let data = try Data(contentsOf: dataFilePath)
            itemArray = try decoder.decode([Item].self, from: data)
            print("Items loaded successfully from \(dataFilePath)")
        } catch {
            print("Failed to load items: \(error)")
        }
    }
    
}

