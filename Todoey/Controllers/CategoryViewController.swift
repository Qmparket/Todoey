//
//  CategoryViewController.swift
//  Todoey
//
//  Created by d.genkov on 9/10/18.
//  Copyright © 2018 d.genkov. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework


class CategoryViewController: SwipeTableViewController{
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    
   

    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        tableView.separatorStyle = .none
    }
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let cellColor = categories?[indexPath.row].cellColor {
        
            cell.backgroundColor = UIColor(hexString: cellColor)
            guard let categoryColor = UIColor(hexString: cellColor) else {fatalError()}
            
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
            
            cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    
    //MARK: - Data Manipulation Methods
    func saveCategory(category : Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving data", error)
        }
        
        tableView.reloadData()
    }
    
    func loadCategory() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    //MARK: - Delete Data from Swipe
    
    override func updateModel(at indexPath: IndexPath) {
        if let categoryToDelete = self.categories?[indexPath.row] {
            do{
                try self.realm.write {
                    self.realm.delete(categoryToDelete)
                }
            }catch {
                print("error deleting category", error)
            }
        }
    }
    
    
    //MARK: - Add new Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add category", style: .default) { (action) in
            if let newName = textField.text {
                
                let newCategory = Category()
                
                newCategory.name = newName
                
                newCategory.cellColor = UIColor.randomFlat.hexValue()
                
                self.saveCategory(category: newCategory)
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new category ..."
            
            textField = alertTextField
        }
        
        alert.addAction(alertAction)
        
        present(alert,animated: true,completion: nil)
    }
 
}


