//
//  ViewController.swift
//  Todoey
//
//  Created by Willie Fatimehin on 6/27/18.
//  Copyright © 2018 Opia. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
   
    //UIApplication.shared is a singleton
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
    }
    
    //MARK: Tableview Datasource Methods
    
    //Returns three cells in table view for itemArray
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //asks the data source for a cell to insert in a particular location of the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        
        //*Ternanry Opertator ==>
        //Value = condition ? valueIfTrue : valueIfFalse
        cell.accessoryType = item.done  ? .checkmark :  .none
        
//        same
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        } else {
//            cell.accessoryType = .none
//        }
        //*
        
        return cell
        
    }
    
    //MARK: Tableview Delegate Methods(use for selection of the cell by uder)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       //*** order matters **//
        
//        //remove data from temp area in database
//        context.delete(itemArray[indexPath.row])
//        //remove data from our current array
//        itemArray.remove(at: indexPath.row)
        
        //**///////////////**//
        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        //same as above code
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        //keeps selction from staying gray/ goes back to regular unselected view
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    //Add New Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle:  .alert)
        
        
        //what will happen once the user clicks the Add Item button on our UIAlert
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            
           self.saveItems()
        }
        
        //textfield
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField

        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    func saveItems() {
        
            do {
                try context.save()
            } catch {
                print("Error saving context \(error)")
        }
        
        //updates the tableview
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalOPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: additionalOPredicate)
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
         itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    

}
//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        let request: NSFetchRequest<Item> = Item.fetchRequest()
       
        //adding query for search (%@ how data should be fetched in objectiveC)
         let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
         request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            // manager assigns these projects to different threads
            DispatchQueue.main.async {
                //search bar is no longer selected
                searchBar.resignFirstResponder()
            }
            
           
        }
    }
}

