//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        
        // special keyword didSet. Everything inside its {} is going to be executed as soon as selectedCategory variable gets set with a value. We do this instead of writing loadItems() in viewDidLoad to prevent app crash
        didSet {
            loadItems()
        }
    } // ? because its value is nil until the category is selected in the CategoryViewController and segue is performed
    
    //    let defaults = UserDefaults.standard
    
    // to utilize NSCoder and find the folder of the app inside app's sandbox
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // we can create AppDelegate's object as (UIApplication.shared.delegate as! AppDelegate)
    // Description:
    // shared is a singleton which corresponds to the current app running on a user's iphone as an object
    // delegate of shared singleton and our AppDelegate inherits from the same superclass, so the downcasting is valid
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //        print(dataFilePath)
        
        // to get a path of where our data is being stored for our current app
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
//        loadItems()  // default value for the parameter will be used inside the method definination (load items with the entire list)
        
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
        
        // To update the NSManaged Object [Update(U) in CRUD]
//        itemArray[indexPath.row].setValue("Completed", forKey: "title")
        
//        context.delete(itemArray[indexPath.row])  // finds the current NSManagedObject from the persistent container and deletes it in the temporary area (in the context)
//        itemArray.remove(at: indexPath.row)  // will only remove from the item array (first we remove the item from the persistent storage and then only we remove from the array to avoid app crash due to indexing)
        
        
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
        
        // what will happen once the user clicks the Add Item button on our UIAlert
        
        var textField = UITextField()  // creating local variable to extend the scope of alertTextField below
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { action in
            
            // triggered when Add Item is pressed in our alert
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            
            newItem.parentCategory = self.selectedCategory
            
            
            self.itemArray.append(newItem)
            
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
        
        // using Core Data
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        
        tableView.reloadData()  // to reload new data into the table
    }
    
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
//        let request: NSFetchRequest<Item> = Item.fetchRequest() // <Item> means that it is going to fetch requests in the form of this data type i.e. the Entity that we're trying to request
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        // 'local varibale predicate value only comes up when searching in the search bar
        if let additionalPredicate = predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
            
            request.predicate = compoundPredicate
        } else {
            request.predicate = categoryPredicate
        }
        
        
        
        do {
            itemArray = try context.fetch(request)  // returns every Item in an array (i.e NSManagedObject) in our Persistent Container
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
}


//MARK: - UISearchBarDelegate Methods

extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        // Quering Objects in Core Data (predicate tells how we want to query our database)
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true) // how to order a collection of objects
        
        request.sortDescriptors = [sortDescriptor] // can have multiple descriptors in the array
        
        loadItems(with: request, predicate: predicate)  // send request and predicate separately to ensure that the search logic works in Categorical Implementation of our app
    
    }
    
    // triggered when the text inside the search bar is changed
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            // Updating the UI in the main thread. async means the task must be carried out immediately/parallely
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


