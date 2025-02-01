//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        The as? operator is used for conditional type casting. It tries to cast the array to [String]. If the cast succeeds, it returns the array of strings; otherwise, it returns nil.
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items  // set the stored user-default array to use on our app
        }
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // this function runs for as many times as the number of rows returned from the above method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = itemArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
//        cell?.textLabel?.text = item // will be depriccated in the future iOS versions
        
        // Configure the cell's content
        var cellContent = cell.defaultContentConfiguration()
        cellContent.text = item
        cell.contentConfiguration = cellContent
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        // to add a checkmark when a cell gets selected and remove checkmark if already selected
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        // to provide gray background selection animation when clicking on a row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()  // creating local variable to extend the scope of alertTextField below
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            // what will happen once the user clicks the Add Item button on our UIAlert
            
            self.itemArray.append(textField.text!)
            
            self.defaults.set(self.itemArray, forKey: "TodoListArray") // User Defaults store data as a Key-Value pair
            
            self.tableView.reloadData()
            
        }
        
        
        // Add a textfield to the alert message (Only triggered at the point when the alert pops up and the text field is added to the alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField  // extending the scope of alertTextField to be available inside addButtonPressed
            
        }
        
        alert.addAction(action)  // the above action to be done is added in the action sheet of the app
        
        present(alert, animated: true, completion: nil)
        
        
    }
    

}

