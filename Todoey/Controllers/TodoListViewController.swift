//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
//    let defaults = UserDefaults.standard

    // to utilize NSCoder and find the folder of the app inside app's sandbox
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        print(dataFilePath)
//        
//        let newTask = Task()
//        newTask.title = "Buy milk"
//        itemArray.append(newTask)
//        
//        let newTask2 = Task()
//        newTask2.title = "Buy Pizza"
//        itemArray.append(newTask2)
//        
//        let newTask3 = Task()
//        newTask3.title = "Buy Eggs"
//        itemArray.append(newTask3)
        
//        The as? operator is used for conditional type casting. It tries to cast the array to [String]. If the cast succeeds, it returns the array of strings; otherwise, it returns nil.
//        if let items = defaults.array(forKey: "TodoListArray") as? [Task] {
//            print("Executed \(items)")
//            itemArray = items  // set the stored user-default array to use on our app
//        }
        
        // to load the items stored in the plist by decoding it into the itemArray
        loadItems()
        
    }
    
    //MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    // this function runs for as many times as the number of rows returned from the above method
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let item = itemArray[indexPath.row]
        
//        print("cellForRowAtIndexPath Called")
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
//        cell?.textLabel?.text = item // will be depriccated in the future iOS versions
        
        // Configure the cell's content
        var cellContent = cell.defaultContentConfiguration()
        cellContent.text = item.title
        
        cell.contentConfiguration = cellContent
        
//        item.done ? (cell.accessoryType = .checkmark) : (cell.accessoryType = .none)
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(itemArray[indexPath.row])
        
        itemArray[indexPath.row].done.toggle()  // only reflected in the itemArray but needs to be stored in our plist
        
        saveItems()
        
//        tableView.reloadData()  // forces the table view to call its data source methods again
        
        // to add a checkmark when a cell gets selected and remove checkmark if already selected
//        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .none
//        } else {
//            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//        }
        
        // to provide gray background selection animation when clicking on a row
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //MARK: - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()  // creating local variable to extend the scope of alertTextField below
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            // what will happen once the user clicks the Add Item button on our UIAlert
            
            let newTask = Item()
            newTask.title = textField.text!
            
            self.itemArray.append(newTask)
            
//            self.defaults.set(self.itemArray, forKey: "TodoListArray") //  User Defaults store data as a Key-Value pair
            
            self.saveItems()
            
        }
        
        
        // Add a textfield to the alert message (Only triggered at the point when the alert pops up and the text field is added to the alert)
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField  // extending the scope of alertTextField to be available inside addButtonPressed
            
        }
        
        alert.addAction(action)  // the above action to be done is added in the action sheet of the app
        
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Model Manipulation Methods (For NSCoder)

    func saveItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(self.itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        tableView.reloadData()  // to reload new data into the table
    }
    
    
    func loadItems() {
        
        // try? halyo vani Do{} vitra halnu parena
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding item array, \(error).")
            }
        }
    }
    
}



