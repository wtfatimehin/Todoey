//
//  ViewController.swift
//  Todoey
//
//  Created by Willie Fatimehin on 6/27/18.
//  Copyright © 2018 Opia. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")

    override func viewDidLoad() {
        super.viewDidLoad()
        

        print(dataFilePath)
        
        loadItems()
    }
    
    //Tableview Datasource Methods
    
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
    
    //Tableview Delegate Methods(use for selection of the cell by uder)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // print(itemArray[indexPath.row])
        
        
        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        } else {
//            itemArray[indexPath.row].done = false
//        }
        //same as above code
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        //add a check mark at cell the current cell that is selected, if already selected delete check if pressed again
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        //keeps selction from staying gray/ goes back to regular unselected view
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    //Add New Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todey Item", message: "", preferredStyle:  .alert)
        
        
        //what will happen once the user clicks the Add Item button on our UIAlert
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            
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
        
        let encoder = PropertyListEncoder()
        
            do {
                let data = try encoder.encode(itemArray)
                try data.write(to: dataFilePath!)
            } catch {
                print("Error encoding item array, \(error)")
        }
        
        //updates the tableview
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data  = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            } catch  {
                print("Error decoding item array \(error)")
            }
        }
    }
    

}

