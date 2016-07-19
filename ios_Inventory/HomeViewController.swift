//
//  FirstViewController.swift
//  ios_Inventory
//
//  Created by Abhinav Shah on 7/7/16.
//  Copyright © 2016 Abhinav Shah. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HomeViewController: UIViewController, UISearchResultsUpdating, UITableViewDataSource  {

    @IBOutlet weak var homeTableView: UITableView!
    
    var dbRef:FIRDatabaseReference!
    
    var searchController: UISearchController!
    var segueName = "start"
    var itemSearchResults: String?
    var itemArray = [Item]()
    var filterItemArray = [Item]()
    var showSearchResults = false
    var categoryArray: [String] = [
        "Clothing, Shoes & Accesories",
        "Home & Garden",
        "Electronics & Office",
        "Toys & Video Games",
        "Sports, Fitness & Outdoors",
        "Beauty & Health",
        "Groceries & Food",
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        itemArray += [testItem(name: "Bacon", category: "Clothing, Shoes & Accesories")]
        dbRef = FIRDatabase.database().reference().child("inventory-items")
        let itemOne = Item(name: "Bacon", price: 2.00, category: "Groceries & Food")
        let itemRef = self.dbRef.child("Bacon".lowercaseString)
        itemRef.setValue(itemOne.toAnyObject())
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.sizeToFit()
        homeTableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        homeTableView.reloadData()
        
    }
    

    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = searchController.searchBar.text
        filterContentForSearchText(searchText!)
        homeTableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    let segueList:[String] = [
        "Clothing, Shoes & Accesories",
        "Home & Garden",
        "Electronics & Office",
        "Toys & Video Games",
        "Sports, Fitness & Outdoors",
        "Beauty & Health",
        "Groceries & Food"
    ]
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchController.active && searchController.searchBar.text != "") {
            return filterItemArray.count
        } else {
            return categoryArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = homeTableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        if (searchController.active && searchController.searchBar.text != "") {
            var item:Item
            item = filterItemArray[indexPath.row]
            cell.textLabel?.text = item.name
        } else {
            var category:String
            category = categoryArray[indexPath.row]
            cell.textLabel?.text = category
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        homeTableView.deselectRowAtIndexPath(indexPath, animated: true)
        if (searchController.active && searchController.searchBar.text != "") {
            var item:Item
            item = filterItemArray[indexPath.row]
            segueName = item.name
        }
//        else {
//            var category:categoryItem
//            item = categoryArray[indexPath.row]
//            segueName = item.name
//        }
    }
    
    //Search
    func filterContentForSearchText(searchText:String, scope: String="Title") {
        filterItemArray = itemArray.filter({(item: Item) -> Bool in
            let categoryMatch = (scope == "Title")
            let stringMatch = item.name.lowercaseString.containsString(searchText.lowercaseString)
            return categoryMatch && stringMatch
        })
    }
    
    func searchDisplayController(controller: UISearchController, shouldReloadTableForString searchString: String!) -> Bool {
        filterContentForSearchText(searchString, scope: "Title")
        return true
    }
    
    func filterCategoryItems(var destinationArray: [Item], category: String) -> [Item] {
        for item in itemArray {
            if item.category == category {
                destinationArray += [item]
            }
        }
        return destinationArray
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(segue.identifier)
        let itemVC = segue.destinationViewController as! ItemCategoryTableViewController
        if (segue.identifier == "Category" && searchController.active && searchController.searchBar.text != "")  {
            itemVC.categoryTitle = "Search"
        } else if segue.identifier == "Category" {
            itemVC.categoryTitle = segueList[(homeTableView.indexPathForSelectedRow?.row)!]
            itemVC.categoryItems = filterCategoryItems(itemVC.categoryItems, category: itemVC.categoryTitle)
        }
    }
}

