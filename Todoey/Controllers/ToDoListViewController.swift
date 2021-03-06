//
//  ViewController.swift
//  Todoey
//
//  Created by d.genkov on 9/4/18.
//  Copyright © 2018 d.genkov. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController{
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
    var selectedCategory : Category? {
        didSet{
            	loadItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let colorHex = selectedCategory?.cellColor else { fatalError() }
            
            title = selectedCategory!.name
        
        updateNavBar(withHexCode: colorHex)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        updateNavBar(withHexCode: "9BDAFA")
    }
    
    //MARK: - Nav bar setup Methods
    
    func updateNavBar (withHexCode hexCode: String) {
        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")}
        guard let navbarColor = UIColor(hexString: hexCode) else { fatalError() }
        
        navBar.tintColor = ContrastColorOf(navbarColor, returnFlat: true)
        
        searchBar.barTintColor = navbarColor
        
        navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navbarColor, returnFlat: true)]
        
        navBar.barTintColor = navbarColor
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            let colorValue =  UIColor(hexString: selectedCategory!.cellColor)
            if let color = colorValue?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(todoItems!.count)) {

                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)

            }
            
            
            cell.accessoryType = item.done ? .checkmark : .none
            } else {
                cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //MARK - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    //realm.delete(item)
                    item.done = !item.done
                }
            }catch {
                print("error updating items")
            }
        }
        tableView.reloadData()
    
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //Mark - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user hits the add item on the alert
            if let newTitle = textField.text {
                if let currentCategory = self.selectedCategory {
                    
                    do {
                        try self.realm.write {
                            let newItem = Item()
                            newItem.title = newTitle
                            currentCategory.items.append(newItem)
                            newItem.dateCreated = Date()
                            self.realm.add(newItem)
                            self.tableView.reloadData()
                        }
                    }catch {
                        print("error saving item")
                    }
                }
                
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "create new item..."
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true,completion: nil)
       
    }
 
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    //MARK: - Delete Items
    override func updateModel(at indexPath: IndexPath) {
        if let itemToDelete = todoItems?[indexPath.row] {
            do{
                try realm.write {
                    realm.delete(itemToDelete)
                }
            } catch {
                print("error deleting item \(error)")
            }
        }
    }
    
}

//MARK: - search bar methods

extension ToDoListViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }


}
