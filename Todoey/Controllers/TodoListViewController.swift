//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

@available(iOS 16.0, *)
class TodoListViewController: UITableViewController {

	var itemArray = [Item]()
	
	let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appending(component: "Items.plist")
	
	let defaults = UserDefaults.standard
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		print(dataFilePath!) 
		
		loadItems()
		
		
		
		
    }
	//MARK: - TableView Datasource Methods

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return itemArray.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
		
		let item = itemArray[indexPath.row]
		
		cell.textLabel?.text = item.title
		
		cell.accessoryType = item.done ? .checkmark : .none
		return cell
	}
	
	//MARK: - TableView Delegate Methods
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//		print(itemArray[indexPath.row])
		
		itemArray[indexPath.row].done.toggle()
		
		saveItems()
		
		tableView.deselectRow(at: indexPath, animated: true)
	}

	//MARK: - Add New Items
	
	@IBAction func addPressed(_ sender: UIBarButtonItem) {
		
		var textField = UITextField()
		
		let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
		
		let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
			//what will happen once the user clicks the Add Item button on our UIAlert
			
			let newItem = Item()
			newItem.title = textField.text!
			self.itemArray.append(newItem)
			
			self.saveItems()
			
		}
		
		alert.addTextField{ (alertTextField) in
			alertTextField.placeholder = "Create New Item"
			
			textField = alertTextField
			print("textField modified")
		}
		
		alert.addAction(action)
		
		present(alert, animated: true, completion: nil)
	}
	
	//MARK: - Model Manipulation Methods
	
	func saveItems() {
		let encoder = PropertyListEncoder()
		
		do {
			let data = try encoder.encode(itemArray)
			try data.write(to: dataFilePath!)
		} catch {
			print("Error encoding item array, \(error)")
		}
		
		self.tableView.reloadData()
		
	}
	
	func loadItems() {
		if let data = try? Data(contentsOf: dataFilePath!) {
			let decoder = PropertyListDecoder()
			do {
				itemArray = try decoder.decode([Item].self, from: data)
			} catch {
				print("Error decoding item array, \(error)")
			}
		}
	}
}

