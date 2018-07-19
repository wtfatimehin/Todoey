//
//  ViewController.swift
//  Todoey
//
//  Created by Willie Fatimehin on 6/27/18.
//  Copyright © 2018 Opia. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
    
    }
    
    
    //before app displays loaded view in viewcontroller
    override func viewWillAppear(_ animated: Bool) {
        
        //populates the title in the navbar
        title = selectedCategory?.name
        
        guard let colorHex = selectedCategory?.color else {fatalError()}
        
        updateNavBar(withHexCode: colorHex)
        
    }
    
    
    
    //gets called when view is just about to be removed from view hierchary or navstack
    override func viewWillDisappear(_ animated: Bool) {
        
        updateNavBar(withHexCode: "1D98F6")
    }
    
    
    
    //MARK: - Nav Bar Setup Methods
    func updateNavBar(withHexCode colorHexCode: String ) {
        
        guard let navBar = navigationController?.navigationBar else {fatalError("Navigation controller does not exist.")}
        
        guard let navBarColor = UIColor(hexString: colorHexCode) else { fatalError()}
        
        guard  let colorHex = selectedCategory?.color else { fatalError() }
        
        navBar.barTintColor = navBarColor
        
        //applies to navbutton and Barbutton items
        navBar.tintColor = ContrastColorOf(navBarColor, returnFlat: true)
        
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: ContrastColorOf(navBarColor, returnFlat: true)]
        
        searchBar.barTintColor = navBarColor
    }
    
    
    
    //MARK: Tableview Datasource Methods
        //Returns three cells in table view for itemArray
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    
    
    //asks the data source for a cell to insert in a particular location of the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            //Gradient
            //            print("version 1: \(CGFloat(indexPath.row / todoItems!.count))")
            //
            //            print("version 2: \(CGFloat(indexPath.row) / CGFloat(todoItems!.count))")
            if let color = UIColor(hexString: selectedCategory!.color)?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {
                
                    cell.backgroundColor = color
                    cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
                }
            
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
            
        } else {
            cell.textLabel?.text = "No items Added"
        }
        return cell
        
    }
    
    
    
    //MARK: Tableview Delegate Methods(use for selection of the cell by order)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        
        tableView.reloadData()
        
        //keeps selction from staying gray/ goes back to regular unselected view
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    
    
    //Add New Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle:  .alert)
        
        
        //what will happen once the user clicks the Add Item button on our UIAlert
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
                } catch {
                    print("Error saving new items \(error)")
                }
            }
            
            self.tableView.reloadData()
        }
        
        //textfield
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField

        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
   
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
    
    override func updateModel(at indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row]  {
            do {
             try realm.write {
                realm.delete(item)
            }
            } catch {
                print("Error deleting Item, \(error)")
            }
        }
    }

}


//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        
        tableView.reloadData()
        
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

