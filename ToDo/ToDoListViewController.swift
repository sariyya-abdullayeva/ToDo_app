//
//  ViewController.swift
//  ToDo
//
//  Created by Sariyya Abdullayeva on 06.02.2025.
//

import UIKit

class ToDoListViewController: UITableViewController {
    let itemArray = ["Buy groceries", "Walk the dog", "Finish Swift tutorial", "Read a book", "Exercise"]
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // Ensures no transparency
        appearance.backgroundColor = UIColor.systemBlue // Change this to your desired color
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    //Mark - Tableview Datasource Methods
    // make items in items array listed in table view
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row] // Set cell text to the corresponding item
        return cell
    }
    
    //Mark- tableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("[indexPath.row", indexPath)
        print("Tapped on item: \(itemArray[indexPath.row])") // Logs the tapped item
        
        // Add a checkmark to the selected cell (toggle checkmark)
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = (cell.accessoryType == .checkmark) ? .none : .checkmark
        }
        
        // Deselect the row after selection to remove the highlight effect
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK - Add New Items
}

