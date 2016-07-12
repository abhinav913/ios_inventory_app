//
//  FirstViewController.swift
//  ios_Inventory
//
//  Created by Abhinav Shah on 7/7/16.
//  Copyright © 2016 Abhinav Shah. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UISearchResultsUpdating, UITableViewDataSource  {

    @IBOutlet weak var homeTableView: UITableView!
    var searchController: UISearchController!
    var segueName = "start"
    var itemSearchResults: String?
    var itemArray = [testItem]()
    var filterItemArray = [testItem]()
    var showSearchResults = false
    var categoryArray: [categoryItem] = [
        categoryItem(name: "Clothing, Shoes & Accesories"),
        categoryItem(name: "Home & Garden"),
        categoryItem(name: "Electronics & Office"),
        categoryItem(name: "Toys & Video Games"),
        categoryItem(name: "Sports, Fitness & Outdoors"),
        categoryItem(name: "Beauty & Health"),
        categoryItem(name: "Groceries & Food"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemArray += [testItem(name: "Bacon", category: "Clothing, Shoes & Accesories")]
        itemArray += [testItem(name: "Eggs", category: "Groceries & Food")]
        itemArray += [testItem(name: "Sandwich", category: "Sports, Fitness & Outdoors")]
        itemArray += [testItem(name: "Burrito", category: "Groceries & Food")]
        itemArray += [testItem(name: "Chicken", category: "Groceries & Food")]
        itemArray += [testItem(name: "Beans", category: "Groceries & Food")]
        itemArray += [testItem(name: "Lettuce", category: "Toys & Video Games")]
        itemArray += [testItem(name: "Onions", category: "Toys & Video Games")]
        itemArray += [testItem(name: "Crackers", category: "Toys & Video Games")]
        
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
            var item:testItem
            item = filterItemArray[indexPath.row]
            cell.textLabel?.text = item.name
        } else {
            var item:categoryItem
            item = categoryArray[indexPath.row]
            cell.textLabel?.text = item.name
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        homeTableView.deselectRowAtIndexPath(indexPath, animated: true)
        if (searchController.active && searchController.searchBar.text != "") {
            var item:testItem
            item = filterItemArray[indexPath.row]
            segueName = item.name
        } else {
            var item:categoryItem
            item = categoryArray[indexPath.row]
            segueName = item.name
        }
    }
    
    //Search
    func filterContentForSearchText(searchText:String, scope: String="Title") {
        filterItemArray = itemArray.filter({(item: testItem) -> Bool in
            let categoryMatch = (scope == "Title")
            let stringMatch = item.name.lowercaseString.containsString(searchText)
            return categoryMatch && stringMatch
        })
    }
    
    func searchDisplayController(controller: UISearchController, shouldReloadTableForString searchString: String!) -> Bool {
        filterContentForSearchText(searchString, scope: "Title")
        return true
    }
    
    func filterCategoryItems(var dst: [testItem], category: String) -> [testItem] {
        for item in itemArray {
            if item.category == category {
                dst += [item]
            }
        }
        return dst
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

