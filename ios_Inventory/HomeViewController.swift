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
        dbRef = FIRDatabase.database().reference().child("inventory-items")
        //let itemOne = Item(name: "Bacon", price: 2.00, category: "Groceries & Food")
        //let itemRef = self.dbRef.child("Bacon".lowercaseString)
        //itemRef.setValue(itemOne.toAnyObject())
        
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.sizeToFit()
        self.homeTableView.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        self.searchController.searchResultsUpdater = self
        self.searchController.dimsBackgroundDuringPresentation = false
        startObservingDB()
        self.homeTableView.reloadData()
        
    }
    
    func startObservingDB() {
        dbRef.observeEventType(.Value, withBlock: {(snapshot:FIRDataSnapshot) in
            for item in snapshot.children {
                let itemObject = Item(snapshot:item as! FIRDataSnapshot)
                self.itemArray.append(itemObject)
            }
            self.homeTableView.reloadData()
            }) {(error:NSError) in
                print(error.description)
        }
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
    
    func roundToPlaces(value:Double, places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(value * divisor) / divisor
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        homeTableView.deselectRowAtIndexPath(indexPath, animated: true)
        if (searchController.active && searchController.searchBar.text != "") {
            var item:Item
            item = filterItemArray[indexPath.row]
            var price = item.price + 0.000001
            price = roundToPlaces(price, places: 2)
            let alert = UIAlertController(title: item.name, message: "Price: $\(price)\nQuantity: \nNotes: ", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    //Search -- general search works fine
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = self.searchController.searchBar.text
        filterContentForSearchText(searchText!)
        self.homeTableView.reloadData()
    }
    
    func filterContentForSearchText(searchText:String, scope: String="Title") {
        self.filterItemArray = self.itemArray.filter({(item: Item) -> Bool in
            let categoryMatch = (scope == "Title")
            let stringMatch = item.name.lowercaseString.containsString(searchText.lowercaseString)
            return categoryMatch && stringMatch
        })
    }
    
    
    func searchDisplayController(controller: UISearchController, shouldReloadTableForString searchString: String!) -> Bool {
        filterContentForSearchText(searchString, scope: "Title")
        return true
    }
    
    func filterCategoryItems(var destination: [Item], category: String) -> [Item] {
        for item in itemArray {
            if item.category == category {
                destination += [item]
            }
        }
        return destination
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == "Category" {
            if (searchController.active && searchController.searchBar.text != "")  {
                return false
            }
        }
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Category" {
            let itemVC = segue.destinationViewController as! ItemCategoryTableViewController
            if (segue.identifier == "Category" && searchController.active && searchController.searchBar.text != "")  {
            } else if segue.identifier == "Category" {
                itemVC.categoryTitle = segueList[(homeTableView.indexPathForSelectedRow?.row)!]
                itemVC.categoryItems = filterCategoryItems(itemVC.categoryItems, category: itemVC.categoryTitle)
                itemVC.allItems = itemArray
                print("done")
                print(itemVC.allItems)
            }
        } else if segue.identifier == "addItem" {
            let addVC = segue.destinationViewController as! AddItemViewController
            addVC.itemArray = itemArray
            addVC.allItems = itemArray
            print(addVC.allItems)
        }
    }
}

