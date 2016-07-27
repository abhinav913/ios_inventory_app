//
//  ItemCategoryTableViewController.swift
//  ios_Inventory
//
//  Created by Abhinav Shah on 7/8/16.
//  Copyright © 2016 Abhinav Shah. All rights reserved.
//

import UIKit
import FirebaseDatabase


class ItemCategoryTableViewController: UITableViewController {
    
    @IBOutlet var itemTableView: UITableView!
    var searchController: UISearchController!
    var itemSearchResults: String?
    var categoryTitle: String!
    var categoryItems = [Item]()
    var filterItems:[Item] = []
    var allItems:[Item] = []
    var dbCheck = true
    
    var dbRef:FIRDatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = categoryTitle
        dbRef = FIRDatabase.database().reference().child("inventory-items")
        if dbCheck {
            startObservingDB()
        }
        self.navigationItem.title = categoryTitle
        self.searchController = UISearchController(searchResultsController: nil)
        self.searchController.searchBar.sizeToFit()
        self.itemTableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
        definesPresentationContext = true
        self.searchController.dimsBackgroundDuringPresentation = false
        self.itemTableView.reloadData()

        
        print(categoryItems)
    }
    
    func startObservingDB() {
        dbRef.observeEventType(.Value, withBlock: {(snapshot:FIRDataSnapshot) in
            var newItems = [Item]()
            for item in snapshot.children {
                let itemObject = Item(snapshot:item as! FIRDataSnapshot)
                if (itemObject.category == self.categoryTitle) {
                    newItems.append(itemObject)
                }
            }
            self.categoryItems = newItems
            self.tableView.reloadData()
            
            }) {(error:NSError) in
                print(error.description)
        }
        
    }


    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (searchController.active && searchController.searchBar.text != "") {
            return self.filterItems.count
        } else {
            return self.categoryItems.count
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = itemTableView.dequeueReusableCellWithIdentifier("Item", forIndexPath: indexPath)
        var item:Item
        if (searchController.active && searchController.searchBar.text != "") {
            item = self.filterItems[indexPath.row]
        } else {
            item = self.categoryItems[indexPath.row]
        }
        cell.textLabel?.text = item.name
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (searchController.active && searchController.searchBar.text != "") {
            showAlert(self.filterItems[indexPath.row].name, price: self.categoryItems[indexPath.row].price)
        } else {
            showAlert(self.categoryItems[indexPath.row].name, price: self.categoryItems[indexPath.row].price)
        }
        self.itemTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let item = categoryItems[indexPath.row]
            item.itemRef?.removeValue()
        }
    }
    
    func roundToPlaces(value:Double, places:Int) -> Double {
        let divisor = pow(10.00, Double(places))
        return round(value * divisor) / divisor
    }
    
    func showAlert(item: String, var price: Double) {
        price += 0.0000001
        price = roundToPlaces(price, places: 2)
        let alert = UIAlertController(title: item, message: "Price: $\(price)\nQuantity: \nNotes: ", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Sell", style: UIAlertActionStyle.Destructive, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    //SEARCH --works    
    func filterContentForSearchText(searchText:String, scope: String="Title") {
        self.filterItems = self.categoryItems.filter({(item: Item) -> Bool in
            let categoryMatch = (scope == "Title")
            let stringMatch = item.name.lowercaseString.containsString(searchText.lowercaseString)
            return categoryMatch && stringMatch
        })
        self.itemTableView.reloadData()
    }
    
    func searchDisplayController(controller: UISearchController, shouldReloadTableForString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString, scope: "Title")
        return true
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */


    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addItem" {
            let addVC = segue.destinationViewController as! AddItemViewController
            addVC.categoryName = categoryTitle
            addVC.itemArray = categoryItems
            addVC.allItems = allItems
        }
    }


}

extension ItemCategoryTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchText = self.searchController.searchBar.text
        filterContentForSearchText(searchText!)
        self.itemTableView.reloadData()
    }
}
