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
    var itemSearchResults: String?
    var itemArray = [testItem]()
    var filterItemArray = [testItem]()
    var showSearchResults = false
    var categoryArray: [testItem] = [
        testItem(name: "Clothing, Shoes & Accesories"),
        testItem(name: "Home & Garden"),
        testItem(name: "Electronics & Office"),
        testItem(name: "Toys & Video Games"),
        testItem(name: "Sports, Fitness & Outdoors"),
        testItem(name: "Beauty & Health"),
        testItem(name: "Groceries"),
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.itemArray += [testItem(name: "Bacon")]
        self.itemArray += [testItem(name: "Eggs")]
        self.itemArray += [testItem(name: "Sandwich")]
        self.itemArray += [testItem(name: "Burrito")]
        self.itemArray += [testItem(name: "Chicken")]
        self.itemArray += [testItem(name: "Beans")]
        self.itemArray += [testItem(name: "Lettuce")]
        self.itemArray += [testItem(name: "Onions")]
        self.itemArray += [testItem(name: "Crackers")]
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.sizeToFit()
        homeTableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
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
        "Groceries"
    ]
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (searchController.active) {
            return self.filterItemArray.count
        } else {
            return self.categoryArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.homeTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        var item:testItem
        if (searchController.active) {
            item = self.filterItemArray[indexPath.row]
        } else {
            item = self.categoryArray[indexPath.row]
        }
        cell.textLabel?.text = item.name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        homeTableView.deselectRowAtIndexPath(indexPath, animated: true)
        var item:testItem
        if (searchController.active) {
            item = self.filterItemArray[indexPath.row]
        } else {
            item = self.categoryArray[indexPath.row]
        }
        print(item.name)
    }
    
    //Search
    func filterContentForSearchText(searchText:String, scope: String="Title") {
        self.filterItemArray = self.itemArray.filter({(item: testItem) -> Bool in
            let categoryMatch = (scope == "Title")
            let stringMatch = item.name.rangeOfString(searchText)
            return categoryMatch && (stringMatch != nil)
        })
    }
    
    func searchDisplayController(controller: UISearchController, shouldReloadTableForString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString, scope: "Title")
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print(segue.identifier)
        if segueList.contains(segue.identifier!)  {
            let itemVC = segue.destinationViewController as! ItemCategoryTableViewController
            itemVC.categoryTitle = segue.identifier
        }
    }
}

