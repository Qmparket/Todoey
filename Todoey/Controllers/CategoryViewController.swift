//
//  CategoryViewController.swift
//  Todoey
//
//  Created by d.genkov on 9/10/18.
//  Copyright © 2018 d.genkov. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategory()
    }
    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
       
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
    
    //MARK: - Data Manipulation Methods
    func saveCategory() {
        do {
            try context.save()
        } catch {
            print("Error saving data", error)
        }
        
        tableView.reloadData()
    }
    
    func loadCategory(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("Error loading categories", error)
        }
        
        tableView.reloadData()
    }
    
    
    //MARK: - Add new Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add category", style: .default) { (action) in
            if let newName = textField.text {
                
                let newCategory = Category(context: self.context)
                
                newCategory.name = newName
                
                self.categoryArray.append(newCategory)
                
                self.saveCategory()
            }
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new category ..."
            
            textField = alertTextField
        }
        
        alert.addAction(alertAction)
        
        present(alert,animated: true,completion: nil)
    }
    
    
 
    
}
