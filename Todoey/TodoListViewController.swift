//
//  ViewController.swift
//  Todoey
//
//  Created by Willie Fatimehin on 6/27/18.
//  Copyright © 2018 Opia. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    var itemArray = ["Find Mike", "Buy Eggos", "Destory Demogorgon"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //Tableview Datasource Methods
    
    //Returns three cells in table view for itemArray
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //asks the data source for a cell to insert in a particular location of the table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    //Tableview Delegate Methods(use for selection of the cell by uder)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       // print(itemArray[indexPath.row])
        
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
            
            self.itemArray.append(textField.text!)
            
            //updates the tableview 
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
    


}

